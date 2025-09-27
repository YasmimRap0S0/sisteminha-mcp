from django.test import TestCase
from django.contrib.auth import get_user_model
from .models import Desenvolvedor
from .filters import DesenvolvedorFilter

User = get_user_model()

class DesenvolvedorFilterTestCase(TestCase):
    def setUp(self):
        # Criação de usuários e desenvolvedores para o teste com email e senha
        user1 = User.objects.create_user(
            username='joao123', 
            email='joao@example.com', 
            password='senha123', 
            first_name='João', 
            last_name='Silva'
        )
        user2 = User.objects.create_user(
            username='maria123', 
            email='maria@example.com', 
            password='senha123', 
            first_name='Maria', 
            last_name='Oliveira'
        )
        user3 = User.objects.create_user(
            username='carlos123', 
            email='carlos@example.com', 
            password='senha123', 
            first_name='Carlos', 
            last_name='Pereira'
        )

        Desenvolvedor.objects.create(
            user=user1, 
            cpf='12345678901', 
            descricao="Desenvolvedor backend especialista em Python", 
            github='joaogit'
        )
        Desenvolvedor.objects.create(
            user=user2, 
            cpf='12345678902', 
            descricao="Frontend React e UI/UX designer", 
            github='mariagit'
        )
        Desenvolvedor.objects.create(
            user=user3, 
            cpf='12345678903', 
            descricao="Especialista em dados e Machine Learning", 
            github='carlosgit'
        )

    def test_filtrar_por_nome(self):
        filtro = DesenvolvedorFilter({'pesquisa': 'João'}, queryset=Desenvolvedor.objects.all())
        resultados = filtro.qs
        self.assertEqual(resultados.count(), 1)
        self.assertEqual(resultados.first().user.first_name, 'João')

    def test_filtrar_por_sobrenome(self):
        filtro = DesenvolvedorFilter({'pesquisa': 'Oliveira'}, queryset=Desenvolvedor.objects.all())
        resultados = filtro.qs
        self.assertEqual(resultados.count(), 1)
        self.assertEqual(resultados.first().user.last_name, 'Oliveira')

    def test_filtrar_por_descricao(self):
        filtro = DesenvolvedorFilter({'pesquisa': 'Python'}, queryset=Desenvolvedor.objects.all())
        resultados = filtro.qs
        self.assertEqual(resultados.count(), 1)
        self.assertIn('Python', resultados.first().descricao)

    def test_pesquisa_sem_resultados(self):
        filtro = DesenvolvedorFilter({'pesquisa': 'Kotlin'}, queryset=Desenvolvedor.objects.all())
        resultados = filtro.qs
        self.assertEqual(resultados.count(), 0)
