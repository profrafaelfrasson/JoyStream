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
    <title>Suporte - JoyStream</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">
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

        .support-content {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
        }

        .contact-form {
            background-color: #1f1f1f;
            padding: 30px;
            border-radius: 10px;
        }

        .contact-form h2 {
            color: #f1c40f;
            margin-bottom: 20px;
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

        .help-section {
            background-color: #1f1f1f;
            padding: 30px;
            border-radius: 10px;
        }

        .help-section h2 {
            color: #f1c40f;
            margin-bottom: 20px;
        }

        .faq-item {
            margin-bottom: 20px;
        }

        .faq-question {
            color: #f1c40f;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .faq-answer {
            color: #ddd;
            line-height: 1.6;
        }

        .contact-info {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #3a3a3a;
        }

        .contact-info p {
            margin: 10px 0;
            color: #ddd;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
            margin-top: 40px;
        }

        @media (max-width: 768px) {
            .support-content {
                grid-template-columns: 1fr;
            }
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

    <div class="support-content">
        <div class="contact-form">
            <h2>Entre em Contato</h2>
            <form id="supportForm">
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome</label>
                    <input type="text" class="form-control" id="nome" name="nome" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">E-mail</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="mb-3">
                    <label for="assunto" class="form-label">Assunto</label>
                    <select class="form-control" id="assunto" name="assunto" required>
                        <option value="">Selecione um assunto</option>
                        <option value="tecnico">Problema Técnico</option>
                        <option value="conta">Problema com Conta</option>
                        <option value="sugestao">Sugestão</option>
                        <option value="outro">Outro</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="mensagem" class="form-label">Mensagem</label>
                    <textarea class="form-control" id="mensagem" name="mensagem" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Enviar Mensagem</button>
            </form>
        </div>

        <div class="help-section">
            <h2>Perguntas Frequentes</h2>
            
            <div class="faq-item">
                <div class="faq-question">Como posso criar uma conta?</div>
                <div class="faq-answer">
                    Clique no botão "Registrar" no canto superior direito da página e preencha o formulário com seus dados.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">Esqueci minha senha, o que fazer?</div>
                <div class="faq-answer">
                    Na página de login, clique em "Esqueci minha senha" e siga as instruções para redefinir sua senha.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">Como posso adicionar jogos à minha biblioteca?</div>
                <div class="faq-answer">
                    Navegue até a página de jogos, encontre o jogo desejado e clique no botão "Adicionar à Biblioteca".
                </div>
            </div>

            <div class="contact-info">
                <h3>Outras formas de contato</h3>
                <p>E-mail: suporte@joystream.com</p>
                <p>Horário de atendimento: Segunda a Sexta, 9h às 18h</p>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
    <script>
        document.getElementById('supportForm').addEventListener('submit', function(e) {
            e.preventDefault();
            // Aqui você implementará a lógica de envio do formulário quando tiver o backend pronto
            alert('Mensagem enviada com sucesso! Entraremos em contato em breve.');
            this.reset();
        });
    </script>
</body>
</html> 