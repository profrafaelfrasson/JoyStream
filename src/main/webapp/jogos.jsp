<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    String avatarUrl = (usuario != null && usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");
    
    // Recebe os jogos do Servlet
    List<JSONObject> jogos = (List<JSONObject>) request.getAttribute("jogos");
    Integer totalPages = (Integer) request.getAttribute("total_pages");
    Integer currentPage = (Integer) request.getAttribute("current_page");
    if (totalPages == null) totalPages = 1;
    if (currentPage == null) currentPage = 1;

    StringBuilder baseUrl = new StringBuilder("jogos?");
    String[] plataformas = request.getParameterValues("plataforma");
    String[] generos = request.getParameterValues("genero");
    String[] tags = request.getParameterValues("tags");
    if (plataformas != null) {
        for (String plat : plataformas) {
            baseUrl.append("plataforma=").append(plat).append("&");
        }
    }
    if (generos != null) {
        for (String gen : generos) {
            baseUrl.append("genero=").append(gen).append("&");
        }
    }
    if (tags != null) {
        for (String tag : tags) {
            baseUrl.append("tags=").append(tag).append("&");
        }
    }
    if (request.getParameter("nota_min") != null && !request.getParameter("nota_min").isEmpty())
        baseUrl.append("nota_min=").append(request.getParameter("nota_min")).append("&");
    if (request.getParameter("nota_max") != null && !request.getParameter("nota_max").isEmpty())
        baseUrl.append("nota_max=").append(request.getParameter("nota_max")).append("&");
    if (request.getParameter("busca") != null && !request.getParameter("busca").isEmpty())
        baseUrl.append("busca=").append(request.getParameter("busca")).append("&");
    if (request.getParameter("busca_precisa") != null && !request.getParameter("busca_precisa").isEmpty())
        baseUrl.append("busca_precisa=").append(request.getParameter("busca_precisa")).append("&");
    if (request.getParameter("data_inicio") != null && !request.getParameter("data_inicio").isEmpty())
        baseUrl.append("data_inicio=").append(request.getParameter("data_inicio")).append("&");
    if (request.getParameter("data_fim") != null && !request.getParameter("data_fim").isEmpty())
        baseUrl.append("data_fim=").append(request.getParameter("data_fim")).append("&");
    if (request.getParameter("esrb") != null && !request.getParameter("esrb").isEmpty())
        baseUrl.append("esrb=").append(request.getParameter("esrb")).append("&");
    if (request.getParameter("ordenacao") != null && !request.getParameter("ordenacao").isEmpty())
        baseUrl.append("ordenacao=").append(request.getParameter("ordenacao")).append("&");

    Boolean erroApi = (Boolean) request.getAttribute("erroApi");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jogos - JoyStream</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #121212;
            color: white;
        }

        header {
            background-color: #1f1f1f;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
        }

        header img {
            height: 50px;
        }

        nav {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        nav a, .user-name {
            color: #f1c40f;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        nav a:hover, .user-name:hover {
            background-color: #2a2a2a;
        }

        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #2a2a2a;
            min-width: 100px;
            box-shadow: 0px 8px 16px rgba(0,0,0,0.3);
            z-index: 1;
            border-radius: 5px;
        }

        .dropdown-content a {
            color: white;
            padding: 10px;
            text-decoration: none;
            display: block;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .nav-links a:hover {
            background-color: #2a2a2a;
        }

        .main-content {
            padding: 20px;
            display: flex;
            gap: 20px;
        }

        .filters {
            width: 300px;
            background-color: #1f1f1f;
            padding: 20px;
            border-radius: 10px;
            position: sticky;
            top: 20px;
            height: fit-content;
        }

        .games-list {
            flex: 1;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .game-card {
            background-color: #1f1f1f;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.2s;
            position: relative;
        }

        .game-card:hover {
            transform: translateY(-5px);
        }

        .game-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .game-info {
            padding: 15px;
        }

        .game-title {
            font-size: 1.2em;
            margin: 0 0 10px 0;
        }

        .game-details {
            color: #aaa;
            font-size: 0.9em;
        }

        .game-price {
            color: #f1c40f;
            font-weight: bold;
            margin-top: 10px;
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 20px 0;
            padding: 20px;
        }

        .pagination a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            background-color: #1f1f1f;
            transition: background-color 0.3s;
        }

        .pagination a:hover {
            background-color: #2a2a2a;
        }

        .pagination a.active {
            background-color: #f1c40f;
            color: black;
        }

        .no-games {
            grid-column: 1 / -1;
            text-align: center;
            padding: 40px;
            background-color: #1f1f1f;
            border-radius: 10px;
        }

        .form-control, .form-select {
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
            color: white;
        }

        .form-control:focus, .form-select:focus {
            background-color: #2a2a2a;
            border-color: #f1c40f;
            color: white;
            box-shadow: 0 0 0 0.25rem rgba(241, 196, 15, 0.25);
        }

        .form-label {
            color: #ddd;
        }

        .btn-primary {
            background-color: #f1c40f;
            border-color: #f1c40f;
            color: #000;
        }

        .btn-primary:hover {
            background-color: #f39c12;
            border-color: #f39c12;
        }

        .search-box {
            margin-bottom: 20px;
        }

        .filter-section {
            margin-bottom: 20px;
        }

        .filter-section h3 {
            color: #f1c40f;
            font-size: 1.1em;
            margin-bottom: 10px;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
            margin-top: 40px;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-name {
            color: #f1c40f;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .user-name:hover {
            background-color: #2a2a2a;
        }

        .select2-container--default .select2-selection--multiple {
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
            color: white;
        }
        
        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            background-color: #f1c40f;
            color: black;
            border: none;
        }
        
        .select2-dropdown {
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
        }
        
        .select2-container--default .select2-results__option {
            color: white;
        }
        
        .select2-container--default .select2-results__option--highlighted[aria-selected] {
            background-color: #f1c40f;
            color: black;
        }
        
        .filter-group {
            background-color: #2a2a2a;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .filter-group h4 {
            color: #f1c40f;
            margin-bottom: 10px;
            font-size: 1em;
        }
        
        .date-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        
        .rating-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        /* Estilos para o select múltiplo */
        .form-select[multiple] {
            padding: 0.375rem 0.75rem;
            background-image: none;
        }
        
        .form-select[multiple] option {
            padding: 0.5rem;
            margin: 2px 0;
            border-radius: 4px;
        }
        
        .form-select[multiple] option:checked {
            background-color: #f1c40f;
            color: black;
        }
        
        .form-select[multiple] option:hover {
            background-color: rgba(241, 196, 15, 0.1);
        }
        
        /* Ajuste do loader */
        #loader {
            background-color: rgba(18, 18, 18, 0.8) !important;
            z-index: 9999;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: none;
            justify-content: center;
            align-items: center;
        }
        
        .loader-content {
            background-color: #1f1f1f;
            padding: 2rem;
            border-radius: 10px;
            text-align: center;
        }
        
        /* Remove modal backdrop */
        .modal-backdrop {
            display: none !important;
        }

        .favorite-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(0, 0, 0, 0.5);
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            z-index: 1;
        }

        .favorite-btn i {
            color: white;
            font-size: 1.2em;
            transition: all 0.3s;
        }

        .favorite-btn:hover {
            background-color: rgba(241, 196, 15, 0.8);
        }

        .favorite-btn.active {
            background-color: rgba(241, 196, 15, 0.8);
        }

        .favorite-btn.active i {
            color: #fff;
        }
    </style>
</head>
<body>
    <div id="loader">
        <div class="loader-content">
            <div class="spinner-border text-warning" role="status" style="width: 4rem; height: 4rem;">
                <span class="visually-hidden">Carregando...</span>
            </div>
            <div class="mt-3 text-warning">Carregando jogos...</div>
        </div>
    </div>
    <header>
        <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo JoyStream">
        <nav>
            <div class="nav-links">
                <a href="home.jsp">HOME</a>
                <a href="perfil.jsp">PERFIL</a>
                <a href="jogos.jsp">JOGOS</a>
                <a href="suporte.jsp">SUPORTE</a>
                <a href="sobre.jsp">SOBRE</a>
            </div>
            <% if (logado) { %>
                <div class="dropdown">
                    <div class="user-info">
                        <img src="<%= avatarUrl %>" alt="Avatar" class="user-avatar">
                        <span class="user-name"><%= usuario.getNome() %></span>
                    </div>
                    <div class="dropdown-content">
                        <a href="perfil.jsp">Meu Perfil</a>
                        <a href="favoritos.jsp">Favoritos</a>
                        <a href="logout.jsp">Sair</a>
                    </div>
                </div>
            <% } else { %>
                <a href="login.jsp">Login</a>
                <a href="cadastro.jsp">Registrar</a>
            <% } %>
        </nav>
    </header>

    <div class="main-content">
        <div class="filters">
            <form action="jogos" method="GET" id="filterForm">
                <div class="filter-group">
                    <h4>Busca</h4>
                    <div class="mb-3">
                        <input type="text" class="form-control" name="busca" placeholder="Buscar jogos..." value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="busca_precisa" value="true" id="buscaPrecisa" <%= "true".equals(request.getParameter("busca_precisa")) ? "checked" : "" %>>
                        <label class="form-check-label" for="buscaPrecisa">
                            Busca precisa
                        </label>
                    </div>
                </div>

                <div class="filter-group">
                    <h4>Plataformas</h4>
                    <select class="form-select" name="plataforma" multiple>
                        <option value="4" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("4") ? "selected" : "" %>>PC</option>
                        <option value="187" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("187") ? "selected" : "" %>>PlayStation 5</option>
                        <option value="1" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("1") ? "selected" : "" %>>Xbox One</option>
                        <option value="7" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("7") ? "selected" : "" %>>Nintendo Switch</option>
                        <option value="18" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("18") ? "selected" : "" %>>PlayStation 4</option>
                        <option value="186" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("186") ? "selected" : "" %>>Xbox Series S/X</option>
                    </select>
                </div>

                <div class="filter-group">
                    <h4>Gêneros</h4>
                    <select class="form-select" name="genero" multiple>
                        <option value="4" <%= generos != null && java.util.Arrays.asList(generos).contains("4") ? "selected" : "" %>>Ação</option>
                        <option value="3" <%= generos != null && java.util.Arrays.asList(generos).contains("3") ? "selected" : "" %>>Aventura</option>
                        <option value="5" <%= generos != null && java.util.Arrays.asList(generos).contains("5") ? "selected" : "" %>>RPG</option>
                        <option value="2" <%= generos != null && java.util.Arrays.asList(generos).contains("2") ? "selected" : "" %>>Tiro</option>
                        <option value="10" <%= generos != null && java.util.Arrays.asList(generos).contains("10") ? "selected" : "" %>>Estratégia</option>
                        <option value="14" <%= generos != null && java.util.Arrays.asList(generos).contains("14") ? "selected" : "" %>>Simulação</option>
                        <option value="15" <%= generos != null && java.util.Arrays.asList(generos).contains("15") ? "selected" : "" %>>Esporte</option>
                        <option value="7" <%= generos != null && java.util.Arrays.asList(generos).contains("7") ? "selected" : "" %>>Puzzle</option>
                    </select>
                </div>

                <div class="filter-group">
                    <h4>Nota Mínima</h4>
                    <select class="form-select" name="nota_min">
                        <option value="01" <%= "01".equals(request.getParameter("nota_min")) ? "selected" : "" %>>Qualquer</option>
                        <option value="90" <%= "90".equals(request.getParameter("nota_min")) ? "selected" : "" %>>90+</option>
                        <option value="80" <%= "80".equals(request.getParameter("nota_min")) ? "selected" : "" %>>80+</option>
                        <option value="70" <%= "70".equals(request.getParameter("nota_min")) ? "selected" : "" %>>70+</option>
                        <option value="60" <%= "60".equals(request.getParameter("nota_min")) ? "selected" : "" %>>60+</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100">Aplicar Filtros</button>
                <button type="button" class="btn btn-outline-warning w-100 mt-2" onclick="limparFiltros()">Limpar Filtros</button>
            </form>
        </div>

        <div class="games-list">
            <% if (erroApi != null && erroApi) { %>
                <div class="no-games">
                    <p>Não foi possível carregar os jogos no momento. Tente novamente mais tarde.</p>
                </div>
            <% } else if (jogos != null && !jogos.isEmpty()) { %>
                <% for (JSONObject jogo : jogos) { %>
                    <div class="game-card">
                        <img src="<%= jogo.getJSONArray("short_screenshots").length() > 0 ? jogo.getJSONArray("short_screenshots").getJSONObject(0).getString("image") : "assets/img/default-game.png" %>" alt="<%= jogo.getString("name") %>">
                        <% if (logado) { %>
                            <button class="favorite-btn" onclick="toggleFavorito(this, <%= jogo.getInt("id") %>, '<%= jogo.getString("name").replace("'", "\\'") %>', '<%= jogo.getJSONArray("short_screenshots").length() > 0 ? jogo.getJSONArray("short_screenshots").getJSONObject(0).getString("image") : "assets/img/default-game.png" %>', '<%= jogo.getString("released") %>', <%= jogo.has("metacritic") ? jogo.getInt("metacritic") : "null" %>)">
                                <i class="far fa-heart"></i>
                            </button>
                        <% } %>
                        <div class="game-info">
                            <h3 class="game-title"><%= jogo.getString("name") %></h3>
                            <div class="game-details">
                                <p>Lançamento: <%= jogo.getString("released") %></p>
                                <% if (jogo.has("metacritic")) { %>
                                    <p>Nota: <%= jogo.getInt("metacritic") %></p>
                                <% } %>
                                <% if (jogo.has("platforms")) { %>
                                    <p>Plataformas: 
                                        <% for (int p = 0; p < jogo.getJSONArray("platforms").length(); p++) { %>
                                            <%= jogo.getJSONArray("platforms").getJSONObject(p).getJSONObject("platform").getString("name") %><%= p < jogo.getJSONArray("platforms").length() - 1 ? ", " : "" %>
                                        <% } %>
                                    </p>
                                <% } %>
                                <% if (jogo.has("genres")) { %>
                                    <p>Gêneros: 
                                        <% for (int g = 0; g < jogo.getJSONArray("genres").length(); g++) { %>
                                            <%= jogo.getJSONArray("genres").getJSONObject(g).getString("name") %><%= g < jogo.getJSONArray("genres").length() - 1 ? ", " : "" %>
                                        <% } %>
                                    </p>
                                <% } %>
                            </div>
                            <a href="detalhe.jsp?id=<%= jogo.getInt("id") %>" class="btn btn-primary mt-2 w-100">Ver Detalhes</a>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-games">
                    <p>Nenhum jogo encontrado com os filtros selecionados.</p>
                </div>
            <% } %>
        </div>
    </div>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Melhora a interação dos selects múltiplos no desktop
        document.querySelectorAll('select[multiple]').forEach(function(select) {
            select.addEventListener('mousedown', function(e) {
                e.preventDefault();
                
                const option = e.target;
                if (option.tagName === 'OPTION') {
                    option.selected = !option.selected;
                    
                    // Dispara um evento de change para atualizar o estado visual
                    const event = new Event('change', { bubbles: true });
                    this.dispatchEvent(event);
                }
            });

            // Previne o comportamento padrão de seleção do navegador
            select.addEventListener('mousemove', function(e) {
                e.preventDefault();
            });
        });

        // Mostra o loader apenas na primeira carga ou quando aplicar filtros
        if (!window.location.search) {
            showLoader();
            document.querySelector('.filters form').submit();
        }

        // Adiciona o loader ao submeter o formulário
        document.getElementById('filterForm').addEventListener('submit', function() {
            showLoader();
        });

        // Verifica o estado inicial dos favoritos
        if (<%= logado %>) {
            document.querySelectorAll('.game-card').forEach(card => {
                const btn = card.querySelector('.favorite-btn');
                if (btn) {
                    const jogoId = btn.getAttribute('onclick').match(/\d+/)[0];
                    checkFavorito(jogoId, btn);
                }
            });
        }
    });

    function showLoader() {
        const loader = document.getElementById('loader');
        if (loader) {
            loader.style.display = 'flex';
        }
    }

    function hideLoader() {
        const loader = document.getElementById('loader');
        if (loader) {
            loader.style.display = 'none';
        }
    }

    function limparFiltros() {
        showLoader();
        document.getElementById('filterForm').reset();
        document.getElementById('filterForm').submit();
    }

    function checkFavorito(jogoId, btn) {
        fetch('favorito/check?jogoId=' + jogoId)
            .then(response => response.json())
            .then(data => {
                if (data.isFavorito) {
                    btn.classList.add('active');
                    btn.querySelector('i').classList.remove('far');
                    btn.querySelector('i').classList.add('fas');
                }
            })
            .catch(error => console.error('Erro:', error));
    }

    function toggleFavorito(btn, jogoId, nomeJogo, imagemUrl, dataLancamento, nota) {
        const isActive = btn.classList.contains('active');
        const action = isActive ? 'remover' : 'adicionar';
        
        const params = new URLSearchParams();
        params.append('action', action);
        params.append('jogoId', jogoId);
        
        if (!isActive) {
            params.append('nomeJogo', nomeJogo);
            params.append('imagemUrl', imagemUrl);
            params.append('dataLancamento', dataLancamento);
            if (nota !== null) {
                params.append('nota', nota);
            }
        }

        fetch('favorito', {
            method: 'POST',
            body: params
        }).then(response => {
            if (response.ok) {
                btn.classList.toggle('active');
                const icon = btn.querySelector('i');
                icon.classList.toggle('far');
                icon.classList.toggle('fas');
            } else {
                alert('Erro ao ' + (isActive ? 'remover dos' : 'adicionar aos') + ' favoritos');
            }
        }).catch(error => {
            console.error('Erro:', error);
            alert('Erro ao processar a requisição');
        });
    }

    window.onload = function() {
        hideLoader();
    };
    </script>
</body>
</html> 