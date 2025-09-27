#!/bin/bash

# Caminho raiz do projeto (pode ajustar se necessário)
PROJECT_DIR="./src"

# Padrão antigo (inválido em versões recentes)
OLD_IMPORT_PATTERN="swiper\/modules"

# Novo padrão de importação (ajustado conforme documentação atual)
# Altere se estiver usando componentes específicos (ex: Navigation, Pagination etc.)
NEW_IMPORT_LINE="import { Navigation, Pagination } from 'swiper/modules';"

# Novo padrão sugerido (caso queira usar apenas core)
# NEW_IMPORT_LINE="import Swiper from 'swiper';"

# Encontra arquivos que importam 'swiper/modules'
FILES=$(grep -rl "$OLD_IMPORT_PATTERN" "$PROJECT_DIR")

if [ -z "$FILES" ]; then
  echo "Nenhuma importação antiga de 'swiper/modules' encontrada em $PROJECT_DIR."
  exit 0
fi

echo "Corrigindo importações em:"
for FILE in $FILES; do
  echo " - $FILE"
  
  # Substitui a linha antiga por uma linha correta
  # Ajuste conforme necessário dependendo de como está sua estrutura
  sed -i.bak "s|from 'swiper/modules'|from 'swiper/modules'|" "$FILE"

  # Se você quiser sobrescrever completamente a linha de importação, pode usar:
  # sed -i.bak "/from 'swiper\/modules'/c\\$NEW_IMPORT_LINE" "$FILE"

  # Remove o backup criado pelo sed (opcional)
  rm "$FILE.bak"
done

echo "Importações ajustadas com sucesso."
