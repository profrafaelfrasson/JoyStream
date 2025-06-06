<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <%
        request.setAttribute("pageTitle", "Termos de Uso | JoyStream");
        request.setAttribute("pageDescription", "Leia os termos de uso da JoyStream.");
        request.setAttribute("pageKeywords", "termos de uso, termos e condições, regras, joystream");
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

        .terms-container {
            background-color: #1f1f1f;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .terms-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .terms-title {
            color: #f1c40f;
            font-size: 2em;
            margin-bottom: 10px;
        }

        .terms-subtitle {
            color: #aaa;
            font-size: 1.1em;
        }

        .terms-section {
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

        @media (max-width: 768px) {
            .terms-container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="components/header.jsp" %>

    <div class="main-content">
        <div class="terms-container">
            <div class="terms-header">
                <h1 class="terms-title">Termos de Uso</h1>
                <p class="terms-subtitle">
                    Por favor, leia atentamente estes termos antes de usar nossos serviços
                </p>
            </div>

            <div class="terms-section">
                <h2 class="section-title">1. Aceitação dos Termos</h2>
                <div class="section-content">
                    <p>
                        Ao acessar e utilizar a JoyStream, você concorda com estes termos de uso
                        e todas as leis e regulamentos aplicáveis. Se você não concordar com algum
                        destes termos, está proibido de usar ou acessar este site.
                    </p>
                    <p>
                        Os materiais contidos neste site são protegidos pelas leis de direitos
                        autorais e marcas comerciais aplicáveis.
                    </p>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">2. Uso da Licença</h2>
                <div class="section-content">
                    <p>
                        É concedida permissão para baixar temporariamente uma cópia dos materiais
                        (informações ou software) no site JoyStream, apenas para visualização
                        transitória pessoal e não comercial. Esta é a concessão de uma licença,
                        não uma transferência de título, e sob esta licença você não pode:
                    </p>
                    <ul>
                        <li>modificar ou copiar os materiais;</li>
                        <li>usar os materiais para qualquer finalidade comercial;</li>
                        <li>tentar descompilar ou fazer engenharia reversa de qualquer software contido no site;</li>
                        <li>remover quaisquer direitos autorais ou outras notações de propriedade dos materiais;</li>
                        <li>transferir os materiais para outra pessoa ou 'espelhar' os materiais em qualquer outro servidor.</li>
                    </ul>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">3. Conta do Usuário</h2>
                <div class="section-content">
                    <p>
                        Para acessar determinados recursos do site, você precisará criar uma conta.
                        Você é responsável por manter a confidencialidade de sua conta e senha e
                        por restringir o acesso ao seu computador.
                    </p>
                    <p>
                        Você concorda em aceitar responsabilidade por todas as atividades que
                        ocorrem em sua conta. A JoyStream reserva-se o direito de recusar
                        serviço, encerrar contas, remover ou editar conteúdo a seu critério
                        exclusivo.
                    </p>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">4. Conteúdo do Usuário</h2>
                <div class="section-content">
                    <p>
                        Ao enviar avaliações, comentários ou qualquer outro conteúdo para o site,
                        você concede à JoyStream uma licença mundial, não exclusiva, livre de
                        royalties, perpétua e irrevogável para usar, reproduzir, modificar,
                        adaptar, publicar, traduzir, criar trabalhos derivados, distribuir e
                        exibir tal conteúdo.
                    </p>
                    <p>
                        Você concorda que este conteúdo não deve:
                    </p>
                    <ul>
                        <li>conter material ilegal, abusivo, vulgar, odioso, pornográfico;</li>
                        <li>violar direitos de terceiros;</li>
                        <li>conter ameaças ou promover violência;</li>
                        <li>violar a privacidade de terceiros;</li>
                        <li>conter spam, mensagens em cadeia ou esquemas de pirâmide.</li>
                    </ul>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">5. Limitação de Responsabilidade</h2>
                <div class="section-content">
                    <p>
                        Em nenhum caso a JoyStream ou seus fornecedores serão responsáveis por
                        quaisquer danos (incluindo, sem limitação, danos por perda de dados ou
                        lucro, ou devido a interrupção dos negócios) decorrentes do uso ou da
                        incapacidade de usar os materiais em nosso site.
                    </p>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">6. Precisão dos Materiais</h2>
                <div class="section-content">
                    <p>
                        Os materiais exibidos no site da JoyStream podem incluir erros técnicos,
                        tipográficos ou fotográficos. A JoyStream não garante que qualquer
                        material em seu site seja preciso, completo ou atual. A JoyStream pode
                        fazer alterações nos materiais contidos em seu site a qualquer momento,
                        sem aviso prévio.
                    </p>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">7. Links</h2>
                <div class="section-content">
                    <p>
                        A JoyStream não analisou todos os sites vinculados ao seu site e não é
                        responsável pelo conteúdo de nenhum site vinculado. A inclusão de
                        qualquer link não implica endosso por parte da JoyStream do site. O uso
                        de qualquer site vinculado é por conta e risco do usuário.
                    </p>
                </div>
            </div>

            <div class="terms-section">
                <h2 class="section-title">8. Modificações</h2>
                <div class="section-content">
                    <p>
                        A JoyStream pode revisar estes termos de serviço do site a qualquer
                        momento, sem aviso prévio. Ao usar este site, você concorda em ficar
                        vinculado à versão atual desses termos de serviço.
                    </p>
                </div>
            </div>

            <p class="last-updated">Última atualização: Maio de 2024</p>
        </div>
    </div>

    <%@ include file="components/footer.jsp" %>
</body>
</html> 