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
    <title>Recuperar Senha - JoyStream</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #121212;
            color: white;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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

        .auth-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .auth-box {
            background-color: #1f1f1f;
            padding: 30px;
            border-radius: 10px;
            width: 100%;
            max-width: 400px;
        }

        .auth-box h2 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-control {
            background-color: #2a2a2a;
            border: 1px solid #3a3a3a;
            color: white;
            margin-bottom: 15px;
        }

        .form-control:focus {
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

        .auth-link {
            display: block;
            text-align: center;
            color: #f1c40f;
            text-decoration: none;
            margin-top: 20px;
        }

        .auth-link:hover {
            text-decoration: underline;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
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

    <div class="auth-container">
        <div class="auth-box">
            <h2>Recuperar Senha</h2>
            <form id="recoveryForm">
                <div class="mb-3">
                    <label for="email" class="form-label">E-mail</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Enviar Link de Recuperação</button>
            </form>
            <a href="login.jsp" class="auth-link">Voltar para o Login</a>
        </div>
    </div>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
    <script>
        document.getElementById('recoveryForm').addEventListener('submit', function(e) {
            e.preventDefault();
            // Aqui você implementará a lógica de recuperação de senha quando tiver o backend pronto
            alert('Se o e-mail estiver cadastrado, você receberá um link para redefinir sua senha.');
            this.reset();
        });
    </script>
</body>
</html> 