# Imagem base para build do frontend
FROM node:18-alpine as build

# Diretório de trabalho
WORKDIR /app

# Copia apenas os arquivos necessários para instalação de dependências
COPY package.json package-lock.json ./

# Instala as dependências
RUN npm ci

# Copia o restante dos arquivos
COPY . .

# Gera o build de produção
RUN npm run build

# Imagem base para servir o frontend
FROM nginx:alpine

# Remove o arquivo de configuração padrão do nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia nossa configuração customizada do nginx
COPY nginx.conf /etc/nginx/conf.d

# Copia o build do container anterior para a pasta do nginx
COPY --from=build /app/build /usr/share/nginx/html

# Expondo a porta padrão do nginx
EXPOSE 80

# Comando padrão
CMD ["nginx", "-g", "daemon off;"]