# Avaliação Heurística - Fabiana Campos

### Telas avaliadas
1 - Tela Inicial/visualizar categorias de sistemas  
2 - Buscar desenvolvedor  
3 - Avaliar Desenvolvedor  

---

### Problema 1: Ausência de opção para cancelar a avaliação no formulário  
**Critério violado:** AF8 – Cancelamento de ações  
**Onde ocorre:** Página “Avaliar Desenvolvedor”  
**Descrição:** Não há um botão que permita ao usuário cancelar a ação de avaliação e retornar à página anterior, o que pode causar frustração caso o usuário deseje desistir da operação.  
**Sugestão de melhoria:** Implementar um botão “Cancelar” visível no formulário, com redirecionamento seguro para a página anterior ou para uma área de visualização do perfil.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Baixo  

---

### Problema 2: Ausência de opção para ordenar a lista de desenvolvedores  
**Critério violado:** FM4 – Ordenação da informação  
**Onde ocorre:** Página "Buscar Desenvolvedor"  
**Descrição:** A interface apresenta a lista de desenvolvedores em uma ordem fixa, sem permitir ao usuário aplicar critérios de ordenação, como por nome. Isso dificulta a localização eficiente de perfis relevantes para o usuário.  
**Sugestão de melhoria:** Implementar mecanismos de ordenação na lista de desenvolvedores, oferecendo opções como "nome A–Z", "mais bem avaliados", "mais recentes", entre outras.  
**Gravidade:** Média  
**Esforço para melhoria:** Médio  

---

### Problema 3: Área dos filtros por setor e avaliação apresenta fontes com o mesmo tamanho, o que dificulta a leitura  
**Critério violado:** FM13 – Leiturabilidade  
**Onde ocorre:** Página “Buscar Desenvolvedor”  
**Descrição:** Os títulos das seções de filtro (“Buscar desenvolvedores por setores” e “por Avaliação”) utilizam o mesmo tamanho de fonte que as opções de resposta, o que compromete a hierarquia visual e pode confundir o usuário na distinção entre título e conteúdo.  
**Sugestão de melhoria:** Aplicar maior contraste visual entre os títulos e as opções, utilizando variação de tamanho de fonte, peso (negrito) ou cor, de modo a facilitar a leitura e reforçar a estrutura da informação.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Baixo  

---

### Problema 4: Cores dos botões não seguem uma paleta definida  
**Critério violado:** FM12 – Paletas de cor  
**Onde ocorre:** Página “Buscar Desenvolvedor”  
**Descrição:** Os botões “Filtrar” e “Limpar Filtros” utilizam cores azul e cinza, respectivamente, sem relação aparente com uma paleta de cores do sistema.  
**Sugestão de melhoria:** Definir e aplicar uma paleta de cores coerente com a identidade visual do sistema.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Baixo  

---

### Problema 5: Ausência de tela de carregamento nas transições entre páginas  
**Critério violado:** FM16 – Tela de carregamento  
**Onde ocorre:** Visualizar Categorias de Sistemas, Buscar Desenvolvedor, Avaliar Desenvolvedor  
**Descrição:** Ao navegar entre páginas com carregamento mais demorado, o sistema não exibe nenhuma tela de transição ou indicador de carregamento. Isso pode causar a impressão de lentidão, travamento ou falha, prejudicando a percepção de desempenho da interface.  
**Sugestão de melhoria:** Implementar uma tela de carregamento ou indicador visual durante a transição entre páginas, para informar ao usuário que o sistema está processando a solicitação.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Alto  

---

### Problema 6: Poucas opções de navegação disponíveis na página inicial  
**Critério violado:** NA2 – Caminhos de Navegação  
**Onde ocorre:** Página "Visualizar Categorias de Sistemas"  
**Descrição:** A navegação na página inicial é limitada a apenas dois caminhos: realizar uma busca por campo de texto ou clicar em imagens de setores. A ausência de menus, filtros adicionais ou links diretos dificulta a exploração mais ampla da plataforma.  
**Sugestão de melhoria:** Ampliar os caminhos de navegação, incluindo menus fixos, abas, filtros por tags ou ícones de acesso rápido para áreas importantes, oferecendo ao usuário múltiplas formas de explorar o conteúdo da plataforma.  
**Gravidade:** Média  
**Esforço para melhoria:** Alto  

---

### Problema 7: Ausência de migalhas de pão para indicar a localização do usuário  
**Critério violado:** NA4 – Migalhas de pão  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** O sistema não apresenta nenhuma indicação do caminho de navegação percorrido pelo usuário. Isso dificulta a orientação e o entendimento sobre onde o usuário se encontra dentro da estrutura do site, especialmente em fluxos com múltiplas etapas.  
**Sugestão de melhoria:** Implementar uma trilha de navegação (migalhas de pão) visível no topo das páginas, indicando o caminho percorrido e permitindo que o usuário retorne facilmente a páginas anteriores.  
**Gravidade:** Alta  
**Esforço para melhoria:** Médio  

---

### Problema 8: Interface não adaptada para dispositivos móveis  
**Critérios violados:** PD1 – Recursos do dispositivo, PD2 – Adequação a padrões, PD3 – Responsividade, PD4 – Densidade informacional, PD5 – Áreas clicáveis maiores, PD6 – Mudança na orientação da tela  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** A interface não apresenta adaptação adequada para dispositivos móveis. Elementos não se ajustam corretamente ao tamanho da tela, há sobreposição de conteúdos, botões pequenos para toque e ausência de aproveitamento dos recursos do dispositivo, como orientação horizontal. Isso compromete a usabilidade e dificulta a navegação em smartphones e tablets.  
**Sugestão de melhoria:** Aplicar práticas de design responsivo, com layout adaptável a diferentes resoluções e tamanhos de tela, reorganização de elementos para melhor leitura, ampliação de áreas clicáveis e suporte à rotação da tela.  
**Gravidade:** Alta  
**Esforço para melhoria:** Alto  

---

### Problema 9: Acessibilidade na Visualização de imagens e ícones  
**Critérios violados:** AC1 – Texto alternativo  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** As imagens e ícones presentes nessas páginas não possuem textos alternativos, dificultando a compreensão do conteúdo para usuários que utilizam leitores de tela. Isso compromete a acessibilidade para pessoas com deficiência visual.  
**Sugestão de melhoria:** Incluir textos alternativos descritivos e significativos para todas as imagens e ícones utilizando o atributo `alt` nas tags `<img>` e, quando aplicável, utilizar a tag `<figure>` para agrupar imagens e suas legendas. Garantir que esses textos forneçam uma descrição clara do conteúdo visual para leitores de tela.  
**Gravidade:** Média  
**Esforço para melhoria:** Baixo  

---

### Problema 10: Falta de opção para alto contraste nas páginas  
**Critérios violados:** AC4 – Contraste de cor  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** As páginas não oferecem opção para alternar para um modo de alto contraste, dificultando a leitura para usuários com baixa visão ou sensibilidade a cores. A ausência dessa funcionalidade limita a personalização da interface para melhorar a acessibilidade visual.  
**Sugestão de melhoria:** Implementar um recurso que permita ao usuário ativar um modo de alto contraste, seguindo as recomendações WCAG para contraste mínimo. Pode-se também permitir personalização das cores para adequar às necessidades visuais individuais dos usuários.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Médio  

---

### Problema 11: Ausência de recurso próprio para ampliação da tela  
**Critérios violados:** AC5 – Possibilidade de ampliação  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** As páginas não possuem um recurso próprio que permita aos usuários ampliar o conteúdo da tela de forma controlada, sem comprometer a organização visual e a legibilidade dos elementos. Isso dificulta o acesso para pessoas com baixa visão que necessitam aumentar o tamanho das informações.  
**Sugestão de melhoria:** Implementar uma ferramenta integrada que permita a ampliação e redução do conteúdo, garantindo que o layout se ajuste corretamente e que a navegação continue funcional e clara após a ampliação. Essa funcionalidade deve preservar a usabilidade e evitar quebras no design.  
**Gravidade:** Média  
**Esforço para melhoria:** Alto  

---

### Problema 12: Ausência de recurso para formatar fontes  
**Critérios violados:** AC8 – Possibilidade de formatar fontes  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** As páginas não oferecem opções para que o usuário altere o estilo, tamanho ou tipo da fonte, limitando a personalização da leitura conforme suas necessidades visuais.  
**Sugestão de melhoria:** Implementar funcionalidades que permitam ao usuário ajustar o tamanho, tipo e estilo da fonte diretamente na interface, sem comprometer o layout e a funcionalidade das páginas.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Alto  

---

### Problema 13: Ausência de opção para ajuste da saturação das cores  
**Critérios violados:** AC10 – Formatação da saturação  
**Onde ocorre:** Páginas “Visualizar Categorias de Sistemas”, “Buscar Desenvolvedor” e “Avaliar Desenvolvedor”  
**Descrição:** As páginas não oferecem opções para que o usuário ajuste a saturação das cores da interface, o que poderia ajudar a reduzir a fadiga ocular e atender a diferentes necessidades visuais dos usuários.  
**Sugestão de melhoria:** Implementar funcionalidades que permitam alternar entre modos de alta e baixa saturação, possibilitando personalização visual conforme o conforto do usuário.  
**Gravidade:** Baixa  
**Esforço para melhoria:** Médio  
