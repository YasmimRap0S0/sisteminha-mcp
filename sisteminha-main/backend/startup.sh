#!/bin/bash
echo "Iniciando servidor Django..."

cd /home/ec2-user/sisteminha/backend || { echo "Erro: Diretório não encontrado!"; exit 1; }

git fetch origin
git checkout 300-implantação-em-nuvem
git pull origin 300-implantação-em-nuvem

python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8000
