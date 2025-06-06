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

        
    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "Seu Perfil de Jogador | Preferências e Favoritos - JoyStream");
    request.setAttribute("pageDescription", "Gerencie seu perfil na JoyStream, atualize suas preferências, veja seus jogos favoritos e acompanhe suas recomendações personalizadas de jogos.");
    request.setAttribute("pageKeywords", "perfil gamer, jogos favoritos, preferências de jogos, conta jogador, personalização, recomendações personalizadas");
    
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>

    <jsp:include page="components/head.jsp" />

    <meta name="robots" content="noindex">

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #121212;
            color: white;
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
            width: 2rem;
            height: 2rem;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: background-color 0.3s;
        }

        .avatar-upload label:hover {
            background-color: #f39c12;
        }

        .text-muted {
            color: #a3a3a3 !important;
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

    <jsp:include page="components/header.jsp" />

    <main>
    <div class="profile-container">
        <div class="profile-card">
            <% String erro = (String) request.getAttribute("erro"); if (erro != null && !erro.trim().isEmpty()) { %>
                <script>showError('Erro', '<%= erro %>');</script>
            <% } %>
            <form id="profileForm" action="atualizar-perfil" method="post" enctype="multipart/form-data" onsubmit="return validarPerfil();">
                <div class="profile-header">
                    <div class="avatar-upload">
                        <img src="<%= avatarUrl %>" alt="Avatar" draggable="false" class="profile-avatar">
                        <label for="avatar-input">
                            <i class="fas fa-camera"></i>
                        </label>
                        <input type="file" id="avatar-input" name="avatar" accept="image/*" style="display: none;">
                    </div>
                    <div class="profile-info">
                        <h2><%= usuario.getNmUsuario() %></h2>
                        <p><%= usuario.getEmail() %></p>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="nome" class="form-label">Nome de Usuário</label>
                    <input type="text" class="form-control" id="nome" name="nome" value="<%= usuario.getNmUsuario() %>" required>
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
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="mostrarSenhaPerfil">
                    <label class="form-check-label" for="mostrarSenhaPerfil">Mostrar senhas</label>
                </div>
                <button type="submit" class="btn btn-primary">Salvar Alterações</button>
            </form>
        </div>
    </div>
</main>

    <jsp:include page="components/footer.jsp" />

    <script src="assets/js/alert.js"></script>

    <script src="https://kit.fontawesome.com/your-font-awesome-kit.js"></script>
    <script>
        function validarPerfil() {
            var nome = document.getElementById('nome').value.trim();
            var senhaAtual = document.getElementById('senhaAtual').value;
            var novaSenha = document.getElementById('senha').value;
            var confirmarSenha = document.getElementById('confirmarSenha').value;

            if (nome.length < 2) {
                showError('Erro', 'O nome deve ter pelo menos 2 caracteres.');
                return false;
            }

            if (senhaAtual || novaSenha || confirmarSenha) {
                if (!senhaAtual) {
                    showError('Erro', 'A senha atual é obrigatória para alterar a senha.');
                    return false;
                }
                if (novaSenha !== confirmarSenha) {
                    showError('Erro', 'As senhas não coincidem.');
                    return false;
                }
                if (novaSenha.length < 6 || !/[a-zA-Z]/.test(novaSenha) || !/\d/.test(novaSenha)) {
                    showError('Erro', 'A nova senha deve ter pelo menos 6 caracteres, incluindo letras e números.');
                    return false;
                }
            }

            return true;
        }

        document.getElementById("mostrarSenhaPerfil").addEventListener("change", function () {
            const tipo = this.checked ? "text" : "password";
            document.getElementById("senhaAtual").type = tipo;
            document.getElementById("senha").type = tipo;
            document.getElementById("confirmarSenha").type = tipo;
        });

        document.getElementById('avatar-input').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                if (file.size > 5 * 1024 * 1024) { // 5MB
                    showError('Erro', 'O arquivo é muito grande. O tamanho máximo permitido é 5MB.');
                    this.value = '';
                    return;
                }
                if (!file.type.startsWith('image/')) {
                    showError('Erro', 'Por favor, selecione apenas arquivos de imagem.');
                    this.value = '';
                    return;
                }
            }
        });
    </script>
</body>
</html> 