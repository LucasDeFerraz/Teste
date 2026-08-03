@extends('layouts.app')

@section('title', 'Mercado Bom Preço')

@section('content')

    {{-- Header fixo: navbar do Bootstrap cuida da estrutura (fixed-top, container) --}}
    <header class="navbar navbar-dark fixed-top shadow" style="background: linear-gradient(90deg, #4338ca, #4f46e5);">
        <div class="container d-flex justify-content-between align-items-center py-1">
            <span class="navbar-brand mb-0 h1 fw-bold">
                Mercado <span class="fw-light">Bom Preço</span>
            </span>
            <span class="d-flex align-items-center gap-2 bg-white bg-opacity-25 text-white rounded-pill px-3 py-2">
                <span aria-hidden="true">🛒</span>
                <span class="small fw-medium">Carrinho</span>
                <span class="bg-white text-indigo-700 fw-bold rounded-circle d-inline-flex align-items-center justify-content-center"
                      style="width:1.4rem;height:1.4rem;font-size:.75rem;color:#4338ca;">0</span>
            </span>
        </div>
    </header>

    <main class="container pt-24 pb-5">

        <section class="text-center mb-5">
            <h1 class="display-6 fw-bold text-indigo-700" style="color:#3730a3;">Ofertas da semana</h1>
            <p class="text-muted">Produtos frescos e de qualidade, direto para sua casa.</p>
        </section>

        @foreach ($categorias as $categoria)
            <section class="mb-5">
                <h2 class="h4 fw-semibold d-inline-block border-bottom border-3 pb-2 mb-4"
                    style="border-color:#4f46e5 !important; color:#3730a3;">
                    {{ $categoria['nome'] }}
                </h2>

                <div class="row g-4">
                    @foreach ($categoria['produtos'] as $produto)
                        <div class="col-6 col-md-4 col-lg-3">
                            <article class="card h-100 border-0 shadow-sm produto-card">
                                <img src="{{ asset('images/' . $produto['imagem']) }}"
                                     class="card-img-top"
                                     alt="{{ $produto['nome'] }}"
                                     loading="lazy">
                                <div class="card-body d-flex flex-column">
                                    <h3 class="h6 card-title">{{ $produto['nome'] }}</h3>
                                    <p class="fw-bold fs-5 mt-auto mb-3" style="color:#4338ca;">
                                        R$ {{ number_format($produto['preco'], 2, ',', '.') }}
                                    </p>
                                    <button type="button" class="btn btn-adicionar w-100">
                                        Adicionar ao carrinho
                                    </button>
                                </div>
                            </article>
                        </div>
                    @endforeach
                </div>
            </section>
        @endforeach

    </main>

    <footer class="bg-dark text-light text-center py-4 mt-5">
        <p class="mb-1">&copy; {{ date('Y') }} Mercado Bom Preço. Todos os direitos reservados.</p>
        <p class="small text-secondary mb-0">Página criada para fins de teste técnico &mdash; sem funcionalidade de compra real.</p>
    </footer>

@endsection
