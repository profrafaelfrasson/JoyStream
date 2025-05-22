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
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jogos - JoyStream</title>
    <link rel="icon" type="image/x-icon" href="assets/img/img/logo.ico">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
    </style>
</head>
<body>
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
            <form action="jogos" method="GET">
                <div class="search-box">
                    <input type="text" class="form-control" name="busca" placeholder="Buscar jogos..." value="<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">
                </div>

                <div class="filter-section">
                    <h3>Plataforma</h3>
                    <select class="form-select" name="plataforma">
                        <option value="">Todas</option>
                        <option value="4" <%= "4".equals(request.getParameter("plataforma")) ? "selected" : "" %>>PC</option>
                        <option value="187" <%= "187".equals(request.getParameter("plataforma")) ? "selected" : "" %>>PlayStation 5</option>
                        <option value="1" <%= "1".equals(request.getParameter("plataforma")) ? "selected" : "" %>>Xbox One</option>
                        <option value="7" <%= "7".equals(request.getParameter("plataforma")) ? "selected" : "" %>>Nintendo Switch</option>
                    </select>
                </div>

                <div class="filter-section">
                    <h3>Gênero</h3>
                    <select class="form-select" name="genero">
                        <option value="">Todos</option>
                        <option value="4" <%= "4".equals(request.getParameter("genero")) ? "selected" : "" %>>Ação</option>
                        <option value="3" <%= "3".equals(request.getParameter("genero")) ? "selected" : "" %>>Aventura</option>
                        <option value="5" <%= "5".equals(request.getParameter("genero")) ? "selected" : "" %>>RPG</option>
                        <option value="2" <%= "2".equals(request.getParameter("genero")) ? "selected" : "" %>>Tiro</option>
                        <option value="10" <%= "10".equals(request.getParameter("genero")) ? "selected" : "" %>>Estratégia</option>
                    </select>
                </div>

                <div class="filter-section">
                    <h3>Nota Mínima</h3>
                    <select class="form-select" name="nota">
                        <option value="">Qualquer</option>
                        <option value="90" <%= "90".equals(request.getParameter("nota")) ? "selected" : "" %>>90+</option>
                        <option value="80" <%= "80".equals(request.getParameter("nota")) ? "selected" : "" %>>80+</option>
                        <option value="70" <%= "70".equals(request.getParameter("nota")) ? "selected" : "" %>>70+</option>
                        <option value="60" <%= "60".equals(request.getParameter("nota")) ? "selected" : "" %>>60+</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary w-100">Aplicar Filtros</button>
            </form>
        </div>

        <div class="games-list">
            <% if (jogos != null && !jogos.isEmpty()) { %>
                <% for (JSONObject jogo : jogos) { %>
                    <div class="game-card">
                        <img src="<%= jogo.getJSONArray("short_screenshots").length() > 0 ? jogo.getJSONArray("short_screenshots").getJSONObject(0).getString("image") : "assets/img/default-game.png" %>" alt="<%= jogo.getString("name") %>">
                        <div class="game-info">
                            <h3 class="game-title"><%= jogo.getString("name") %></h3>
                            <div class="game-details">
                                <p>Lançamento: <%= jogo.getString("released") %></p>
                                <% if (jogo.has("metacritic")) { %>
                                    <p>Nota: <%= jogo.getInt("metacritic") %></p>
                                <% } %>
                            </div>
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

    <% if (totalPages > 1) { %>
        <div class="pagination">
            <% int startPage = Math.max(1, currentPage - 2);
               int endPage = Math.min(totalPages, currentPage + 2);
               if (startPage > 1) { %>
                   <a href="jogos?pagina=1&plataforma=<%= request.getParameter("plataforma") != null ? request.getParameter("plataforma") : "" %>&genero=<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>&nota=<%= request.getParameter("nota") != null ? request.getParameter("nota") : "" %>&busca=<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">1</a>
                   <% if (startPage > 2) { %>
                       <span>...</span>
                   <% } %>
            <% } %>
            <% if (currentPage > 1) { %>
                <a href="jogos?pagina=<%= currentPage - 1 %>&plataforma=<%= request.getParameter("plataforma") != null ? request.getParameter("plataforma") : "" %>&genero=<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>&nota=<%= request.getParameter("nota") != null ? request.getParameter("nota") : "" %>&busca=<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">&laquo; Anterior</a>
            <% } %>
            <% for (int i = startPage; i <= endPage; i++) { %>
                <a href="jogos?pagina=<%= i %>&plataforma=<%= request.getParameter("plataforma") != null ? request.getParameter("plataforma") : "" %>&genero=<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>&nota=<%= request.getParameter("nota") != null ? request.getParameter("nota") : "" %>&busca=<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>" class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
            <% } %>
            <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>
                    <span>...</span>
                <% } %>
                <a href="jogos?pagina=<%= totalPages %>&plataforma=<%= request.getParameter("plataforma") != null ? request.getParameter("plataforma") : "" %>&genero=<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>&nota=<%= request.getParameter("nota") != null ? request.getParameter("nota") : "" %>&busca=<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>"><%= totalPages %></a>
            <% } %>
            <% if (currentPage < totalPages) { %>
                <a href="jogos?pagina=<%= currentPage + 1 %>&plataforma=<%= request.getParameter("plataforma") != null ? request.getParameter("plataforma") : "" %>&genero=<%= request.getParameter("genero") != null ? request.getParameter("genero") : "" %>&nota=<%= request.getParameter("nota") != null ? request.getParameter("nota") : "" %>&busca=<%= request.getParameter("busca") != null ? request.getParameter("busca") : "" %>">Próxima &raquo;</a>
            <% } %>
        </div>
    <% } %>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
    <script>
    window.onload = function() {
        // Se não há nenhum parâmetro na URL, submete o formulário automaticamente
        if (!window.location.search) {
            document.querySelector('.filters form').submit();
        }
    };
    </script>
</body>
</html> 