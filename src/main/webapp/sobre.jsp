<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    String avatarUrl = (usuario != null && usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");

    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "JoyStream - Sobre Nós | Nossa História e Missão");
    request.setAttribute("pageDescription", "Conheça a JoyStream, nossa missão de conectar gamers e criar a melhor plataforma de recomendação de jogos. Descubra nossa história e valores.");
    request.setAttribute("pageKeywords", "sobre joystream, história, missão, valores, plataforma de jogos, comunidade gamer, quem somos");
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

        .about-content {
            max-width: 1200px;
            margin: 40px auto;
            padding: 40px;
            background-color: #1f1f1f;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
        }

        .about-content h1 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 50px;
            font-size: 2.5em;
            position: relative;
            padding-bottom: 20px;
        }

        .about-content h1::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(90deg, transparent, #f1c40f, transparent);
            border-radius: 2px;
        }

        .about-content p {
            line-height: 1.8;
            margin-bottom: 25px;
            text-align: justify;
            font-size: 1.1em;
            color: #e0e0e0;
            padding: 0 20px;
        }

        .team-section {
            margin-top: 60px;
            background-color: #2a2a2a;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .team-section h2 {
            color: #f1c40f;
            text-align: center;
            margin-bottom: 40px;
            font-size: 2em;
            position: relative;
            padding-bottom: 15px;
        }

        .team-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: #f1c40f;
            border-radius: 2px;
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 30px;
            padding: 20px;
        }

        .team-member {
            background: linear-gradient(145deg, #262626, #1a1a1a);
            padding: 30px 20px;
            border-radius: 15px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(241, 196, 15, 0.1);
        }

        .team-member::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 200%;
            height: 400%;
            background: linear-gradient(
                90deg,
                transparent,
                rgba(241, 196, 15, 0.1),
                transparent
            );
            transform: rotate(225deg);
            transition: 0.8s;
        }

        .team-member:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(241, 196, 15, 0.1);
        }

        .team-member:hover::before {
            left: 100%;
        }

        .team-member h3 {
            color: #f1c40f;
            margin: 15px 0;
            font-size: 1.3em;
            font-weight: 600;
        }

        .team-member p {
            color: #bbb;
            font-size: 1em;
            margin: 10px 0;
            text-align: center;
        }

        .team-member .role-badge {
            background: rgba(241, 196, 15, 0.1);
            color: #f1c40f;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            display: inline-block;
            margin-top: 10px;
        }

        @media (max-width: 768px) {
            .about-content {
                margin: 20px;
                padding: 20px;
            }

            .team-grid {
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                padding: 10px;
            }

            .about-content h1 {
                font-size: 2em;
            }

            .about-content p {
                font-size: 1em;
                padding: 0;
            }

            .team-section {
                padding: 20px;
            }
        }

        @media (max-width: 480px) {
            .about-content {
                margin: 10px;
                padding: 15px;
            }

            .team-grid {
                grid-template-columns: 1fr;
            }

            .team-member {
                padding: 20px 15px;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="components/header.jsp" />

    <main>
    <div class="about-content">
        <h1>Sobre o JoyStream</h1>
        <p>O JoyStream é uma plataforma desenvolvida como projeto acadêmico para a Univinte Fucap, com o objetivo de criar um espaço onde os amantes de jogos possam descobrir, recomendar e compartilhar suas experiências com diferentes títulos.</p>
        
        <p>Nossa plataforma oferece uma interface intuitiva e moderna, permitindo que os usuários explorem uma vasta biblioteca de jogos, filtrem por diferentes categorias e compartilhem suas opiniões com a comunidade.</p>

        <div class="team-section">
            <h2>Nossa Equipe</h2>
            <div class="team-grid">
                <div class="team-member">
                    <h3>Manoel</h3>
                    <span class="role-badge">Desenvolvedor</span>
                </div>
                <div class="team-member">
                    <h3>Patrick</h3>
                    <span class="role-badge">Desenvolvedor</span>
                </div>
                <div class="team-member">
                    <h3>Vitória</h3>
                    <span class="role-badge">Analista e QA</span>
                </div>
                <div class="team-member">
                    <h3>Felipe</h3>
                    <span class="role-badge">Líder do Projeto</span>
                </div>
                <div class="team-member">
                    <h3>Ana Carolina</h3>
                    <span class="role-badge">Banco de Dados</span>
                </div>
                <div class="team-member">
                    <h3>Ewellim</h3>
                    <span class="role-badge">Banco de Dados</span>
                </div>
            </div>
        </div>
    </div>
</main>

    <jsp:include page="components/footer.jsp" />
</body>
</html> 