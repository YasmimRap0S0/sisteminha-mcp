import os
import sys
import django
from mutpy import commandline

# Configurar o ambiente Django
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings')
django.setup()

# Argumentos para o MutPy (ajuste os caminhos conforme seu projeto)
sys.argv = [
    'mut.py',
    '--target', 'sisteminha/models.py',         # Código a ser mutado
    '--unit-test', 'sisteminha/tests',          # Pasta ou arquivos de testes
    '--report-html', 'mutpy-report',            # Saída HTML
    '--timeout-factor', '3',                    # Tempo extra para testes
    '--disable-stdout',                         # Evita poluir terminal
    '--show-mutants'                            # Mostra mutações geradas
]

# Rodar o MutPy
commandline.main(argv=sys.argv)
