<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Mercado Bom Preço')</title>

    {{-- Bootstrap = grid, navbar e cards (estrutura). Tailwind = ajustes finos de cor/espaçamento. --}}
    @vite(['resources/css/bootstrap.css', 'resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="bg-light">
    @yield('content')
</body>
</html>
