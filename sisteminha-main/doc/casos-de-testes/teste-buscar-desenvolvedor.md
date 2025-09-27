## 2. Testes Funcionais
#### Responsáveis: Anna, Fabiana

### 2.1 Buscar Desenvolvedor - Fluxo Principal

| Campo de texto | Opção            | Pré-requisito                                                                 | Resultado Esperado                                                                | Resultado Obtido                                                               | Situação  |
|----------------|------------------|-------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|--------------------------------------------------------------------------------|-----------|
| yasmin       | Desenvolvedores  | Usuário autenticado com Login: fabiana.serra@escolar.ifrn.edu.br Senha: teste123 | Sistema exibe o desenvolvedor                                                     | Sistema exibiu o desenvolvedor                                                | Aceita  |
| @AI           | Desenvolvedores  | Usuário autenticado com Login: fabiana.serra@escolar.ifrn.edu.br Senha: teste123 | Sistema exibe mensagem “Nenhum desenvolvedor corresponde à sua pesquisa”          | Sistema exibiu mensagem de retorno: Nenhum desenvolvedor correspondente à sua pesquisa | Aceita  |

---

### 2.2 Fluxo Alternativo Buscar Desenvolvedor

| Campo de texto    | Filtro de categoria | Filtro de Avaliação | Resultado Esperado                                                                                     | Resultado Obtido                                                  | Situação |
|-------------------|---------------------|----------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|----------|
| frontend          | Beleza              | 5 estrelas           | Lista de desenvolvedores da categoria “Beleza”, com avaliação 5 estrelas, relacionados à palavra-chave ''frontend''                         | Sistema exibiu os desenvolvedores                                    | Aceita   |
| design            | Alimentício         | 4 estrelas           | Lista de desenvolvedores da categoria ''Alimentícia'', com avaliação 4 estrelas relacionados à palavra-chave ''design''                 | Sistema exibiu os desenvolvedores                                    | Aceita   |
| dev (inválida)    | Beleza              | 3 estrelas           | Mensagem de retorno: nenhum resultado correspondente                                                          | Mensagem de retorno: Nenhum desenvolvedor correspondente à sua pesquisa | Aceita   |
| sistema web       | (não selecionado)   | 5 estrelas           | Lista de desenvolvedores com avaliação 5 estrelas relacionados à palavra-chave ''sistema web''                        | Sistema exibiu os desenvolvedores                                    | Aceita   |
| @mobile (inválida)| Alimentício         | 4 estrelas           | Mensagem de retorno: nenhum resultado correspondente                                                 | Mensagem de retorno: Nenhum desenvolvedor correspondente à sua pesquisa | Aceita   |
| frontend          | Beleza              | (não selecionado)    | Lista de desenvolvedores da categoria “Beleza” relacionados à palavra-chave ''frontend''                             | Sistema exibiu os desenvolvedores                                    | Aceita   |

---

## 3. Testes Não Funcionais

### 3.1 Teste de Desempenho - Busca por Desenvolvedor

- **Categoria**: Desempenho  
- **Automatizado**: Não  
- **Duração**: 2 seg  
- **Executado**: Sim  
- **Responsável**: Anna, Fabiana  
- **Data**: 15/05/2025  

#### Procedimentos:
1. Abrir o sisteminha.  
2. Acessar a funcionalidade de busca por desenvolvedor.  
3. Informar uma palavra-chave e aplicar filtros.  
4. Medir o tempo até a exibição dos resultados utilizando um cronômetro.  

#### Critérios de Aceitação:
- A busca deve retornar os resultados em até 2 segundos.  
- A resposta deve ser exibida corretamente e sem falhas visuais ou de carregamento.  

#### Resultado:
**Passou** – 01 segundos e 58 milésimos

---

## 4. Classes de Equivalência

| Variáveis de Entrada     | Condições                                              | Classes de Equivalência                        |
|--------------------------|--------------------------------------------------------|------------------------------------------------|
| Palavra-chave (termo da busca) | Palavra-chave entre 3 e 50 caracteres               | 1. Válido: 3 ≤ tamanho ≤ 50  <br> 2. Inválido: tamanho < 3 ou > 50 |
| Palavra-chave            | Contém apenas caracteres válidos (letras, números, espaços) | 3. Válido: Sim  <br> 4. Inválido: Não           |
| Filtros selecionados     | Filtros estão entre os valores permitidos             | 5. Válido: Filtro dentro do conjunto permitido  <br> 6. Inválido: Filtro inválido ou não existente |
| Usuário logado           | Está autenticado no sistema                           | 7. Válido: Sim  <br> 8. Inválido: Não           |
