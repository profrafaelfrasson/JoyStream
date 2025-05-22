<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="icon" type="image/x-icon" href="assets/logo.ico">

    <!-- MDB CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <!-- Sweetalert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="assets/css/style.css">
</head>

<body>
    <header>
        <img src="assets/img/logo.png" alt="Logo JoyStream">
        <nav>
            <a href="index.jsp">JoyStream</a>
        </nav>
    </header>

    <section class="hero">
        <div class="auth-card" id="loginForm">
            <h2>Login</h2>
            <form action="login" method="post" accept-charset="UTF-8">
                <div class="form-outline mb-4">
                    <input type="text" id="email" name="email" class="form-control" autocomplete="email" 
                        pattern="[a-zA-Z0-9._%+-áàâãéèêíïóôõöúüçÁÀÂÃÉÈÊÍÏÓÔÕÖÚÜÇ]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
                        title="Por favor, insira um endereço de email válido"
                        autofocus required />
                    <label class="form-label" for="email">Email</label>
                </div>

                <div class="form-outline mb-4">
                    <input type="password" id="senha" name="senha" class="form-control" required />
                    <label class="form-label" for="senha">Senha</label>
                </div>

                <div class="form-check mb-4">
                    <input class="form-check-input" type="checkbox" id="mostrarSenha" />
                    <label class="form-check-label" for="mostrarSenha">Mostrar senha</label>
                </div>

                <button type="submit" class="btn btn-primary mb-4">Entrar</button>
            </form>
            <a href="cadastro.jsp" class="auth-link" id="goToRegister">Não tem conta? Cadastre-se</a>
        </div>
    </section>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <!-- MDB JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
        if (erroLogin != null) {
            erroLogin = erroLogin.replace("'", "\\'").replace("\"", "\\\"");
            erroLogin = erroLogin.replace("\n", "\\n").replace("\r", "\\r"); // Evita quebras de linha problemáticas
    %>
            <script>alertResult('error', '<%= erroLogin %>');</script>
    <%
        }
    %>
</body>

</html>