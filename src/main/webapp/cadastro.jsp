<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario != null) {
        response.sendRedirect("index.jsp");
        return;
    }

    request.setAttribute("pageTitle", "Cadastre-se | Crie Sua Conta Gratuita - JoyStream");
request.setAttribute("pageDescription", "Crie sua conta gratuita na JoyStream e comece a descobrir jogos personalizados, salvar favoritos e fazer parte da nossa comunidade gamer.");
request.setAttribute("pageKeywords", "cadastro joystream, criar conta, registro, nova conta, comunidade gamer, conta gratuita");
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

        .register-container {
            background: linear-gradient(145deg, #1f1f1f, #242424);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 650px;
            margin: 20px;
        }

        .register-container h1 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 10px;
            font-size: 2.5em;
        }

        .register-subtitle {
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

        .password-hint {
            color: #888;
            font-size: 0.85em;
            margin-top: 5px;
        }

        .terms-container {
            margin: 20px 0;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }

        .terms-container input[type="checkbox"] {
            margin-top: 4px;
        }

        .terms-container label {
            color: #888;
            font-size: 0.9em;
        }

        .terms-container a {
            color: #f1c40f;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .terms-container a:hover {
            color: #f39c12;
        }

        .btn-register {
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
        }

        .btn-register:hover {
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
            .register-container {
                max-width: 80%;
            }
        }

        /* Para telas menores que 480px (celulares) */
        @media (max-width: 480px) {
            .register-container {
                max-width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>Criar Conta</h1>
        <p class="register-subtitle">Junte-se à comunidade JoyStream</p>
        
        <form id="formCadastro" action="CadastroServlet" method="post" accept-charset="UTF-8" onsubmit="return validarCadastro();">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" class="form-control" id="nome" name="nome" required>
            </div>
            
            <div class="form-group">
                <label for="email">E-mail</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label for="senha">Senha</label>
                <input type="password" class="form-control" id="senha" name="senha" required>
                <p class="password-hint">A senha deve conter pelo menos 8 caracteres, incluindo letras e números</p>
            </div>
            
            <div class="form-group">
                <label for="confirmarSenha">Confirmar Senha</label>
                <input type="password" class="form-control" id="confirmarSenha" name="confirmarSenha" required>
            </div>

            <div class="form-check mb-4">
                <input class="form-check-input" type="checkbox" id="mostrarSenha" />
                <label class="form-check-label" for="mostrarSenha">Mostrar senha</label>
            </div>
            
            <div class="terms-container">
                <input type="checkbox" id="termos" name="termos" required>
                <label for="termos">Li e concordo com os <a href="termos.jsp">Termos de Uso</a> e a <a href="privacidade.jsp">Política de Privacidade</a></label>
            </div>
            
            <button type="submit" class="btn-register">Criar Conta</button>
        </form>
        
        <div class="links-container">
            <p>Já tem uma conta? <a href="login.jsp">Fazer Login</a></p>
        </div>
    </div>

    <script src="assets/js/alert.js"></script>
    <script src="assets/js/auto-focus.js"></script>


    <script>
        document.getElementById("formCadastro").addEventListener("submit", function (event) {
            const senha = document.getElementById("senha").value;
            const confirmarSenha = document.getElementById("confirmarSenha").value;

            if (senha !== confirmarSenha) {
                event.preventDefault();
                alertResult('error', 'As senhas não coincidem!');
            }
        });

        document.getElementById("mostrarSenha").addEventListener("change", function () {
            const tipo = this.checked ? "text" : "password";
            document.getElementById("senha").type = tipo;
            document.getElementById("confirmarSenha").type = tipo;
        });

        function validarCadastro() {
            var email = document.getElementById('email').value.trim();
            var senha = document.getElementById('senha').value;
            var nome = document.getElementById('nome').value.trim();
            var erro = '';

            var emailRegex = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
            if (!emailRegex.test(email)) {
                erro += 'E-mail inválido.\n';
            }
            if (nome.length < 2) {
                erro += 'Nome muito curto.\n';
            }
            if (senha.length < 6 || !/[a-zA-Z]/.test(senha) || !/\d/.test(senha)) {
                erro += 'A senha deve ter pelo menos 6 caracteres, incluindo letras e números.\n';
            }
            if (erro) {
                alertResult('error', erro);
                return false;
            }
            return true;
        }
    </script>
</body>
</html>