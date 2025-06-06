<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    String avatarUrl = (usuario != null && usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");

    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "Suporte | Central de Ajuda - JoyStream");
    request.setAttribute("pageDescription", "Precisa de ajuda? Acesse nossa central de suporte para encontrar respostas para suas dúvidas, tutoriais e entre em contato com nossa equipe.");
    request.setAttribute("pageKeywords", "suporte joystream, ajuda, faq, contato, tutoriais, dúvidas frequentes, atendimento");
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
            background: linear-gradient(145deg, #1f1f1f, #242424);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }

        .contact-form:hover {
            /* transform: translateY(-5px); */
        }

        .contact-form h2 {
            color: #f1c40f;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 10px;
        }

        .contact-form h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: #f1c40f;
            border-radius: 2px;
        }

        .form-control {
            background-color: #2a2a2a;
            border: 2px solid #3a3a3a;
            color: white;
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: #2a2a2a;
            border-color: #f1c40f;
            color: white;
            box-shadow: 0 0 0 0.25rem rgba(241, 196, 15, 0.15);
            transform: translateY(-2px);
        }

        .form-label {
            color: #ddd;
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
        }

        .btn-primary {
            background-color: #f1c40f;
            border: none;
            color: #000;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary:hover {
            background-color: #f39c12;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(243, 156, 18, 0.3);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .help-section {
            background: linear-gradient(145deg, #1f1f1f, #242424);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        .help-section h2 {
            color: #f1c40f;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 10px;
        }

        .help-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: #f1c40f;
            border-radius: 2px;
        }

        .faq-item {
            margin-bottom: 25px;
            padding: 15px;
            border-radius: 10px;
            background: rgba(42, 42, 42, 0.3);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .faq-item:hover {
            background: rgba(42, 42, 42, 0.6);
            transform: translateX(5px);
        }

        .faq-question {
            color: #f1c40f;
            font-weight: bold;
            margin-bottom: 12px;
            font-size: 1.1em;
        }

        .faq-answer {
            color: #ddd;
            line-height: 1.7;
            font-size: 0.95em;
        }

        .contact-info {
            margin-top: 35px;
            padding-top: 25px;
            border-top: 1px solid rgba(241, 196, 15, 0.1);
        }

        .contact-info h3 {
            color: #f1c40f;
            margin-bottom: 15px;
            font-size: 1.2em;
        }

        .contact-info p {
            margin: 12px 0;
            color: #ddd;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        @media (max-width: 768px) {
            .support-content {
                grid-template-columns: 1fr;
                gap: 30px;
                margin: 20px auto;
                padding: 15px;
            }

            .contact-form, .help-section {
                padding: 20px;
            }

            .form-control {
                padding: 10px;
                margin-bottom: 15px;
            }

            .btn-primary {
                width: 100%;
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

    <jsp:include page="components/header.jsp" />

    <main>
    <div class="support-content">
        <div class="contact-form">
            <h2>Entre em Contato</h2>
            <form id="formSuporte">
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
                <div class="faq-question">Como posso adicionar jogos aos meus favoritos?</div>
                <div class="faq-answer">
                    Navegue até a página de jogos, encontre o jogo desejado e clique no ícone de coração para adicionar aos seus favoritos.
                </div>
            </div>

            <div class="contact-info">
                <h3>Outras formas de contato</h3>
                <p>E-mail: suporte@joystream.com</p>
                <p>Horário de atendimento: Segunda a Sexta, 9h às 18h</p>
            </div>
        </div>
    </div>
</main>

    <jsp:include page="components/footer.jsp" />

    <script src="assets/js/alert.js"></script>

    <script>
        document.getElementById('formSuporte').addEventListener('submit', function(e) {
            e.preventDefault();
            // Simular envio bem-sucedido
            showSuccess('Sucesso', 'Mensagem enviada com sucesso! Entraremos em contato em breve.');
            this.reset();
        });
    </script>
</body>
</html> 