<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "Login | Acesse Sua Conta - JoyStream");
    request.setAttribute("pageDescription", "Faça login na JoyStream e acesse sua conta para descobrir jogos personalizados, salvar favoritos e participar da comunidade gamer.");
    request.setAttribute("pageKeywords", "login joystream, acesso conta, entrar, conta gamer, autenticação, área do usuário");
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: linear-gradient(145deg, #1f1f1f, #242424);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
            margin: 20px;
        }

        .login-container h1 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 10px;
            font-size: 2.5em;
        }

        .login-subtitle {
            color: #888;
            text-align: center;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            color: #f1c40f;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            background-color: #2a2a2a;
            border: 2px solid #3a3a3a;
            border-radius: 8px;
            color: white;
            font-size: 1em;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-control:focus {
            border-color: #f1c40f;
            outline: none;
            box-shadow: 0 0 0 2px rgba(241, 196, 15, 0.2);
        }

        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: #f1c40f;
            border: none;
            border-radius: 8px;
            color: #000;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }

        .btn-login:hover {
            background-color: #f39c12;
            transform: translateY(-2px);
        }

        .links-container {
            text-align: center;
            margin-top: 20px;
        }

        .links-container p {
            margin: 10px 0;
            color: #888;
        }

        .links-container a {
            color: #f1c40f;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .links-container a:hover {
            color: #f39c12;
        }

        @media (max-width: 768px) {
            .login-container {
                max-width: 80%;
            }
        }

        /* Para telas menores que 480px (celulares) */
        @media (max-width: 480px) {
            .login-container {
                max-width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h1>Login</h1>
        <p class="login-subtitle">Bem-vindo de volta à JoyStream</p>
        
        <form action="login" method="post" id="loginForm">
            <div class="form-group">
                <label for="email">E-mail</label>
                <input type="email" class="form-control" id="email" name="email" autofocus required>
            </div>
            
            <div class="form-group">
                <label for="senha">Senha</label>
                <input type="password" class="form-control" id="senha" name="senha" required>
                <div class="form-check mt-2">
                    <input class="form-check-input" type="checkbox" id="mostrarSenha">
                    <label class="form-check-label" for="mostrarSenha">Mostrar senha</label>
                </div>
            </div>
            
            <button type="submit" class="btn-login">Entrar</button>
        </form>
        
        <div class="links-container">
            <p>Não tem uma conta? <a href="cadastro.jsp">Cadastre-se</a></p>
            <p><a href="recuperar-senha.jsp">Esqueceu sua senha?</a></p>
        </div>
    </div>

    <script src="assets/js/alert.js"></script>
    <script src="assets/js/auto-focus.js"></script>
    <script>
        document.getElementById("mostrarSenha").addEventListener("change", function () {
            const tipo = this.checked ? "text" : "password";
            document.getElementById("senha").type = tipo;
        });
    </script>

    <%
        String erroLogin = (String) request.getAttribute("erroLogin");
        if (erroLogin == null) {
            erroLogin = (String) session.getAttribute("erroLogin");
        }
        if (erroLogin != null) {
            erroLogin = erroLogin.replace("'", "\\'").replace("\"", "\\\"");
            erroLogin = erroLogin.replace("\n", "\\n").replace("\r", "\\r"); // Evita quebras de linha problemáticas
    %>
            <script>alertResult('error', '<%= erroLogin %>');</script>
    <%
            // Limpar a mensagem de erro da sessão após exibi-la
            session.removeAttribute("erroLogin");
        }
    %>


</body>
</html>