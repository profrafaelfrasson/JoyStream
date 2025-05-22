<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    String avatarUrl = (usuario != null && usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sobre - JoyStream</title>
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

        .about-content {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background-color: #1f1f1f;
            border-radius: 10px;
        }

        .about-content h1 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 30px;
        }

        .about-content p {
            line-height: 1.6;
            margin-bottom: 20px;
            text-align: justify;
        }

        .team-section {
            margin-top: 40px;
        }

        .team-section h2 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 20px;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .team-member {
            background-color: #2a2a2a;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .team-member h3 {
            color: #f1c40f;
            margin: 10px 0;
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

    <div class="about-content">
        <h1>Sobre o JoyStream</h1>
        <p>O JoyStream é uma plataforma desenvolvida como projeto acadêmico para a Univinte Fucap, com o objetivo de criar um espaço onde os amantes de jogos possam descobrir, recomendar e compartilhar suas experiências com diferentes títulos.</p>
        
        <p>Nossa plataforma oferece uma interface intuitiva e moderna, permitindo que os usuários explorem uma vasta biblioteca de jogos, filtrem por diferentes categorias e compartilhem suas opiniões com a comunidade.</p>

        <div class="team-section">
            <h2>Nossa Equipe</h2>
            <div class="team-grid">
                <div class="team-member">
                    <h3>Manoel</h3>
                    <p>Desenvolvedor</p>
                </div>
                <div class="team-member">
                    <h3>Patrick</h3>
                    <p>Desenvolvedor</p>
                </div>
                <div class="team-member">
                    <h3>Vitória</h3>
                    <p>Analista e QA</p>
                </div>
                <div class="team-member">
                    <h3>Felipe</h3>
                    <p>Líder do Projeto</p>
                </div>
                <div class="team-member">
                    <h3>Ana Carolina</h3>
                    <p>Banco de Dados</p>
                </div>
                <div class="team-member">
                    <h3>Ewellim</h3>
                    <p>Banco de Dados</p>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>
</body>
</html> 