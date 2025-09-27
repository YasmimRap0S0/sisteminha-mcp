import pytest
from rest_framework.test import APIClient
from sisteminha.models import User, Desenvolvedor, Avaliacao_Desenvolvedor
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.exceptions import ValidationError

@pytest.fixture
def api_client():
    return APIClient()

@pytest.fixture
def admin_user(db):
    return User.objects.create_user(
        username="admin",
        email="admin@example.com",
        password="admin123",
        perfil="desenvolvedor",
        first_name="Admin",
        last_name="User"
    )

@pytest.fixture
def jwt_token(admin_user):
    refresh = RefreshToken.for_user(admin_user)
    return str(refresh.access_token)

@pytest.fixture
def authenticated_admin_client(api_client, jwt_token):
    api_client.credentials(HTTP_AUTHORIZATION=f'Bearer {jwt_token}')
    return api_client

@pytest.mark.django_db
def test_user_registration(api_client):
    url = "/sisteminha_api/auth/registro/"
    data = {
        "username": "devuser",
        "email": "dev@example.com",
        "password": "senha123",
        "perfil": "desenvolvedor",
        "first_name": "Dev",
        "last_name": "User"
    }
    response = api_client.post(url, data)
    assert response.status_code == 201
    assert "id" in response.data

@pytest.mark.django_db
def test_user_login(api_client, admin_user):
    url = "/sisteminha_api/token/"
    data = {"username": admin_user.username, "password": "admin123"}
    response = api_client.post(url, data)
    assert response.status_code == 200
    assert "access" in response.data
    assert "refresh" in response.data

@pytest.mark.django_db
def test_desenvolvedor_creation(authenticated_admin_client, admin_user):
    url = "/sisteminha_api/desenvolvedores/"
    data = {
        "user": admin_user.id,
        "cpf": "12345678901",
        "foto": "",
        "descricao": "Desenvolvedor experiente",
        "github": "devhub"
    }
    response = authenticated_admin_client.post(url, data)
    assert response.status_code == 201
    assert response.data["cpf"] == "12345678901"

@pytest.mark.django_db
def test_avaliacao_desenvolvedor_api(authenticated_admin_client, admin_user):
    desenvolvedor = Desenvolvedor.objects.create(user=admin_user, cpf="12345678901", github="devhub")
    url = "/sisteminha_api/avaliacao_Desenvolvedores/"
    data = {
        "estrela": 5,
        "comentario": "Excelente!",
        "usuario": admin_user.id,
        "desenvolvedor": desenvolvedor.id
    }
    response = authenticated_admin_client.post(url, data)
    assert response.status_code == 201
    assert response.data["estrela"] == 5

@pytest.mark.django_db
def test_avaliacao_desenvolvedor_str_method(admin_user):
    desenvolvedor = Desenvolvedor.objects.create(user=admin_user, cpf="12345678901", github="devhub")
    avaliacao = Avaliacao_Desenvolvedor.objects.create(
        estrela=4,
        comentario="Bom trabalho",
        usuario=admin_user,
        desenvolvedor=desenvolvedor
    )
    expected_str = f"Avaliação de {admin_user.username} para {desenvolvedor.user.username}"
    assert str(avaliacao) == expected_str

@pytest.mark.django_db
def test_avaliacao_desenvolvedor_invalido_estrela(admin_user):
    desenvolvedor = Desenvolvedor.objects.create(user=admin_user, cpf="12345678901", github="devhub")
    avaliacao = Avaliacao_Desenvolvedor(
        estrela=6,  # inválido
        comentario="Nota inválida",
        usuario=admin_user,
        desenvolvedor=desenvolvedor
    )
    with pytest.raises(ValidationError):
        avaliacao.clean()


## Comando python -m pytest --reuse-db ou python -m pytest      