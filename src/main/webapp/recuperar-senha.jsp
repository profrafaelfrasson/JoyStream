<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario != null) {
        response.sendRedirect("index.jsp");
        return;
    }
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

        .recovery-container {
            background: linear-gradient(145deg, #1f1f1f, #242424);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 400px;
            margin: 20px;
        }

        .recovery-container h1 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 10px;
            font-size: 2.5em;
        }

        .recovery-subtitle {
            color: #888;
            text-align: center;
            margin-bottom: 30px;
            font-size: 0.95em;
            line-height: 1.5;
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

        .btn-send {
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

        .btn-send:hover {
            background-color: #f39c12;
            transform: translateY(-2px);
        }

        .info-text {
            color: #888;
            text-align: center;
            margin-top: 20px;
            font-size: 0.9em;
            line-height: 1.5;
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
    </style>
</head>
<body>
    <div class="recovery-container">
        <h1>Recuperar Senha</h1>
        <p class="recovery-subtitle">Digite seu e-mail cadastrado para receber as instruções de recuperação de senha</p>
        
        <form action="recuperar-senha" method="post" id="recoveryForm">
            <div class="form-group">
                <label for="email">E-mail</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            
            <button type="submit" class="btn-send">Enviar Instruções</button>
        </form>
        
        <p class="info-text">Você receberá um e-mail com instruções para criar uma nova senha.</p>
        
        <div class="links-container">
            <p>Lembrou sua senha? <a href="login.jsp">Voltar para o Login</a></p>
        </div>
    </div>
</body>
</html> 