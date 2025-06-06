<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>

<!-- Inclui o arquivo de inicialização -->
<%@ include file="components/init.jsp" %>

<%
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <%
        request.setAttribute("pageTitle", "Alterar Senha | JoyStream");
        request.setAttribute("pageDescription", "Altere sua senha da JoyStream de forma segura.");
        request.setAttribute("pageKeywords", "alterar senha, segurança, conta, joystream");
    %>
    <%@ include file="components/head.jsp" %>
    
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

        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 40px 20px;
        }

        .password-container {
            background-color: #1f1f1f;
            padding: 40px;
            border-radius: 10px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .password-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .password-title {
            color: #f1c40f;
            font-size: 2em;
            margin-bottom: 10px;
        }

        .password-subtitle {
            color: #aaa;
            font-size: 1.1em;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            color: #f1c40f;
            margin-bottom: 8px;
            font-weight: bold;
        }

        .form-input {
            width: 100%;
            padding: 12px;
            border: 2px solid #2a2a2a;
            border-radius: 5px;
            background-color: #2a2a2a;
            color: white;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        .form-input:focus {
            outline: none;
            border-color: #f1c40f;
        }

        .form-button {
            width: 100%;
            padding: 12px;
            background-color: #f1c40f;
            color: #1f1f1f;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 10px;
        }

        .form-button:hover {
            background-color: #f39c12;
        }

        .form-button.secondary {
            background-color: #2a2a2a;
            color: white;
        }

        .form-button.secondary:hover {
            background-color: #3a3a3a;
        }

        .error-message {
            background-color: #ff4444;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }

        .success-message {
            background-color: #00C851;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }

        .password-requirements {
            font-size: 0.9em;
            color: #aaa;
            margin-top: 5px;
        }

        .show-password {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 8px;
            color: #aaa;
            cursor: pointer;
        }

        .show-password input[type="checkbox"] {
            margin: 0;
        }
    </style>
</head>
<body>
    <%@ include file="components/header.jsp" %>

    <div class="main-content">
        <div class="password-container">
            <div class="password-header">
                <h1 class="password-title">Alterar Senha</h1>
                <p class="password-subtitle">Mantenha sua conta segura com uma senha forte</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>

            <form id="formAlterarSenha" onsubmit="alterarSenha(event)">
                <div class="form-group">
                    <label for="senhaAtual" class="form-label">Senha Atual</label>
                    <input type="password" id="senhaAtual" name="senhaAtual" class="form-input" required>
                    <label class="show-password">
                        <input type="checkbox" onchange="toggleSenha('senhaAtual')">
                        Mostrar senha
                    </label>
                </div>

                <div class="form-group">
                    <label for="novaSenha" class="form-label">Nova Senha</label>
                    <input type="password" id="novaSenha" name="novaSenha" class="form-input" required
                           pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
                           title="A senha deve conter pelo menos 8 caracteres, incluindo letras e números">
                    <p class="password-requirements">
                        A senha deve conter pelo menos 8 caracteres, incluindo letras e números
                    </p>
                    <label class="show-password">
                        <input type="checkbox" onchange="toggleSenha('novaSenha')">
                        Mostrar senha
                    </label>
                </div>

                <div class="form-group">
                    <label for="confirmarSenha" class="form-label">Confirmar Nova Senha</label>
                    <input type="password" id="confirmarSenha" name="confirmarSenha" class="form-input" required>
                    <label class="show-password">
                        <input type="checkbox" onchange="toggleSenha('confirmarSenha')">
                        Mostrar senha
                    </label>
                </div>

                <button type="submit" class="form-button">Alterar Senha</button>
                <a href="perfil.jsp" class="form-button secondary">Cancelar</a>
            </form>
        </div>
    </div>

    <%@ include file="components/footer.jsp" %>

    <script src="assets/js/alert.js"></script>
    <script>
        document.getElementById('formAlterarSenha').addEventListener('submit', function(e) {
            e.preventDefault();
            const novaSenha = document.getElementById('novaSenha').value;
            const confirmarSenha = document.getElementById('confirmarSenha').value;

            if (novaSenha !== confirmarSenha) {
                showError('Erro', 'As senhas não coincidem');
                return;
            }

            if (novaSenha.length < 8 || !/[a-zA-Z]/.test(novaSenha) || !/\d/.test(novaSenha)) {
                showError('Erro', 'A senha deve ter pelo menos 8 caracteres, incluindo letras e números');
                return;
            }

            fetch('alterar-senha', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(new FormData(this))
            }).then(response => {
                if (response.ok) {
                    showSuccess('Sucesso', 'Senha alterada com sucesso!');
                    setTimeout(() => {
                        window.location.href = 'login.jsp';
                    }, 2000);
                } else {
                    showError('Erro', 'Não foi possível alterar a senha');
                }
            }).catch(error => {
                console.error('Erro:', error);
                showError('Erro', 'Não foi possível alterar a senha');
            });
        });

        document.getElementById('mostrarSenha').addEventListener('change', function() {
            const tipo = this.checked ? 'text' : 'password';
            document.getElementById('novaSenha').type = tipo;
            document.getElementById('confirmarSenha').type = tipo;
        });
    </script>
</body>
</html> 