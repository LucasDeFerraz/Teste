// Pequenas interações visuais da página de produtos.
// Não há carrinho real: é só feedback visual ao clicar.

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.produto-card').forEach((card) => {
        card.addEventListener('mouseenter', () => card.classList.add('produto-card--destaque'));
        card.addEventListener('mouseleave', () => card.classList.remove('produto-card--destaque'));
    });

    document.querySelectorAll('.btn-adicionar').forEach((botao) => {
        const textoOriginal = botao.textContent;

        botao.addEventListener('click', () => {
            if (botao.dataset.animando === 'true') {
                return;
            }
            botao.dataset.animando = 'true';
            botao.textContent = 'Adicionado ✓';
            botao.classList.add('btn-adicionar--confirmado');

            setTimeout(() => {
                botao.textContent = textoOriginal;
                botao.classList.remove('btn-adicionar--confirmado');
                botao.dataset.animando = 'false';
            }, 1200);
        });
    });
});
