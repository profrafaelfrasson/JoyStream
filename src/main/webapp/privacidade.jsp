<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>



<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <%
        request.setAttribute("pageTitle", "Política de Privacidade | JoyStream");
        request.setAttribute("pageDescription", "Saiba como coletamos e protegemos suas informações pessoais na JoyStream.");
        request.setAttribute("pageKeywords", "política de privacidade, privacidade, dados pessoais, joystream");
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
            padding: 40px 20px;
            max-width: 800px;
            margin: 0 auto;
        }

        .privacy-container {
            background-color: #1f1f1f;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .privacy-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .privacy-title {
            color: #f1c40f;
            font-size: 2em;
            margin-bottom: 10px;
        }

        .privacy-subtitle {
            color: #aaa;
            font-size: 1.1em;
        }

        .privacy-section {
            margin-bottom: 30px;
        }

        .section-title {
            color: #f1c40f;
            font-size: 1.5em;
            margin-bottom: 15px;
        }

        .section-content {
            color: #aaa;
            line-height: 1.6;
        }

        .section-content p {
            margin-bottom: 15px;
        }

        .section-content ul {
            list-style-type: disc;
            margin-left: 20px;
            margin-bottom: 15px;
        }

        .section-content li {
            margin-bottom: 8px;
        }

        .section-content strong {
            color: white;
        }

        .section-content a {
            color: #f1c40f;
            text-decoration: none;
            transition: color 0.3s;
        }

        .section-content a:hover {
            color: #f39c12;
        }

        .last-updated {
            text-align: center;
            color: #aaa;
            font-size: 0.9em;
            margin-top: 40px;
        }

        .contact-info {
            background-color: #2a2a2a;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }

        .contact-info p {
            margin: 5px 0;
        }

        @media (max-width: 768px) {
            .privacy-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="components/header.jsp" %>

    <div class="main-content">
        <div class="privacy-container">
            <div class="privacy-header">
                <h1 class="privacy-title">Política de Privacidade</h1>
                <p class="privacy-subtitle">
                    Saiba como coletamos, usamos e protegemos suas informações pessoais
                </p>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">1. Informações que Coletamos</h2>
                <div class="section-content">
                    <p>
                        Coletamos informações que você nos fornece diretamente ao criar uma conta
                        ou interagir com nossos serviços. Isso inclui:
                    </p>
                    <ul>
                        <li>Nome e endereço de e-mail</li>
                        <li>Informações de perfil, como avatar e preferências</li>
                        <li>Jogos favoritos e avaliações</li>
                        <li>Comentários e interações na plataforma</li>
                        <li>Dados de uso e navegação no site</li>
                    </ul>
                </div>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">2. Como Usamos suas Informações</h2>
                <div class="section-content">
                    <p>
                        Utilizamos as informações coletadas para:
                    </p>
                    <ul>
                        <li>Fornecer, manter e melhorar nossos serviços</li>
                        <li>Personalizar sua experiência na plataforma</li>
                        <li>Processar suas transações</li>
                        <li>Enviar comunicações administrativas</li>
                        <li>Detectar e prevenir atividades fraudulentas</li>
                        <li>Analisar o uso da plataforma e melhorar nossos serviços</li>
                    </ul>
                </div>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">3. Compartilhamento de Informações</h2>
                <div class="section-content">
                    <p>
                        Não vendemos, alugamos ou compartilhamos suas informações pessoais com
                        terceiros, exceto nas seguintes circunstâncias:
                    </p>
                    <ul>
                        <li>Com seu consentimento explícito</li>
                        <li>Para cumprir obrigações legais</li>
                        <li>Para proteger nossos direitos e propriedade</li>
                        <li>Em caso de fusão, venda ou transferência de ativos</li>
                    </ul>
                </div>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">4. Proteção de Dados</h2>
                <div class="section-content">
                    <p>
                        Implementamos medidas de segurança técnicas e organizacionais apropriadas
                        para proteger suas informações pessoais contra acesso não autorizado,
                        alteração, divulgação ou destruição. Estas medidas incluem:
                    </p>
                    <ul>
                        <li>Criptografia de dados sensíveis</li>
                        <li>Firewalls e sistemas de segurança</li>
                        <li>Acesso restrito a informações pessoais</li>
                        <li>Monitoramento regular de nossos sistemas</li>
                    </ul>
                </div>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">5. Seus Direitos</h2>
                <div class="section-content">
                    <p>
                        Você tem os seguintes direitos em relação às suas informações pessoais:
                    </p>
                    <ul>
                        <li>Acessar suas informações pessoais</li>
                        <li>Corrigir dados imprecisos</li>
                        <li>Solicitar a exclusão de seus dados</li>
                        <li>Retirar seu consentimento a qualquer momento</li>
                        <li>Receber seus dados em formato estruturado</li>
                        <li>Opor-se ao processamento de seus dados</li>
                    </ul>
                </div>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">6. Cookies e Tecnologias Similares</h2>
                <div class="section-content">
                    <p>
                        Utilizamos cookies e tecnologias similares para melhorar sua experiência
                        de navegação, entender como você usa nosso site e personalizar nosso
                        conteúdo. Você pode controlar o uso de cookies através das configurações
                        do seu navegador.
                    </p>
                    <p>
                        Os tipos de cookies que utilizamos incluem:
                    </p>
                    <ul>
                        <li>Cookies essenciais para o funcionamento do site</li>
                        <li>Cookies de desempenho e análise</li>
                        <li>Cookies de funcionalidade</li>
                        <li>Cookies de publicidade e direcionamento</li>
                    </ul>
                </div>
            </div>

            <div class="privacy-section">
                <h2 class="section-title">7. Contato</h2>
                <div class="section-content">
                    <p>
                        Se você tiver dúvidas sobre esta política de privacidade ou sobre como
                        tratamos suas informações pessoais, entre em contato conosco:
                    </p>
                    <div class="contact-info">
                        <p><strong>E-mail:</strong> privacidade@joystream.com</p>
                        <p><strong>Telefone:</strong> (48) 91234-5678</p>
                        <p><strong>Endereço:</strong> Av. Ernani Cotrin, 1000 - Capivari de Baixo, SC</p>
                    </div>
                </div>
            </div>

            <p class="last-updated">Última atualização: Maio de 2025</p>
        </div>
    </div>

    <%@ include file="components/footer.jsp" %>
</body>
</html> 