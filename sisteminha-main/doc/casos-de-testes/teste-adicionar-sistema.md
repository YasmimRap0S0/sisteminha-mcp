## 1. Testes Funcionais
#### Responsável: Rick Hill

### 1.1 Adicionar Sistema - Fluxo Principal

| Entrada 1 (nome) | Entrada 2 (setor) | Entrada 3 (status) | Entrada 4 (categoria) | Entrada 5 (descrição) | Resultado Esperado | Resultado Obtido | Situação  |
|----------------|------------------|----------------------------------------------------------------|---------------|-----------------|------------------------------------------------------------------|--------------------------------------------------------------------------------|-----------|
| ChefOnline       | E-commerce  | Concluído | setor alimentício | Aplicativo de delivery de comidas online. | O Sistema deve ser cadastrado com sucesso. | Sistema deve cadastrado com sucesso | Aceito  |
| N/A       | E-commerce  | Concluído | setor alimentício | Aplicativo de delivery de comidas online. | O Sistema não é cadastrado e deve ser mostrada uma mensagem indicando que o campo precisa ser preenchido. | Sistema não cadastrado e mensagem de erro mostrada. | Aceito  |
| ChefOnline       | N/A  | Concluído | setor alimentício | Aplicativo de delivery de comidas online. | O Sistema não é cadastrado e deve ser mostrada uma mensagem indicando que o campo precisa ser preenchido. | Sistema não cadastrado e mensagem de erro mostrada. | Aceito  |
| ChefOnline       | E-commerce  | N/A | setor alimentício | Aplicativo de delivery de comidas online. | O Sistema não é cadastrado e deve ser mostrada uma mensagem indicando que o campo precisa ser preenchido. | Sistema não cadastrado e mensagem de erro mostrada. | Aceito  |
| ChefOnline       | E-commerce  | Concluído | N/A | Aplicativo de delivery de comidas online. | O Sistema não é cadastrado e deve ser mostrada uma mensagem indicando que o campo precisa ser preenchido. | Sistema não cadastrado e mensagem de erro mostrada. | Aceito  |
| ChefOnline       | E-commerce  | Concluído | setor alimentício | N/A | O Sistema não é cadastrado e deve ser mostrada uma mensagem indicando que o campo precisa ser preenchido. | Sistema não cadastrado e mensagem de erro mostrada. | Aceito  |

---

## 2. Testes Não Funcionais

### 2.1 Teste de Desempenho - Busca por Desenvolvedor

- **Categoria**: Desempenho  
- **Automatizado**: Não  
- **Duração**: 2 seg  
- **Executado**: Sim  
- **Responsável**: Rick Hill
- **Data**: 20/05/2025  

#### Procedimentos:
1. Abrir o sisteminha em diferentes navegadores.
2. Acessar a funcionalidade de adicionar sistema.
3. Preencher os campos obrigatórios.  
4. Medir o tempo até o cadastro do sistema na plataforma.  

#### Critérios de Aceitação:
- O sistema deve ser cadastro em até 1 segundo.  

#### Resultado:
- **Passou (Microsoft Edge)** – 92 centésimos.
- **Passou (Chrome)** – 83 centésimos.
- **Passou (Firefox)** – 93 centésimos.

---

## 3. Classes de Equivalência

| Variáveis de Entrada | Condições | Classes de Equivalência |
|--------------------------|--------------------------------------------------------|------------------------------------------------|
| Preenchimento | Todos os campos devem ser preenchidos | 1. Válido: Todos os campos preenchidos  <br> 2. Inválido: Pelo menos um campo vazio |
