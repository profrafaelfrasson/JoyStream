<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String avatarUrl = (usuario.getAvatar() != null && !usuario.getAvatar().isEmpty())
        ? ("data:image/png;base64," + usuario.getAvatar())
        : (request.getContextPath() + "/assets/img/default-avatar.png");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - JoyStream</title>
    <link rel="icon" type="image/x-icon" href="assets/img/img/logo.ico">
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }

        .profile-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }

        .profile-card {
            background-color: #1f1f1f;
            border-radius: 10px;
            padding: 30px;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #f1c40f;
        }

        .profile-info {
            flex: 1;
        }

        .profile-info h2 {
            color: #f1c40f;
            margin: 0 0 10px 0;
        }

        .profile-info p {
            color: #ddd;
            margin: 5px 0;
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

        .btn-outline {
            background-color: transparent;
            border: 1px solid #f1c40f;
            color: #f1c40f;
        }

        .btn-outline:hover {
            background-color: #f1c40f;
            color: #000;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
            margin-top: 40px;
        }

        .avatar-upload {
            position: relative;
            display: inline-block;
        }

        .avatar-upload input[type="file"] {
            display: none;
        }

        .avatar-upload label {
            position: absolute;
            bottom: 0;
            right: 0;
            background-color: #f1c40f;
            color: #000;
            padding: 8px;
            border-radius: 50%;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .avatar-upload label:hover {
            background-color: #f39c12;
        }

        @media (max-width: 700px) {
            .profile-container {
                padding: 5px;
            }
            .profile-card {
                padding: 10px;
            }
            .profile-header {
                flex-direction: column;
                align-items: center;
                gap: 15px;
            }
            .profile-avatar {
                width: 100px;
                height: 100px;
            }
            .profile-info h2 {
                font-size: 1.2em;
            }
            .profile-info p {
                font-size: 0.95em;
            }
            .mb-3, .form-control, .form-label {
                width: 100%;
                font-size: 1em;
            }
            .btn-primary {
                width: 100%;
            }
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
        </nav>
    </header>

    <div class="profile-container">
        <div class="profile-card">
            <% String erro = (String) request.getAttribute("erro"); if (erro != null && !erro.trim().isEmpty()) { %>
                <div class="alert alert-danger" style="text-align:center; margin-bottom: 20px;"> <%= erro %> </div>
            <% } %>
            <form id="profileForm" action="atualizar-perfil" method="post" enctype="multipart/form-data" onsubmit="return validarPerfil();">
                <div class="profile-header">
                    <div class="avatar-upload">
                        <img src="<%= avatarUrl %>" alt="Avatar" class="profile-avatar">
                        <label for="avatar-input">
                            <i class="fas fa-camera"></i>
                        </label>
                        <input type="file" id="avatar-input" name="avatar" accept="image/*" style="display: none;">
                    </div>
                    <div class="profile-info">
                        <h2><%= usuario.getNome() %></h2>
                        <p><%= usuario.getEmail() %></p>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome de Usuário</label>
                    <input type="text" class="form-control" id="nome" name="nome" value="<%= usuario.getNome() %>" required>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">E-mail</label>
                    <input type="email" class="form-control" id="email" value="<%= usuario.getEmail() %>" disabled>
                </div>
                <div class="mb-3">
                    <label for="senhaAtual" class="form-label">Senha Atual</label>
                    <input type="password" class="form-control" id="senhaAtual" name="senhaAtual" autocomplete="current-password">
                    <small class="text-muted">Obrigatório para alterar a senha</small>
                </div>
                <div class="mb-3">
                    <label for="senha" class="form-label">Nova Senha</label>
                    <input type="password" class="form-control" id="senha" name="senha">
                    <small class="text-muted">Deixe em branco para manter a senha atual</small>
                </div>
                <div class="mb-3">
                    <label for="confirmarSenha" class="form-label">Confirmar Nova Senha</label>
                    <input type="password" class="form-control" id="confirmarSenha" name="confirmarSenha">
                </div>
                <button type="submit" class="btn btn-primary">Salvar Alterações</button>
            </form>
        </div>
    </div>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.js"></script>
    <script src="https://kit.fontawesome.com/your-font-awesome-kit.js"></script>
    <script>
        // Preview da imagem do avatar
        document.getElementById('avatar-input').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // Validação de tamanho (máx 2MB) e formato
                if (file.size > 2 * 1024 * 1024) {
                    alert('O avatar deve ter no máximo 2MB.');
                    e.target.value = '';
                    return;
                }
                if (!file.type.startsWith('image/')) {
                    alert('Selecione um arquivo de imagem válido.');
                    e.target.value = '';
                    return;
                }
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.querySelector('.profile-avatar').src = e.target.result;
                    document.querySelector('.user-avatar').src = e.target.result;
                }
                reader.readAsDataURL(file);
            }
        });

        // Validação do formulário
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const senha = document.getElementById('senha').value;
            const confirmarSenha = document.getElementById('confirmarSenha').value;
            const senhaAtual = document.getElementById('senhaAtual').value;

            if (senha && senha !== confirmarSenha) {
                alert('As senhas não coincidem!');
                return;
            }
            if (senha && (!senhaAtual || senhaAtual.trim() === '')) {
                alert('Para alterar a senha, preencha sua senha atual.');
                return;
            }
            this.submit();
        });

        // Exibir mensagens de sucesso/erro
        const urlParams = new URLSearchParams(window.location.search);
        const sucesso = urlParams.get('sucesso');
        const erro = '<%= request.getAttribute("erro") %>';

        if (sucesso === 'true') {
            alert('Perfil atualizado com sucesso!');
        } else if (erro && erro !== 'null' && erro.trim() !== '') {
            alert(erro);
        }

        function validarPerfil() {
            var nome = document.getElementById('nome').value.trim();
            var senha = document.getElementById('senha').value;
            var erro = '';
            if (nome.length < 2) {
                erro += 'Nome muito curto.\n';
            }
            if (senha.length > 0 && (senha.length < 6 || !/[a-zA-Z]/.test(senha) || !/\d/.test(senha))) {
                erro += 'A nova senha deve ter pelo menos 6 caracteres, incluindo letras e números.\n';
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