<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">

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

        <div class="auth-card" id="registrationForm">
            <h2>Cadastro</h2>
            <% if (request.getAttribute("erroCadastro") !=null) { %>
                <p style="color: red;">
                    <%= request.getAttribute("erroCadastro") %>
                </p>
                <% } %>
                    <form id="formCadastro" action="CadastroServlet" method="post" accept-charset="UTF-8" onsubmit="return validarCadastro();">
                        <div class="form-outline mb-4">
                            <input type="text" id="nome" name="nome" class="form-control" autocomplete="name" autofocus
                                required />
                            <label class="form-label" for="nome">Nome</label>
                        </div>

                        <div class="form-outline mb-4">
                            <input type="text" id="email" name="email" class="form-control" autocomplete="email"
                                pattern="[a-zA-Z0-9._%+-áàâãéèêíïóôõöúüçÁÀÂÃÉÈÊÍÏÓÔÕÖÚÜÇ]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
                                title="Por favor, insira um endereço de email válido"
                                required />
                            <label class="form-label" for="email">Email</label>
                        </div>

                        <div class="form-outline mb-4">
                            <input type="password" id="senha" name="senha" class="form-control"
                                autocomplete="new-password" required />
                            <label class="form-label" for="senha">Senha</label>
                        </div>

                        <div class="form-outline mb-4">
                            <input type="password" id="confirmarSenha" class="form-control" autocomplete="off"
                                required />
                            <label class="form-label" for="confirmarSenha">Confirmar Senha</label>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="mostrarSenha" />
                            <label class="form-check-label" for="mostrarSenha">Mostrar senha</label>
                        </div>

                        <button type="submit" class="btn btn-primary mb-4">Cadastrar</button>
                    </form>
                    <a href="login.jsp" class="auth-link" id="goToLogin">Já tem conta? Faça login</a>
        </div>
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
        document.getElementById("formCadastro").addEventListener("submit", function (event) {
            const senha = document.getElementById("senha").value;
            const confirmarSenha = document.getElementById("confirmarSenha").value;

            if (senha !== confirmarSenha) {
                event.preventDefault();
                // alert("As senhas não coincidem!");
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
                alert(erro);
                return false;
            }
            return true;
        }
    </script>
</body>

</html>