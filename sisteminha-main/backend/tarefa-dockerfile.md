# Configuração do Dockerfile
Ao criar  o arquivo Dockerfile, definimos como o backend será estruturado dentro do contêiner Docker.

1️⃣ Escolha da imagem base  
   - Usamos python:3.9-slim, que é uma versão mais leve do Python para evitar desperdício de espaço.

2️⃣ Definição do diretório de trabalho  
   - O comando WORKDIR /app define o diretório onde os arquivos serão armazenados dentro do contêiner.

3️⃣ Instalação de pacotes necessários  
   - O comando RUN apt-get update && apt-get install -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/* instala ferramentas essenciais para rodar o backend, incluindo suporte ao banco de dados PostgreSQL.

4️⃣ Configuração do ambiente virtual  
   - O backend precisa de um ambiente isolado para instalar dependências, então criamos um ambiente virtual com python -m venv /env.

5️⃣ Instalação de dependências do backend  
   - Usamos pip install -r requirements.txt para instalar todas as dependências definidas no arquivo requirements.txt.

---
# Execução e Testes do Contêiner
1️⃣ Construção da imagem  
   - O comando abaixo cria uma imagem baseada no Dockerfile:    

```sh
docker build -t backend:3.0 .
``` 

2️⃣ Criação e execução do contêiner  
   - Para rodar a imagem e criar um contêiner chamado backend-container, usamos:

```sh
docker run --name backend-container -p 8080:8000 sisteminha/backend:3.0
```
   - Isso faz com que a porta 8000 do backend seja acessível na 8080 do sistema.
  

3️⃣ Acesso à aplicação  
   - Agora podemos acessar o backend pelo navegador ou Postman:
     http://localhost:8080
