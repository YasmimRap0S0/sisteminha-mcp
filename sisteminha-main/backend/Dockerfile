FROM python:3.9-slim

WORKDIR /app

# Instala bibliotecas do sistema necessárias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia os arquivos da aplicação para o contêiner
COPY . /app

# Instala as dependências diretamente no sistema da imagem
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Expõe a porta padrão do Django
EXPOSE 8000

# Comando para iniciar o servidor
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
