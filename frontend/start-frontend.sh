#!/bin/bash

# Diretório do frontend
FRONTEND_DIR="/home/ec2-user/sisteminha/frontend"

# Entrar no diretório do frontend
cd $FRONTEND_DIR

# Instalar dependências (caso necessário)
npm install

# Iniciar o frontend
npm start --host 0.0.0.0
