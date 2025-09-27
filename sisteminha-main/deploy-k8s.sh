#!/bin/bash

# Configurações
AWS_PROFILE="default"                        # Perfil AWS CLI
INSTANCE_TYPE="t3.medium"                    # Aumentado para 4GB RAM (t3.small tem apenas 2GB)
KEY_NAME="k8s-key"                           # Nome do par de chaves
SECURITY_GROUP="k8s-sg"                      # Nome do security group
MASTER_TAG="k8s-master"                      # Tag para instância master
WORKER_TAG="k8s-worker"                      # Tag para instância worker
DOCKER_USERNAME="larissasamara"              # Seu usuário do Docker Hub
DOCKER_PASSWORD="Larissa123!"                # Sua senha do Docker Hub
DOCKER_REPO_PREFIX="${DOCKER_USERNAME}/k8s"  # Prefixo para os repositórios
K8S_VERSION="1.29"                           # Versão do Kubernetes
MAX_RETRIES=5                                # Número máximo de tentativas para operações críticas
RETRY_DELAY=10                               # Tempo de espera entre tentativas (segundos)

# Função para verificar e instalar dependências locais
check_local_dependencies() {
    echo "Verificando dependências locais..."
    
    # Verifica AWS CLI
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI não encontrado. Por favor, instale: https://aws.amazon.com/cli/"
        exit 1
    fi
    
    # Verifica Docker
    if ! command -v docker &> /dev/null; then
        echo "Docker não encontrado. Por favor, instale: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    # Verifica jq para processamento JSON
    if ! command -v jq &> /dev/null; then
        echo "jq não encontrado. Instalando..."
        sudo apt-get update && sudo apt-get install -y jq
    fi
    
    echo "Todas as dependências locais estão instaladas."
}

# Função para verificar se uma instância com determinada tag já existe
check_instance_exists() {
    local TAG=$1
    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=$TAG" "Name=instance-state-name,Values=running" \
        --query "Reservations[].Instances[].InstanceId" \
        --output text)
    
    if [ -z "$INSTANCE_ID" ]; then
        return 1 # Não existe
    else
        echo "$INSTANCE_ID"
        return 0 # Existe
    fi
}

# Função para verificar pré-requisitos nas instâncias
check_instance_prerequisites() {
    local NODE_IP=$1
    echo "Verificando pré-requisitos em $NODE_IP..."
    
    ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$NODE_IP << 'EOF'
        # Verificar memória
        MEMORY=$(free -m | awk '/Mem:/ {print $2}')
        if [ "$MEMORY" -lt 1700 ]; then
            echo "AVISO: Memória insuficiente (mínimo recomendado 1700MB, encontrado ${MEMORY}MB)"
        fi
        
        # Verificar CPU
        CPU_COUNT=$(nproc)
        if [ "$CPU_COUNT" -lt 2 ]; then
            echo "AVISO: CPUs insuficientes (mínimo 2, encontrado ${CPU_COUNT})"
        fi
        
        # Verificar swap desativado
        if swapon --show | grep -q .; then
            echo "Desativando swap para Kubernetes..."
            sudo swapoff -a
            sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
        fi
        
        echo "Pré-requisitos verificados"
EOF
}

# Função para configurar infraestrutura AWS
setup_aws_infrastructure() {
    echo "Configurando infraestrutura AWS..."
    
    # Verificar e criar par de chaves
    if ! aws ec2 describe-key-pairs --key-names $KEY_NAME &> /dev/null; then
        echo "Criando par de chaves..."
        aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > ${KEY_NAME}.pem
        chmod 400 ${KEY_NAME}.pem
    else
        echo "Par de chaves já existe."
    fi
    
    # Verificar e criar security group
    SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
        --group-names $SECURITY_GROUP 2>/dev/null | jq -r '.SecurityGroups[0].GroupId')
    
    if [ -z "$SECURITY_GROUP_ID" ] || [ "$SECURITY_GROUP_ID" == "null" ]; then
        echo "Criando security group..."
        SECURITY_GROUP_ID=$(aws ec2 create-security-group \
            --group-name $SECURITY_GROUP \
            --description "Security group for Kubernetes" \
            --query 'GroupId' \
            --output text)
        
        # Autorizar portas necessárias
        aws ec2 authorize-security-group-ingress \
            --group-id $SECURITY_GROUP_ID \
            --protocol tcp \
            --port 22 \
            --cidr 0.0.0.0/0
            
        aws ec2 authorize-security-group-ingress \
            --group-id $SECURITY_GROUP_ID \
            --protocol tcp \
            --port 6443 \
            --cidr 0.0.0.0/0
            
        aws ec2 authorize-security-group-ingress \
            --group-id $SECURITY_GROUP_ID \
            --protocol all \
            --cidr 0.0.0.0/0 \
            --source-group $SECURITY_GROUP_ID
    else
        echo "Security group já existe."
    fi
    
    # Obter a AMI mais recente do Ubuntu 20.04
    AMI=$(aws ec2 describe-images \
        --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" \
        --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
        --output text)
    
    # Verificar e criar instância master
    MASTER_ID=$(check_instance_exists $MASTER_TAG)
    if [ -z "$MASTER_ID" ]; then
        echo "Criando instância master..."
        MASTER_ID=$(aws ec2 run-instances \
            --image-id $AMI \
            --instance-type $INSTANCE_TYPE \
            --key-name $KEY_NAME \
            --security-group-ids $SECURITY_GROUP_ID \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$MASTER_TAG}]" \
            --query 'Instances[0].InstanceId' \
            --output text)
    else
        echo "Instância master já existe: $MASTER_ID"
    fi
    
    # Verificar e criar instância worker
    WORKER_ID=$(check_instance_exists $WORKER_TAG)
    if [ -z "$WORKER_ID" ]; then
        echo "Criando instância worker..."
        WORKER_ID=$(aws ec2 run-instances \
            --image-id $AMI \
            --instance-type $INSTANCE_TYPE \
            --key-name $KEY_NAME \
            --security-group-ids $SECURITY_GROUP_ID \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$WORKER_TAG}]" \
            --query 'Instances[0].InstanceId' \
            --output text)
    else
        echo "Instância worker já existe: $WORKER_ID"
    fi
    
    # Aguardar instâncias estarem em execução (se foram criadas)
    if [ -n "$MASTER_ID" ] || [ -n "$WORKER_ID" ]; then
        echo "Aguardando instâncias estarem em execução..."
        aws ec2 wait instance-running --instance-ids $MASTER_ID $WORKER_ID
        
        # Adicionar pequeno delay para garantir que os serviços estejam totalmente up
        sleep 20
    fi
    
    # Obter IPs públicos
    MASTER_IP=$(aws ec2 describe-instances \
        --instance-ids $MASTER_ID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    
    WORKER_IP=$(aws ec2 describe-instances \
        --instance-ids $WORKER_ID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    
    echo "Master IP: $MASTER_IP"
    echo "Worker IP: $WORKER_IP"
    
    # Criar arquivo de inventário
    echo "[master]" > hosts.ini
    echo "$MASTER_IP ansible_user=ubuntu ansible_ssh_private_key_file=${KEY_NAME}.pem" >> hosts.ini
    echo "[worker]" >> hosts.ini
    echo "$WORKER_IP ansible_user=ubuntu ansible_ssh_private_key_file=${KEY_NAME}.pem" >> hosts.ini
    
    # Exportar IPs para uso posterior
    export MASTER_IP
    export WORKER_IP
}

# Função para instalar containerd
install_containerd() {
    local NODE_IP=$1
    echo "Instalando containerd em $NODE_IP..."
    
    for i in $(seq 1 $MAX_RETRIES); do
        ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$NODE_IP << 'EOF'
            echo "Containerd installation started"
            
            # Configurar módulos do kernel
            cat <<EOL | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOL
            
            sudo modprobe overlay
            sudo modprobe br_netfilter
            
            # Configurar sysctl
            cat <<EOL | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOL
            
            sudo sysctl --system
            
            # Instalar containerd
            sudo apt-get update
            sudo apt-get install -y containerd
            
            # Configurar containerd
            sudo mkdir -p /etc/containerd
            sudo containerd config default | sudo tee /etc/containerd/config.toml
            
            # Habilitar SystemdCgroup
            sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
            
            sudo systemctl restart containerd
            sudo systemctl enable containerd
            
            echo "Containerd installation completed"
EOF
        if [ $? -eq 0 ]; then
            echo "Containerd instalado com sucesso em $NODE_IP"
            return 0
        else
            echo "Tentativa $i de $MAX_RETRIES falhou. Tentando novamente em $RETRY_DELAY segundos..."
            sleep $RETRY_DELAY
        fi
    done
    
    echo "Falha ao instalar containerd em $NODE_IP após $MAX_RETRIES tentativas"
    exit 1
}

# Função para instalar Kubernetes
install_kubernetes_packages() {
    local NODE_IP=$1
    echo "Instalando Kubernetes em $NODE_IP..."
    
    for i in $(seq 1 $MAX_RETRIES); do
        echo "Tentativa $i de $MAX_RETRIES..."
        
        ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$NODE_IP << 'EOF'
            # Atualizar pacotes
            echo "Atualizando pacotes..."
            sudo apt-get update || { echo "Falha ao atualizar pacotes"; exit 1; }
            
            # Instalar dependências
            echo "Instalando dependências..."
            sudo apt-get install -y apt-transport-https ca-certificates curl gpg || { 
                echo "Falha ao instalar dependências";
                # Tentar continuar mesmo se apt-transport-https falhar
                sudo apt-get install -y ca-certificates curl gpg || exit 1;
            }
            
            # Criar diretório para chaves GPG se não existir
            echo "Configurando chave GPG..."
            sudo mkdir -p /etc/apt/keyrings || { echo "Falha ao criar diretório keyrings"; exit 1; }
            
            # Baixar e adicionar chave GPG
            curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg || {
                echo "Falha ao adicionar chave GPG";
                exit 1;
            }
            
            # Adicionar repositório Kubernetes
            echo "Adicionando repositório Kubernetes..."
            echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list || {
                echo "Falha ao adicionar repositório";
                exit 1;
            }
            
            # Atualizar novamente com o novo repositório
            echo "Atualizando lista de pacotes..."
            sudo apt-get update || { echo "Falha ao atualizar após adicionar repositório"; exit 1; }
            
            # Instalar componentes do Kubernetes
            echo "Instalando kubelet, kubeadm e kubectl..."
            sudo apt-get install -y kubelet kubeadm kubectl || {
                echo "Falha ao instalar pacotes do Kubernetes";
                exit 1;
            }
            
            # Fixar versões
            echo "Fixando versões..."
            sudo apt-mark hold kubelet kubeadm kubectl || {
                echo "AVISO: Não foi possível fixar versões";
                # Não sair por erro pois isso não é crítico
            }
            
            # Verificar instalação
            echo "Verificando instalação..."
            command -v kubeadm >/dev/null 2>&1 || { echo "kubeadm não encontrado após instalação"; exit 1; }
            command -v kubectl >/dev/null 2>&1 || { echo "kubectl não encontrado após instalação"; exit 1; }
            command -v kubelet >/dev/null 2>&1 || { echo "kubelet não encontrado após instalação"; exit 1; }
            
            echo "Versões instaladas:"
            kubeadm version --short
            kubectl version --client --short
            kubelet --version
            
            echo "Kubernetes instalado com sucesso!"
EOF
        
        if [ $? -eq 0 ]; then
            echo "Kubernetes instalado com sucesso em $NODE_IP"
            return 0
        else
            echo "Tentativa $i de $MAX_RETRIES falhou. Tentando novamente em $RETRY_DELAY segundos..."
            sleep $RETRY_DELAY
        fi
    done
    
    echo "Falha ao instalar Kubernetes em $NODE_IP após $MAX_RETRIES tentativas"
    return 1
}

# Função para inicializar o cluster no master
initialize_cluster() {
    local MASTER_IP=$1
    
    echo "Inicializando cluster Kubernetes no master..."
    
    ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$MASTER_IP << 'EOF'
        # Verificar memória disponível
        MEMORY=$(free -m | awk '/Mem:/ {print $2}')
        if [ "$MEMORY" -lt 1700 ]; then
            echo "AVISO: Memória insuficiente (${MEMORY}MB), continuando com --ignore-preflight-errors=Mem"
            IGNORE_MEM="--ignore-preflight-errors=Mem"
        else
            IGNORE_MEM=""
        fi
        
        # Inicializar cluster
        sudo kubeadm init --pod-network-cidr=10.244.0.0/16 $IGNORE_MEM
        
        # Configurar kubectl para o usuário ubuntu
        mkdir -p $HOME/.kube
        sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        
        # Instalar rede Flannel
        kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
        
        # Criar token para worker
        JOIN_COMMAND=$(kubeadm token create --print-join-command)
        echo "$JOIN_COMMAND" > /home/ubuntu/join-command.sh
        chmod +x /home/ubuntu/join-command.sh
        
        # Verificar status do cluster
        kubectl get nodes
EOF
    
    if [ $? -ne 0 ]; then
        echo "Falha ao inicializar o cluster Kubernetes no master"
        exit 1
    fi
}

# Função para instalar Kubernetes nas instâncias
install_kubernetes() {
    echo "Instalando Kubernetes no master e worker..."
    
    # Verificar pré-requisitos
    check_instance_prerequisites $MASTER_IP
    check_instance_prerequisites $WORKER_IP
    
    # Verificar se o cluster já está configurado
    if ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$MASTER_IP "sudo kubeadm token list 2>/dev/null" | grep -q "system:bootstrappers"; then
        echo "Cluster Kubernetes já está configurado no master."
    else
        # Instalar containerd e Kubernetes em ambos os nós
        install_containerd $MASTER_IP
        install_containerd $WORKER_IP
        install_kubernetes_packages $MASTER_IP
        install_kubernetes_packages $WORKER_IP
        
        # Inicializar cluster no master
        initialize_cluster $MASTER_IP
    fi
    
    # Verificar se o worker já está no cluster
    if ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$WORKER_IP "sudo kubectl get nodes --kubeconfig=/etc/kubernetes/kubelet.conf 2>/dev/null" | grep -q "Ready"; then
        echo "Worker já está no cluster Kubernetes."
    else
        # Obter comando join do master
        for i in $(seq 1 $MAX_RETRIES); do
            scp -i ${KEY_NAME}.pem -o ConnectTimeout=10 ubuntu@$MASTER_IP:/home/ubuntu/join-command.sh ./join-command.sh
            
            if [ -f "./join-command.sh" ]; then
                JOIN_COMMAND=$(cat ./join-command.sh)
                echo "Comando join obtido: $JOIN_COMMAND"
                
                # Worker se juntar ao cluster
                ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no -o ConnectTimeout=10 ubuntu@$WORKER_IP "sudo $JOIN_COMMAND --ignore-preflight-errors=Mem"
                
                if [ $? -eq 0 ]; then
                    echo "Worker adicionado ao cluster com sucesso"
                    break
                fi
            fi
            
            echo "Tentativa $i de $MAX_RETRIES falhou. Tentando novamente em $RETRY_DELAY segundos..."
            sleep $RETRY_DELAY
        done
        
        if [ ! -f "./join-command.sh" ]; then
            echo "Não foi possível obter o comando join do master após $MAX_RETRIES tentativas."
            exit 1
        fi
    fi
    
    echo "Configuração do cluster concluída."
    echo "Para gerenciar o cluster, conecte-se ao master:"
    echo "  ssh -i ${KEY_NAME}.pem ubuntu@${MASTER_IP}"
    echo "E execute comandos kubectl lá"
}

# Função para build e push das imagens Docker
build_and_push_images() {
    echo "Construindo e enviando imagens Docker..."
    
    # Login no Docker Hub
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    
    # Construir backend se necessário
    if ! docker inspect "${DOCKER_REPO_PREFIX}-backend:latest" &> /dev/null; then
        echo "Construindo imagem backend..."
        if [ -d "backend" ]; then
            cd backend
            docker build -t ${DOCKER_REPO_PREFIX}-backend:latest .
            cd ..
        else
            echo "Diretório backend não encontrado"
            return 1
        fi
    else
        echo "Imagem backend já existe localmente."
    fi
    
    # Construir frontend se necessário
    if ! docker inspect "${DOCKER_REPO_PREFIX}-frontend:latest" &> /dev/null; then
        echo "Construindo imagem frontend..."
        if [ -d "frontend" ]; then
            cd frontend
            docker build -t ${DOCKER_REPO_PREFIX}-frontend:latest .
            cd ..
        else
            echo "Diretório frontend não encontrado"
            return 1
        fi
    else
        echo "Imagem frontend já existe localmente."
    fi
    
    # Enviar imagens
    echo "Enviando imagens para Docker Hub..."
    docker push ${DOCKER_REPO_PREFIX}-backend:latest || \
        echo "AVISO: Falha ao enviar imagem backend"
    docker push ${DOCKER_REPO_PREFIX}-frontend:latest || \
        echo "AVISO: Falha ao enviar imagem frontend"
    
    echo "Processo de build e push concluído."
}

# Função para deploy das aplicações no Kubernetes
deploy_applications() {
    echo "Implantando aplicações no Kubernetes remotamente..."
    
    # Verificar conexão com o cluster remotamente
    if ! ssh -i ${KEY_NAME}.pem -o StrictHostKeyChecking=no ubuntu@${MASTER_IP} "kubectl cluster-info" &> /dev/null; then
        echo "ERRO: Não foi possível conectar ao cluster Kubernetes remotamente"
        return 1
    fi

    # Implantar aplicações remotamente
    ssh -i ${KEY_NAME}.pem ubuntu@${MASTER_IP} <<EOF
        echo "Implantando backend..."
        cat <<EOL | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: ${DOCKER_REPO_PREFIX}-backend:latest
        ports:
        - containerPort: 8080
        env:
        - name: NODE_ENV
          value: "production"
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
EOL

        echo "Implantando frontend..."
        cat <<EOL | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: ${DOCKER_REPO_PREFIX}-frontend:latest
        ports:
        - containerPort: 3000
        env:
        - name: REACT_APP_API_URL
          value: "http://${MASTER_IP}"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  type: LoadBalancer
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
EOL

        echo "Verificando status das aplicações..."
        kubectl get deployments
        kubectl get services

        echo -n "Aguardando IP do LoadBalancer..."
        while [ -z "\$(kubectl get svc frontend -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)" ]; do
            sleep 10
            echo -n "."
        done
        echo ""
        
        FRONTEND_IP=\$(kubectl get svc frontend -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        echo "Frontend disponível em: http://\$FRONTEND_IP"
EOF
}

# Função principal
main() {
    # Configurar tratamento de erros
    set -euo pipefail
    
    check_local_dependencies
    setup_aws_infrastructure
    
    # Verificar se as instâncias existem antes de continuar
    MASTER_ID=$(check_instance_exists $MASTER_TAG)
    WORKER_ID=$(check_instance_exists $WORKER_TAG)
    
    if [ -z "$MASTER_ID" ] || [ -z "$WORKER_ID" ]; then
        echo "ERRO: Uma ou ambas as instâncias não existem."
        exit 1
    fi
    
    # Obter IPs públicos novamente para garantir que temos os valores corretos
    MASTER_IP=$(aws ec2 describe-instances \
        --instance-ids $MASTER_ID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    
    WORKER_IP=$(aws ec2 describe-instances \
        --instance-ids $WORKER_ID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    
    export MASTER_IP
    export WORKER_IP
    
    install_kubernetes
    build_and_push_images
    deploy_applications
    
    echo "Processo concluído!"
    echo "Acesse o frontend usando o IP do LoadBalancer mostrado acima."
    echo "Gerencie o cluster via SSH no master: ssh -i ${KEY_NAME}.pem ubuntu@${MASTER_IP}"
}

# Executar função principal
main