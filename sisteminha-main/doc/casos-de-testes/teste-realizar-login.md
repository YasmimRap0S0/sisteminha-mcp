## 1. Realizar Login
#### Responsável: Larissa Samara

### 1.1 Realizar Login - Fluxo Principal

| **ID** | **Cenário**                             | **Entradas**                                       | **Ação**                           | **Resultado Esperado**                             | **Observações**            |
| ------ | --------------------------------------- | -------------------------------------------------- | ---------------------------------- | -------------------------------------------------- | -------------------------- |
| TC01   | Login com Google                        | Conta Google válida                                | Clicar em "Entrar com Google"      | Usuário autenticado e redirecionado para o sistema | Google OAuth               |
| TC02   | Login com Google - conta inválida       | Conta Google inválida ou cancelada                 | Clicar em "Entrar com Google"      | Exibe erro de autenticação                         | -                          |
| TC03   | Login com GitHub                        | Conta GitHub válida                                | Clicar em "Entrar com GitHub"      | Usuário autenticado e redirecionado                | GitHub OAuth               |
| TC04   | Login com GitHub - conta inválida       | Conta GitHub inválida ou sem permissão             | Clicar em "Entrar com GitHub"      | Exibe erro de autenticação                         | -                          |
| TC05   | Login com e-mail e senha válidos        | E-mail: `usuario@exemplo.com`<br>Senha: `senha123` | Preencher campos + clicar "Entrar" | Usuário autenticado e redirecionado                | Autenticação tradicional   |
| TC06   | Login com e-mail incorreto              | E-mail: `inexistente@ex.com`<br>Senha: `senha123`  | Clicar "Entrar"                    | Exibe mensagem de "usuário não encontrado"         | -                          |
| TC07   | Login com senha incorreta               | E-mail: `usuario@exemplo.com`<br>Senha: `errada`   | Clicar "Entrar"                    | Exibe mensagem de "senha incorreta"                | -                          |
| TC08   | Login com campos vazios                 | E-mail: vazio<br>Senha: vazio                      | Clicar "Entrar"                    | Exibe mensagens de campo obrigatório               | Validação de formulário    |
| TC09   | Esqueci a senha - e-mail válido         | E-mail: `usuario@exemplo.com`                      | Clicar em "Esqueci a senha"        | Exibe mensagem de recuperação enviada              | Testa fluxo de recuperação |
| TC10   | Esqueci a senha - e-mail não cadastrado | E-mail: `naoexiste@ex.com`                         | Clicar em "Esqueci a senha"        | Mensagem de "e-mail não encontrado"                | -                          |
| TC11   | Esqueci a senha - campo vazio           | E-mail: vazio                                      | Clicar em "Esqueci a senha"        | Mensagem de campo obrigatório                      | -                          |


## 2. Testes Não Funcionais

### 2.1 Teste de Desempenho - Realizar login

- **Categoria**: Desempenho  
- **Automatizado**: Não  
- **Duração**: 2 seg  
- **Executado**: Sim  
- **Responsável**: Larissa Samara
- **Data**: 20/05/2025  

#### Procedimentos:
1. Abrir o sisteminha em diferentes navegadores.
2. Acessar a funcionalidade de realizar login.
3. Preencher os campos obrigatórios.  
4. Realizar o login na plataforma.

#### Critérios de Aceitação:
- O usuário deve conseguir se autenticar usando:

Conta Google

Conta GitHub

E-mail e senha válidos


## 3. Classes de Equivalência

| Variáveis de Entrada | Condições | Classes de Equivalência |
|--------------------------|--------------------------------------------------------|------------------------------------------------|
| Preenchimento | Todos os campos devem ser preenchidos | 1. Válido: Todos os campos preenchidos  <br> 2. Inválido: Pelo menos um campo vazio |
