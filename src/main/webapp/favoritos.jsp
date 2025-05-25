<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.*" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Favorito> favoritos = (List<Favorito>) request.getAttribute("favoritos");
    if (favoritos == null) {
        response.sendRedirect("favorito");
        return;
    }
    
    String avatarUrl = (usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? 
        ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Favoritos - JoyStream</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">
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

        .nav-links {
            display: flex;
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

        .main-content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-title {
            color: #f1c40f;
            margin-bottom: 30px;
            font-size: 2em;
            text-align: center;
        }

        .games-grid {
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
            color: white;
        }

        .game-details {
            color: #aaa;
            font-size: 0.9em;
        }

        .remove-favorite {
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
            transition: background-color 0.3s;
        }

        .remove-favorite:hover {
            background-color: rgba(255, 0, 0, 0.5);
        }

        .remove-favorite i {
            color: white;
            font-size: 1.2em;
        }

        .no-favorites {
            text-align: center;
            padding: 40px;
            background-color: #1f1f1f;
            border-radius: 10px;
            grid-column: 1 / -1;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
            margin-top: 40px;
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
        </nav>
    </header>

    <div class="main-content">
        <h1 class="page-title">Meus Jogos Favoritos</h1>
        
        <div class="games-grid">
            <% if (favoritos != null && !favoritos.isEmpty()) { %>
                <% for (Favorito favorito : favoritos) { %>
                    <div class="game-card" id="game-<%= favorito.getJogoId() %>">
                        <img src="<%= favorito.getImagemUrl() %>" alt="<%= favorito.getNomeJogo() %>">
                        <button class="remove-favorite" onclick="removerFavorito(<%= favorito.getJogoId() %>)">
                            <i class="fas fa-heart-broken"></i>
                        </button>
                        <div class="game-info">
                            <h3 class="game-title"><%= favorito.getNomeJogo() %></h3>
                            <div class="game-details">
                                <p>Lançamento: <%= favorito.getDataLancamento() %></p>
                                <% if (favorito.getNota() != null) { %>
                                    <p>Nota: <%= favorito.getNota() %></p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-favorites">
                    <h3>Você ainda não tem jogos favoritos</h3>
                    <p>Vá para a página de <a href="jogos.jsp" style="color: #f1c40f;">Jogos</a> e favorite alguns!</p>
                </div>
            <% } %>
        </div>
    </div>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
    <script>
        function removerFavorito(jogoId) {
            if (confirm('Tem certeza que deseja remover este jogo dos favoritos?')) {
                fetch('favorito?action=remover&jogoId=' + jogoId, {
                    method: 'POST'
                }).then(response => {
                    if (response.ok) {
                        document.getElementById('game-' + jogoId).remove();
                        
                        // Verifica se ainda existem jogos favoritos
                        const gamesGrid = document.querySelector('.games-grid');
                        if (!gamesGrid.querySelector('.game-card')) {
                            gamesGrid.innerHTML = `
                                <div class="no-favorites">
                                    <h3>Você ainda não tem jogos favoritos</h3>
                                    <p>Vá para a página de <a href="jogos.jsp" style="color: #f1c40f;">Jogos</a> e favorite alguns!</p>
                                </div>
                            `;
                        }
                    } else {
                        alert('Erro ao remover o jogo dos favoritos');
                    }
                }).catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao remover o jogo dos favoritos');
                });
            }
        }
    </script>
</body>
</html> 