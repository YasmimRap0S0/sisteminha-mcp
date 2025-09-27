# Criação de Imagem Docker com Dockerfile - Frontend

---
**Responsáveis:** Anna Julia, Fabiana Campos, Larissa Samara

---

### ✨ Objetivo

Criar uma imagem Docker personalizada para o frontend do projeto **sisteminha**, utilizando um **Dockerfile**, e disponibilizá-la no Docker Hub para execução em uma máquina virtual na nuvem (AWS).

---

### 📂 Estrutura do Projeto

* Diretório: `/home/ec2-user/sisteminha/frontend`
* Projeto desenvolvido com **React**

---

### 🔹 Etapas Realizadas

#### 1. Criar o Dockerfile

Instalando e configurando o Docker na VM
```
sudo yum update -y 
sudo yum install -y docker 
sudo systemctl start docker 
sudo systemctl enable docker 
sudo usermod -aG docker ec2-user
```


No diretório do projeto frontend, criamos um arquivo `Dockerfile` com o seguinte conteúdo:

```Dockerfile
# Etapa de build do frontend

# Imagem base para build do frontend
FROM node:18 as build

# Diretório de trabalho
WORKDIR /app

# Copia os arquivos do projeto para dentro do container
COPY . .

# Instala as dependências e gera o build
RUN npm install
RUN npm run build

# Etapa para servir o build com nginx

# Imagem base para servir o frontend
FROM nginx:alpine

# Copia o build do container anterior para a pasta do nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expondo a porta padrão do nginx
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

Etapas do build
- COPY . .: Copiou os arquivos do seu frontend pro container.

- RUN npm install: Instalou as dependências.

- RUN npm run build: Gerou o build de produção (os arquivos otimizados do frontend).

- COPY --from=build /app/build /usr/share/nginx/html: Copiou o resultado do build para o Nginx.

- exporting to image: Exportou e nomeou a imagem como sisteminha/frontend-sisteminha.



---

#### 2. Decisões

- Usamos duas imagens: node:18 para construir o frontend e nginx:alpine para servir os arquivos estáticos.
- Dividimos a imagem em dois estágios para manter o container final mais leve (multistage build).
- Utilizamos multi-stage build para separar o ambiente de construção do ambiente de produção
- Primeiro estágio com Node.js para instalar dependências e construir a aplicação
- Segundo estágio com Nginx Alpine para servir os arquivos estáticos (reduz o tamanho final)

---

#### 2. Construir a imagem

```
cd /home/ec2-user/sisteminha/frontend
docker build -t sisteminha/frontend-sisteminha .
```


---

#### 3. Login no Docker Hub


```docker login```


---

#### 4. Publicar a imagem no Docker Hub

```
docker push sisteminha/frontend-sisteminha
```
![image](https://github.com/user-attachments/assets/9540cb08-3b43-4407-95ef-393f965d185d)

---

#### 5. Executar o container na VM (AWS EC2)

Como a porta 80 já estava sendo usada por outro container (nginx), rodamos o container personalizado na porta **3001**:

```
docker run -d -p 3001:80 --name frontend-dockerfile sisteminha/frontend-sisteminha
```

---

### 🌐 Resultado Final

A aplicação frontend ficou acessível por meio do endereço:

http://100.28.158.86:3001


---

### 📄 Envio para o GitHub

Como o Dockerfile foi criado localmente, fizemos o push para o repositório no GitHub:

```
git pull --no-rebase
git add Dockerfile
git commit -m "feat: adiciona Dockerfile para build do frontend"
git push
```

---

### 📊 Conclusão

* Criamos uma imagem Docker padronizada usando boas práticas de build.
* O uso de Dockerfile torna o processo **reprodutível** e **versionado**.
* A imagem foi testada com sucesso em uma instância EC2 na AWS.


---




