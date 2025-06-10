<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.List" %>
<%@ page import="com.joystream.util.DateUtil" %>
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


    
    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "Catálogo Completo | Explore e Descubra Novos Jogos - JoyStream");
    request.setAttribute("pageDescription", "Explore nossa biblioteca completa de jogos, filtre por gênero, plataforma e avaliações. Encontre os melhores jogos com recomendações personalizadas e avaliações da comunidade.");
    request.setAttribute("pageKeywords", "catálogo de jogos, jogos online, filtro de jogos, metacritic, avaliações de jogos, biblioteca de jogos, plataformas de jogos, gêneros de jogos");
    
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <jsp:include page="components/head.jsp" />
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #121212;
            color: white;
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
            /* max-height: 90vh; */
            display: flex;
            flex-direction: column;
        }

        .filters-content {
            /* overflow-y: auto;
            max-height: 65vh; */
            flex: 1 1 auto;
        }

        .filter-actions {
            margin-top: 15px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex-shrink: 0;
        }

        .games-list {
            flex: 1;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding-bottom: 7rem;
            align-content: space-between;
    position: relative;
        }

        .game-card {
            background-color: #1f1f1f;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.2s;
            position: relative;
            display: flex;
            flex-direction: column;
            height: 100%;
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
            display: flex;
            flex-direction: column;
            flex: 1;
            position: relative;
        }

        .game-title {
            font-size: 1.2em;
            margin: 0 0 10px 0;
        }

        .game-details {
            color: #aaa;
            font-size: 0.9em;
            margin-bottom: 15px;
            height: 100%;
        }

        .game-price {
            color: #f1c40f;
            font-weight: bold;
            margin-top: 10px;
        }

        .game-info .btn {
            margin-top: auto;
        }

        .pagination {
            margin: 2rem 0;
            justify-content: center;
        }

        .pagination .page-item .page-link {
            background-color: #2a2a2a;
            border-color: #3a3a3a;
            color: #f1c40f;
            padding: 0.75rem 1rem;
            margin: 0 0.25rem;
            border-radius: 0.25rem;
            transition: all 0.3s ease;
        }

        .pagination .page-item .page-link:hover {
            background-color: #3a3a3a;
            border-color: #4a4a4a;
            color: #f1c40f;
        }

        .pagination .page-item.active .page-link {
            background-color: #f1c40f;
            border-color: #f1c40f;
            color: #000;
        }

        .pagination .page-item.disabled .page-link {
            background-color: #1f1f1f;
            border-color: #2a2a2a;
            color: #666;
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
            background-color: #2a2a2a !important;
            border: 1px solid #3a3a3a !important;
        }
        
        .select2-container--default .select2-selection--multiple .select2-selection__choice {
            background-color: #3a3a3a !important;
            border: 1px solid #4a4a4a !important;
            color: white !important;
        }
        
        .select2-dropdown {
            background-color: #2a2a2a !important;
            border: 1px solid #3a3a3a !important;
        }
        
        .select2-search__field {
            background-color: #3a3a3a !important;
            color: white !important;
        }
        
        .select2-results__option {
            color: white !important;
        }
        
        .select2-container--default .select2-results__option--highlighted[aria-selected] {
            background-color: #f1c40f !important;
            color: black !important;
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

        .nav-pagination {
            position: absolute;
    bottom: 0;
    height: 5rem;
    left: 0;
    margin-inline: auto;
    left: 50%;
    transform: translateX(-50%);
        }

        /* Custom Multiselect Styles */
        .custom-multiselect-wrapper {
            position: relative;
            width: 100%;
        }

        .custom-multiselect-button {
            width: 100%;
            padding: 8px 12px;
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
            color: white;
            text-align: left;
            cursor: pointer;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .custom-multiselect-button:after {
            content: '▼';
            font-size: 12px;
            margin-left: 10px;
        }

        .custom-multiselect-button:hover {
            background-color: #3a3a3a;
        }

        .custom-multiselect-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
            border-radius: 4px;
            margin-top: 4px;
            max-height: 300px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }

        .custom-multiselect-dropdown.show {
            display: block;
        }

        .custom-multiselect-option {
            padding: 8px 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            color: white;
        }

        .custom-multiselect-option:hover {
            background-color: #3a3a3a;
        }

        .custom-multiselect-option.selected {
            background-color: rgba(241, 196, 15, 0.1);
        }

        .custom-multiselect-option input[type="checkbox"] {
            margin-right: 8px;
        }

        .custom-multiselect-option input[type="checkbox"]:checked {
            animation: pulse .7s linear;
        }

        @keyframes pulse {
            0% {
                margin-right: 12px;
            }
            100% {
                margin-right: 8px;
            }
        }

        .select-all-option {
            border-bottom: 1px solid #3a3a3a;
            font-weight: bold;
            color: #f1c40f;
        }

        /* Scrollbar Styling */
        .custom-multiselect-dropdown::-webkit-scrollbar {
            width: 8px;
        }

        .custom-multiselect-dropdown::-webkit-scrollbar-track {
            background: #1f1f1f;
        }

        .custom-multiselect-dropdown::-webkit-scrollbar-thumb {
            background: #3a3a3a;
            border-radius: 4px;
        }

        .custom-multiselect-dropdown::-webkit-scrollbar-thumb:hover {
            background: #4a4a4a;
        }

        /* Estilos para o botão flutuante e modal de filtros */
        .filter-fab {
            display: none;
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background-color: #f1c40f;
            color: #000;
            border: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            cursor: pointer;
            transition: transform 0.2s;
        }

        .filter-fab:hover {
            transform: scale(1.1);
        }

        .filter-fab i {
            font-size: 24px;
        }

        .modal-filter {
            background-color: #1f1f1fe8;
            backdrop-filter: blur(8px);
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1050;
            display: none;
            overflow-y: auto;
            padding-top: var(--height-header);
            transition: all 0.4s ease-in-out;
        }

        .modal-filter.show {
            display: block;
        }

        .modal-filter .modal-dialog {
            position: relative;
            width: auto;
            margin: 0.5rem;
            pointer-events: none;
            max-width: 500px;
            margin: 1.75rem auto;
            transition: transform 0.3s ease-out;
        }

        .modal-filter.show .modal-dialog {
            transform: none;
        }

        .modal-filter:not(.show) .modal-dialog {
            transform: translateY(-50px);
        }

        .modal-filter .modal-content {
            background-color: #1f1f1f;
            color: white;
            position: relative;
            display: flex;
            flex-direction: column;
            width: 100%;
            pointer-events: auto;
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 0.5rem;
            outline: 0;
        }

        .modal-filter .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1rem;
            border-bottom: 1px solid #3a3a3a;
        }

        .modal-filter .modal-body {
            position: relative;
            flex: 1 1 auto;
            padding: 1rem;
        }

        .modal-filter .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
            padding: 1rem;
            border-top: 1px solid #3a3a3a;
        }

        .modal-filter .btn-close {
            background: transparent;
            border: none;
            color: #aaa;
            font-size: 1.5rem;
            padding: 0.5rem;
            cursor: pointer;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .modal-filter .btn-close:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1040;
            display: none;
        }

        .modal-backdrop.show {
            display: block;
        }

        @media (max-width: 768px) {
            .main-content {
                flex-direction: column;
                padding: 10px;
            }

            .filters {
                display: none;
            }

            .filter-fab {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .games-list {
                width: 100%;
            }

            .modal-filter .filters {
                position: static;
                width: 100%;
                max-height: none;
                display: block;
            }

            .modal-filter .filter-actions {
                position: static;
                padding: 15px 0;
            }
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

    <jsp:include page="components/header.jsp" />

<main>
    <div class="main-content">
        <div class="filters">
            <form action="jogos" method="GET" id="filterForm">
                <div class="filters-content">
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
                        <div class="custom-multiselect-wrapper">
                            <button type="button" class="custom-multiselect-button" data-target="platform-select">
                                Selecione as Plataformas
                            </button>
                            <div class="custom-multiselect-dropdown" id="platform-dropdown">
                                <label class="custom-multiselect-option select-all-option">
                                    <input type="checkbox" class="select-all"> Todas as Plataformas
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="plataforma" value="4" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("4") ? "checked" : "" %>> PC
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="plataforma" value="187" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("187") ? "checked" : "" %>> PlayStation 5
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="plataforma" value="1" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("1") ? "checked" : "" %>> Xbox One
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="plataforma" value="7" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("7") ? "checked" : "" %>> Nintendo Switch
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="plataforma" value="18" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("18") ? "checked" : "" %>> PlayStation 4
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="plataforma" value="186" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("186") ? "checked" : "" %>> Xbox Series S/X
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="filter-group">
                        <h4>Gêneros</h4>
                        <div class="custom-multiselect-wrapper">
                            <button type="button" class="custom-multiselect-button" data-target="genre-select">
                                Selecione os Gêneros
                            </button>
                            <div class="custom-multiselect-dropdown" id="genre-dropdown">
                                <label class="custom-multiselect-option select-all-option">
                                    <input type="checkbox" class="select-all"> Todos os Gêneros
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="4" <%= generos != null && java.util.Arrays.asList(generos).contains("4") ? "checked" : "" %>> Ação
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="3" <%= generos != null && java.util.Arrays.asList(generos).contains("3") ? "checked" : "" %>> Aventura
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="5" <%= generos != null && java.util.Arrays.asList(generos).contains("5") ? "checked" : "" %>> RPG
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="2" <%= generos != null && java.util.Arrays.asList(generos).contains("2") ? "checked" : "" %>> Tiro
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="10" <%= generos != null && java.util.Arrays.asList(generos).contains("10") ? "checked" : "" %>> Estratégia
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="14" <%= generos != null && java.util.Arrays.asList(generos).contains("14") ? "checked" : "" %>> Simulação
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="15" <%= generos != null && java.util.Arrays.asList(generos).contains("15") ? "checked" : "" %>> Esporte
                                </label>
                                <label class="custom-multiselect-option">
                                    <input type="checkbox" name="genero" value="7" <%= generos != null && java.util.Arrays.asList(generos).contains("7") ? "checked" : "" %>> Puzzle
                                </label>
                            </div>
                        </div>
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
                </div>
                <div class="filter-actions">
                    <button type="submit" class="btn btn-primary w-100">Aplicar Filtros</button>
                    <button type="button" class="btn btn-outline-warning w-100" onclick="limparFiltros()">Limpar Filtros</button>
                </div>
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
                        <img src="<%= jogo.getJSONArray("short_screenshots").length() > 0 ? jogo.getJSONArray("short_screenshots").getJSONObject(0).getString("image") : "assets/img/default-game.png" %>" alt="<%= jogo.getString("name") %>" draggable="false">
                        <% if (logado) { %>
                            <button class="favorite-btn" onclick="toggleFavorito(<%= jogo.getInt("id") %>, this)">
                                <i class="far fa-heart"></i>
                            </button>
                        <% } %>
                        <div class="game-info">
                            <h3 class="game-title"><%= jogo.getString("name") %></h3>
                            <div class="game-details">
                                <% if (jogo.has("released")) { %>
                                    <p>Lançamento: <%= DateUtil.formatarDataBrasileira(jogo.getString("released")) %></p>
                                <% } %>
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
            <!-- Pagination moved outside main-content -->
    <% if (jogos != null && !jogos.isEmpty()) { %>
        <nav aria-label="Navegação de páginas" class="mt-4 nav-pagination">
            <ul class="pagination pagination-circle justify-content-center">
                <!-- Previous button -->
                <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <a class="page-link pagination-link" href="<%= baseUrl.toString() %>pagina=<%= currentPage - 1 %>" tabindex="-1" aria-disabled="<%= currentPage == 1 %>">
                        <i class="fas fa-chevron-left"></i>
                        <span class="sr-only">Anterior</span>
                    </a>
                </li>

                <!-- First page -->
                <li class="page-item <%= currentPage == 1 ? "active" : "" %>">
                    <a class="page-link pagination-link" href="<%= baseUrl.toString() %>pagina=1">1</a>
                </li>

                <!-- Ellipsis if needed -->
                <% if (currentPage > 3) { %>
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                <% } %>

                <!-- Pages around current page -->
                <% 
                int startPage = Math.max(2, currentPage - 1);
                int endPage = Math.min(totalPages - 1, currentPage + 1);
                for (int i = startPage; i <= endPage; i++) { 
                    if (i > 1 && i < totalPages) { 
                %>
                    <li class="page-item <%= i == currentPage ? "active" : "" %>">
                        <a class="page-link pagination-link" href="<%= baseUrl.toString() %>pagina=<%= i %>"><%= i %></a>
                    </li>
                <% 
                    }
                } 
                %>

                <!-- Ellipsis if needed -->
                <% if (currentPage < totalPages - 2) { %>
                    <li class="page-item disabled">
                        <span class="page-link">...</span>
                    </li>
                <% } %>

                <!-- Last page if not first page -->
                <% if (totalPages > 1) { %>
                    <li class="page-item <%= currentPage == totalPages ? "active" : "" %>">
                        <a class="page-link pagination-link" href="<%= baseUrl.toString() %>pagina=<%= totalPages %>"><%= totalPages %></a>
                    </li>
                <% } %>

                <!-- Next button -->
                <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                    <a class="page-link pagination-link" href="<%= baseUrl.toString() %>pagina=<%= currentPage + 1 %>" aria-disabled="<%= currentPage == totalPages %>">
                        <i class="fas fa-chevron-right"></i>
                        <span class="sr-only">Próxima</span>
                    </a>
                </li>
            </ul>
        </nav>
    <% } %>
        </div>
    </div>
</main>

    <button type="button" class="filter-fab" onclick="openFilterModal()">
        <i class="fas fa-filter"></i>
    </button>

    <div class="modal-backdrop"></div>
    <!-- Modal de Filtros -->
    <div class="modal-filter" id="filterModal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Filtros</h5>
                    <button type="button" class="btn-close" onclick="closeFilterModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <form action="jogos" method="GET" id="filterFormMobile">
                        <div class="filter-group">
                            <h4>Busca</h4>
                            <div class="mb-3">
                                <input type="text" class="form-control" name="busca" placeholder="Buscar jogos..." value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="busca_precisa" value="true" id="buscaPrecisaMobile" <%= "true".equals(request.getParameter("busca_precisa")) ? "checked" : "" %>>
                                <label class="form-check-label" for="buscaPrecisaMobile">
                                    Busca precisa
                                </label>
                            </div>
                        </div>

                        <div class="filter-group">
                            <h4>Plataformas</h4>
                            <div class="custom-multiselect-wrapper">
                                <button type="button" class="custom-multiselect-button" data-target="platform-select-mobile">
                                    Selecione as Plataformas
                                </button>
                                <div class="custom-multiselect-dropdown" id="platform-dropdown-mobile">
                                    <label class="custom-multiselect-option select-all-option">
                                        <input type="checkbox" class="select-all"> Todas as Plataformas
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="plataforma" value="4" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("4") ? "checked" : "" %>> PC
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="plataforma" value="187" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("187") ? "checked" : "" %>> PlayStation 5
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="plataforma" value="1" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("1") ? "checked" : "" %>> Xbox One
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="plataforma" value="7" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("7") ? "checked" : "" %>> Nintendo Switch
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="plataforma" value="18" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("18") ? "checked" : "" %>> PlayStation 4
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="plataforma" value="186" <%= plataformas != null && java.util.Arrays.asList(plataformas).contains("186") ? "checked" : "" %>> Xbox Series S/X
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="filter-group">
                            <h4>Gêneros</h4>
                            <div class="custom-multiselect-wrapper">
                                <button type="button" class="custom-multiselect-button" data-target="genre-select-mobile">
                                    Selecione os Gêneros
                                </button>
                                <div class="custom-multiselect-dropdown" id="genre-dropdown-mobile">
                                    <label class="custom-multiselect-option select-all-option">
                                        <input type="checkbox" class="select-all"> Todos os Gêneros
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="4" <%= generos != null && java.util.Arrays.asList(generos).contains("4") ? "checked" : "" %>> Ação
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="3" <%= generos != null && java.util.Arrays.asList(generos).contains("3") ? "checked" : "" %>> Aventura
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="5" <%= generos != null && java.util.Arrays.asList(generos).contains("5") ? "checked" : "" %>> RPG
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="2" <%= generos != null && java.util.Arrays.asList(generos).contains("2") ? "checked" : "" %>> Tiro
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="10" <%= generos != null && java.util.Arrays.asList(generos).contains("10") ? "checked" : "" %>> Estratégia
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="14" <%= generos != null && java.util.Arrays.asList(generos).contains("14") ? "checked" : "" %>> Simulação
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="15" <%= generos != null && java.util.Arrays.asList(generos).contains("15") ? "checked" : "" %>> Esporte
                                    </label>
                                    <label class="custom-multiselect-option">
                                        <input type="checkbox" name="genero" value="7" <%= generos != null && java.util.Arrays.asList(generos).contains("7") ? "checked" : "" %>> Puzzle
                                    </label>
                                </div>
                            </div>
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
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-warning" onclick="limparFiltrosMobile()">Limpar Filtros</button>
                    <button type="button" class="btn btn-primary" onclick="aplicarFiltrosMobile()">Aplicar Filtros</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />

    <!-- MDB JavaScript -->
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script> -->
    <script src="assets/js/alert.js"></script>
    <script>
    // Definição das funções principais primeiro
    function initializeMultiselect() {
        const multiselects = document.querySelectorAll('.custom-multiselect-wrapper');
        
        // Remove any existing global click handler
        document.removeEventListener('click', closeAllDropdowns);
        document.removeEventListener('touchstart', closeAllDropdowns);
        
        // Function to close all dropdowns
        function closeAllDropdowns(e) {
            if (!e.target.closest('.custom-multiselect-wrapper')) {
                document.querySelectorAll('.custom-multiselect-dropdown').forEach(dropdown => {
                    dropdown.classList.remove('show');
                });
            }
        }
        
        // Add global handlers
        document.addEventListener('click', closeAllDropdowns);
        document.addEventListener('touchstart', closeAllDropdowns);
        
        multiselects.forEach(wrapper => {
            const button = wrapper.querySelector('.custom-multiselect-button');
            const dropdown = wrapper.querySelector('.custom-multiselect-dropdown');
            const options = dropdown.querySelectorAll('input[type="checkbox"]:not(.select-all)');
            const selectAll = dropdown.querySelector('.select-all');
            
            // Remove existing listeners
            const newButton = button.cloneNode(true);
            button.parentNode.replaceChild(newButton, button);
            
            function countCheckedOptions() {
                return Array.from(options).reduce((count, option) => count + (option.checked ? 1 : 0), 0);
            }
            
            function updateButtonText() {
                const checkedCount = countCheckedOptions();
                const totalOptions = options.length;
                
                if (checkedCount === 0) {
                    newButton.textContent = newButton.getAttribute('data-target').includes('platform') ? 
                        'Selecione as Plataformas' : 'Selecione os Gêneros';
                } else if (checkedCount === totalOptions) {
                    newButton.textContent = newButton.getAttribute('data-target').includes('platform') ? 
                        'Todas as Plataformas' : 'Todos os Gêneros';
                } else {
                    newButton.textContent = checkedCount + ' selecionado(s)';
                }
            }

            function updateSelectAllState() {
                if (selectAll) {
                    const checkedCount = countCheckedOptions();
                    const totalOptions = options.length;
                    selectAll.checked = checkedCount === totalOptions;
                    selectAll.indeterminate = checkedCount > 0 && checkedCount < totalOptions;
                }
            }

            function handleInteraction(e) {
                e.stopPropagation();
                if (e.type === 'click') {
                    e.preventDefault();
                }
                
                const isOpen = dropdown.classList.contains('show');
                
                // Fecha todos os outros dropdowns primeiro
                document.querySelectorAll('.custom-multiselect-dropdown').forEach(d => {
                    if (d !== dropdown) {
                        d.classList.remove('show');
                    }
                });
                
                if (isOpen) {
                    dropdown.classList.remove('show');
                } else {
                    dropdown.classList.add('show');
                }
            }

            // Adiciona os event listeners
            newButton.addEventListener('click', handleInteraction);
            newButton.addEventListener('touchstart', function(e) {
                if (e.cancelable) {
                    e.preventDefault();
                }
                handleInteraction(e);
            });

            // Handle select all
            if (selectAll) {
                selectAll.addEventListener('change', function(e) {
                    e.stopPropagation();
                    const isChecked = this.checked;
                    options.forEach(option => {
                        option.checked = isChecked;
                    });
                    updateButtonText();
                });
            }

            // Handle individual options
            options.forEach(option => {
                option.addEventListener('change', function(e) {
                    e.stopPropagation();
                    updateSelectAllState();
                    updateButtonText();
                });

                // Prevent dropdown from closing when clicking options
                option.addEventListener('click', e => e.stopPropagation());
            });

            // Prevent dropdown from closing when clicking inside
            dropdown.addEventListener('click', e => e.stopPropagation());

            // Initialize states
            updateSelectAllState();
            updateButtonText();
        });
    }

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

    // Funções do Modal
    function openFilterModal() {
        document.querySelector('.modal-backdrop').classList.add('show');
        document.querySelector('.modal-filter').classList.add('show');
        document.body.style.overflow = 'hidden'; // Previne rolagem do body
        
        // Reinicializa os multiselects quando o modal é aberto
        setTimeout(() => {
            initializeMultiselect();
        }, 100);
    }

    function closeFilterModal() {
        document.querySelector('.modal-backdrop').classList.remove('show');
        document.querySelector('.modal-filter').classList.remove('show');
        document.body.style.overflow = ''; // Restaura rolagem do body
    }

    // Event Listeners quando o DOM estiver pronto
    document.addEventListener('DOMContentLoaded', function() {
        // Inicializa os multiselects da página principal
        initializeMultiselect();

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

        // Add click event listener for pagination links
        document.querySelectorAll('.pagination-link').forEach(link => {
            link.addEventListener('click', function(e) {
                if (!this.parentElement.classList.contains('disabled')) {
                    e.preventDefault();
                    showLoader();
                    setTimeout(() => {
                        hideLoader();
                        window.location.href = this.href;
                    }, 200);
                }
            });
        });

        // Event listeners do modal
        document.querySelector('.modal-filter').addEventListener('click', function(e) {
            if (e.target === this) {
                closeFilterModal();
            }
        });

        document.querySelector('.modal-filter .modal-content').addEventListener('click', function(e) {
            e.stopPropagation();
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeFilterModal();
            }
        });
    });

    function limparFiltros() {
        // Limpar campo de busca
        document.querySelector('input[name="busca"]').value = '';
        
        // Desmarcar checkbox de busca precisa
        document.querySelector('#buscaPrecisa').checked = false;
        
        // Limpar todos os checkboxes dos multiselects
        document.querySelectorAll('.custom-multiselect-dropdown input[type="checkbox"]').forEach(checkbox => {
            checkbox.checked = false;
        });

        // Atualizar o texto dos botões
        document.querySelectorAll('.custom-multiselect-wrapper').forEach(wrapper => {
            const button = wrapper.querySelector('.custom-multiselect-button');
            button.textContent = button.getAttribute('data-target').includes('platform') ? 
                'Selecione as Plataformas' : 'Selecione os Gêneros';
        });

        // Limpar outros filtros se houver
        const notaMin = document.querySelector('select[name="nota_min"]');
        if (notaMin) notaMin.value = '01';

        // Submeter o formulário
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

    function toggleFavorito(jogoId, button) {
        const isActive = button.classList.contains('active');
        fetch('favorito?action=' + (isActive ? 'remover' : 'adicionar') + '&jogoId=' + jogoId, {
            method: 'POST'
        }).then(response => {
            if (response.ok) {
                button.classList.toggle('active');
                const icon = button.querySelector('i');
                if (isActive) {
                    icon.classList.remove('fas');
                    icon.classList.add('far');
                    showSuccess('Sucesso', 'Jogo removido dos favoritos');
                } else {
                    icon.classList.remove('far');
                    icon.classList.add('fas');
                    showSuccess('Sucesso', 'Jogo adicionado aos favoritos');
                }
            } else {
                showError('Erro', 'Não foi possível ' + (isActive ? 'remover dos' : 'adicionar aos') + ' favoritos');
            }
        }).catch(error => {
            console.error('Erro:', error);
            showError('Erro', 'Não foi possível processar a requisição');
        });
    }

    function aplicarFiltrosMobile() {
        document.getElementById('filterFormMobile').submit();
    }

    function limparFiltrosMobile() {
        // Limpar campo de busca
        document.querySelector('#filterFormMobile input[name="busca"]').value = '';
        
        // Desmarcar checkbox de busca precisa
        document.querySelector('#buscaPrecisaMobile').checked = false;
        
        // Limpar todos os checkboxes dos multiselects
        document.querySelectorAll('#filterFormMobile .custom-multiselect-dropdown input[type="checkbox"]').forEach(checkbox => {
            checkbox.checked = false;
        });

        // Atualizar o texto dos botões
        document.querySelectorAll('#filterFormMobile .custom-multiselect-wrapper').forEach(wrapper => {
            const button = wrapper.querySelector('.custom-multiselect-button');
            button.textContent = button.getAttribute('data-target').includes('platform') ? 
                'Selecione as Plataformas' : 'Selecione os Gêneros';
        });

        // Limpar nota mínima
        const notaMin = document.querySelector('#filterFormMobile select[name="nota_min"]');
        if (notaMin) notaMin.value = '01';

        // Submeter o formulário
        document.getElementById('filterFormMobile').submit();
    }
    </script>
</body>
</html> 