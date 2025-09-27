import { Selector } from 'testcafe';

fixture('Usuário Credenciado - Avaliação de Desenvolvedor')
    .page('http://localhost:3000/login-desenvolvedor');

const emailCredenciado = 'testuser@example.com';
const senhaCredenciado = 'admin123';
const emailNaoCredenciado = 'naoautorizado@example.com';
const senhaNaoCredenciado = 'senha123';
const nomeDesenvolvedor = 'Teste';
const idDesenvolvedor = '9';

// 🧪 Teste 1: Login inválido (usuário não registrado)
test('Login inválido', async t => {
    await t
        .typeText(Selector('input[placeholder="Email"]'), emailNaoCredenciado)
        .typeText(Selector('input[placeholder="Password"]'), senhaNaoCredenciado)
        .click(Selector('button[type="submit"]'))
        .expect(Selector('body').withText('Fechar').exists).ok({ timeout: 5000 });
});

// 🧪 Teste 2: Usuário credenciado tenta avaliar sem selecionar estrelas
test('Usuário credenciado tenta avaliar sem selecionar estrelas', async t => {
    // Login como usuário credenciado
    await t
        .typeText(Selector('input[placeholder="Email"]'), emailCredenciado)
        .typeText(Selector('input[placeholder="Password"]'), senhaCredenciado)
        .click(Selector('button[type="submit"]'));

    // Buscar desenvolvedor
    await t
        .click(Selector('span').withText('Desenvolvedores'))
        .typeText(Selector('#palavra-chave'), nomeDesenvolvedor)
        .click(Selector('button[type="submit"]'))
        .expect(Selector('body').withText(nomeDesenvolvedor).exists).ok({ timeout: 5000 });

    // Tentar avaliar sem estrelas
    await t
        .navigateTo(`http://localhost:3000/avaliar-desenvolvedor/${idDesenvolvedor}`)
        .typeText(Selector('textarea[placeholder="Deixe um comentário..."]'), 'Testando mensagem de erro com TestCafe...')
        .click(Selector('button').withText('Salvar'))
        .expect(Selector('body').withText('Por favor, selecione uma quantidade de estrelas').exists).ok()
        .click(Selector('button').withText('Fechar'));
});
