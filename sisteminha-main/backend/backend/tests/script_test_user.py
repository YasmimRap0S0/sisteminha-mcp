import sys
import os
import django

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(BASE_DIR)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

from django.contrib.auth import get_user_model
from sisteminha.models import Desenvolvedor

User = get_user_model()

# Remove usuário anterior, se existir
User.objects.filter(email="testuser@example.com").delete()

# Cria novo usuário
user = User.objects.create_user(
    username="testuser@example.com",
    email="testuser@example.com",
    password="admin123",
    perfil='desenvolvedor',
    first_name='Teste',
    last_name='User'
)

Desenvolvedor.objects.create(
    cpf="12345678000",
    github="githubteste",
    user=user
)

print("Usuário de teste criado com sucesso!")
