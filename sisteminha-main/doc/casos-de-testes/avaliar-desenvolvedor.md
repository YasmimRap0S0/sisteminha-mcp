# Testes Funcionais
## Avaliar Desenvolvedor - Fluxo Principal

| Entrada 1         | Entrada 2        | Entrada 3            | Resultado Esperado                                               | Resultado Obtido                                                | Situação |
|------------------|----------------|----------------------|----------------------------------------------------------------|----------------------------------------------------------------|----------|
| Anna Fernandes  | 5 estrelas       | "Ótimo profissional"  | Sistema registra a avaliação e retorna mensagem de confirmação para usuário | Sistema exibe mensagem de confirmação para usuário | ACEITO |
| Yasmim Raposo   | 4 estrelas       | "Ótimo desenvolvedor" | Sistema registra a avaliação e retorna mensagem de confirmação para usuário | Sistema exibe mensagem de confirmação para usuário | ACEITO |
| Fernanda Torres | 3 estrelas       | (vazio)               | Sistema registra a avaliação e retorna mensagem de confirmação para usuário | Sistema exibe mensagem de confirmação para usuário | ACEITO |
| Yasmim Raposo   | 2 estrelas       | "Péssimo. Muito arrogante!" | Sistema registra a avaliação e retorna mensagem de confirmação para usuário | Sistema exibe mensagem de confirmação para usuário | ACEITO |
| Yasmim Raposo   | 1 estrela        | (vazio)               | Sistema registra a avaliação e retorna mensagem de confirmação para usuário | Sistema exibe mensagem de confirmação para usuário | ACEITO |

## 2.2 Fluxo Alternativo 1 - Avaliação sem estrelas

| Entrada 1         | Entrada 2        | Entrada 3          | Resultado Esperado                                                       | Resultado Obtido                                                | Situação |
|------------------|----------------|--------------------|-------------------------------------------------------------------------|----------------------------------------------------------------|----------|
| Fernanda Torres | (vazio)         | "Gostei de trabalhar com ela" | Sistema não registra a avaliação e exibe mensagem de erro exigindo pelo menos avaliação com estrelas | Sistema exibe mensagem de erro 400, mas não especifica o que ocasionou o erro para o usuário | NÃO ACEITO |
| Yasmim Raposo   | (vazio)         | (vazio)            | Sistema não registra a avaliação e exibe mensagem de erro exigindo pelo menos avaliação com estrelas | Sistema exibe mensagem de erro 400, mas não especifica o que ocasionou o erro para o usuário | NÃO ACEITO |

# Testes Não Funcionais
## Teste de Performance referente ao caso de uso “Avaliar Desenvolvedor”

**Categoria:** Performance  
**Automatizado:** Não  
**Duração:** 3 s  
**Executado:** Sim  
**Responsável:** Yasmim  
**Data:** 15/05/2025  

### **Procedimentos**
1. Cadastrar-se na plataforma Sisteminha como microempreendedor ou desenvolvedor  
2. Selecionar um desenvolvedor cadastrado e entrar na página de avaliação  
3. Avaliar o desenvolvedor com estrelas e comentário  
4. Clicar em “salvar” e avaliar o tempo de duração de resposta  

### **Critérios de Aceitação**
1. O sistema deve salvar a avaliação.  
2. O sistema deve exibir uma mensagem clara e confirmando o sucesso da avaliação em menos de 3 s.  

**Resultado:**  
`03.12s`  
**Não passou no teste.**  

# Classes de Equivalência  

| Variáveis              | Condições                                      | Classes de Equivalência |
|----------------------|----------------------------------------------|--------------------------|
| Nome do desenvolvedor (N) | Nome existente | Válido: Sim / Inválido: Não |
| Desenvolvedor autenticado | Autenticado | Válido: Sim / Inválido: Não |
| Estrelas | Estrelas ∈ [1, 5] | Válido: estrelas >=1 && estrelas <=5 / Inválido: estrelas < 1 && estrelas > 5 |
| Comentário (C) | Conjunto de caracteres (opcional) | Válido: Sim / Inválido: Não |

# Referências
Medium – Revista TSPI. *Técnica de Teste: Particionamento de Equivalência*.  
Disponível em: [https://medium.com/revista-tspi/t%C3%A9cnica-de-teste-particionamento-de-equival%C3%AAncia-d32a7d689d82](https://medium.com/revista-tspi/t%C3%A9cnica-de-teste-particionamento-de-equival%C3%AAncia-d32a7d689d82).  
Acesso em: 15 maio 2025.
