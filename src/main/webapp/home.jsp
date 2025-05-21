<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JoyStream - Recomende e descubra jogos</title>
    <link rel="icon" type="image/x-icon" href="assets/img/img/logo.ico">
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
        }

        nav a, .user-name {
            color: #f1c40f;
            margin-left: 20px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
        }

        nav a:hover, .user-name:hover {
            text-decoration: underline;
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

        .dropdown-content a:hover {
            background-color: #3a3a3a;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .hero {
            text-align: center;
            padding: 80px 20px;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
        }

        .hero h1 {
            font-size: 3em;
            margin-bottom: 10px;
        }

        .hero p {
            font-size: 1.2em;
            color: #ccc;
        }

        .games {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 40px;
        }

        .game-card {
            background-color: #1e1e1e;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .game-card:hover {
            transform: scale(1.03);
            box-shadow: 0 4px 15px rgba(0,0,0,0.4);
        }

        .game-card img {
            width: 100%;
            aspect-ratio: 16 / 9;
            object-fit: cover;
            border-radius: 5px;
        }

        .game-card h3 {
            margin: 10px 0 5px;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
        }
    </style>
</head>
<body>
<header>
    <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo JoyStream">
    <nav>
        <% if (logado) { %>
            <div class="dropdown">
                <span class="user-name"><%= usuario.getNome() %></span>
                <div class="dropdown-content">
                    <a href="logout.jsp">Sair</a>
                </div>
            </div>
        <% } else { %>
            <a href="login.jsp">Login</a>
            <a href="cadastro.jsp">Registrar</a>
        <% } %>
    </nav>
</header>

<section class="hero">
    <h1>Bem-vindo à JoyStream</h1>
    <p>Descubra, recomende e compartilhe os melhores jogos com seus amigos.</p>
</section>

<section class="games">
    <div class="game-card">
        <img src="<%= request.getContextPath() %>/assets/img/game1.jpg" alt="Game 1">
        <h3>Game 1</h3>
        <p>Aventura épica num mundo aberto.</p>
    </div>
    <div class="game-card">
        <img src="<%= request.getContextPath() %>/assets/img/game2.jpg" alt="Game 2">
        <h3>Game 2</h3>
        <p>Combates intensos e estratégia.</p>
    </div>
    <div class="game-card">
        <img src="<%= request.getContextPath() %>/assets/img/game3.jpg" alt="Game 3">
        <h3>Game 3</h3>
        <p>Simulador de vida relaxante.</p>
    </div>
</section>

<footer class="footer">
    &copy; 2025 JoyStream. Todos os direitos reservados.
</footer>
</body>
</html>
