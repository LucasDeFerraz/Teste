<?php

namespace App\Http\Controllers;

class ProdutoController extends Controller
{
    public function index()
    {
        $categorias = [
            [
                'nome' => 'Frutas e Verduras',
                'produtos' => [
                    ['nome' => 'Banana Prata', 'preco' => 4.99, 'imagem' => 'banana-prata.png'],
                    ['nome' => 'Maçã Fuji', 'preco' => 6.49, 'imagem' => 'maca-fuji.png'],
                    ['nome' => 'Tomate', 'preco' => 5.90, 'imagem' => 'tomate.png'],
                    ['nome' => 'Alface', 'preco' => 2.50, 'imagem' => 'alface.png'],
                ],
            ],
            [
                'nome' => 'Laticínios',
                'produtos' => [
                    ['nome' => 'Leite Integral', 'preco' => 4.79, 'imagem' => 'leite-integral.png'],
                    ['nome' => 'Queijo Mussarela', 'preco' => 32.90, 'imagem' => 'queijo-mussarela.png'],
                    ['nome' => 'Iogurte Natural', 'preco' => 5.49, 'imagem' => 'iogurte-natural.png'],
                    ['nome' => 'Manteiga', 'preco' => 9.99, 'imagem' => 'manteiga.png'],
                ],
            ],
            [
                'nome' => 'Mercearia',
                'produtos' => [
                    ['nome' => 'Arroz 5kg', 'preco' => 24.90, 'imagem' => 'arroz-5kg.png'],
                    ['nome' => 'Feijão 1kg', 'preco' => 8.49, 'imagem' => 'feijao-1kg.png'],
                    ['nome' => 'Açúcar 1kg', 'preco' => 4.29, 'imagem' => 'acucar-1kg.png'],
                    ['nome' => 'Óleo de Soja', 'preco' => 7.99, 'imagem' => 'oleo-de-soja.png'],
                ],
            ],
            [
                'nome' => 'Bebidas',
                'produtos' => [
                    ['nome' => 'Suco de Laranja', 'preco' => 6.90, 'imagem' => 'suco-de-laranja.png'],
                    ['nome' => 'Refrigerante Cola 2L', 'preco' => 8.99, 'imagem' => 'refrigerante-cola.png'],
                    ['nome' => 'Água Mineral 1,5L', 'preco' => 3.29, 'imagem' => 'agua-mineral.png'],
                    ['nome' => 'Café Torrado e Moído', 'preco' => 14.90, 'imagem' => 'cafe-moido.png'],
                ],
            ],
            [
                'nome' => 'Limpeza',
                'produtos' => [
                    ['nome' => 'Sabão em Pó', 'preco' => 15.90, 'imagem' => 'sabao-em-po.png'],
                    ['nome' => 'Detergente', 'preco' => 2.49, 'imagem' => 'detergente.png'],
                    ['nome' => 'Desinfetante', 'preco' => 6.99, 'imagem' => 'desinfetante.png'],
                    ['nome' => 'Papel Higiênico', 'preco' => 18.90, 'imagem' => 'papel-higienico.png'],
                ],
            ],
        ];

        return view('produtos.index', compact('categorias'));
    }
}
