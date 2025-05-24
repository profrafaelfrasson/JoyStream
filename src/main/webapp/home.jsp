<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page import="com.joystream.model.Jogo" %>
<%@ page import="java.util.List" %>
<%@ page import="com.joystream.service.JogoService" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    String avatarUrl = (usuario != null && usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");
    
    // Buscar jogos em destaque
    JogoService jogoService = new JogoService();
    List<Jogo> jogosDestaque = jogoService.buscarJogosDestaque();
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JoyStream - Recomende e descubra jogos</title>
    <link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">
    <style>
        html, body {
            overflow-x: hidden !important;
            width: 100vw;
            max-width: 100vw;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: #262626;
            color: white;
        }

        header {
            background-color: #1f1f1f;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 30px;
            position: relative;
            z-index: 10;
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
            background-color: #2a2a2a !important;
            min-width: 100px;
            box-shadow: 0px 8px 16px rgba(0,0,0,0.3);
            z-index: 1000;
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

        .hero {
            text-align: center;
            padding: 80px 20px;
            background: linear-gradient(to right, #0f2027, #203a43, #2c5364);
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            opacity: 0.2;
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero h1 {
            font-size: 3em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            color: #f1c40f;
        }

        .hero p {
            font-size: 1.2em;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }

        .games {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 40px;
        }

        .game-card {
            background-color: #1e1e1e;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .game-card:hover {
            transform: scale(1.03);
            box-shadow: 0 4px 15px rgba(0,0,0,0.4);
        }

        .game-card img {
            width: 100%;
            aspect-ratio: 16 / 9;
            object-fit: cover;
            border-radius: 5px;
        }

        .game-card h3 {
            margin: 10px 0 5px;
        }

        .footer {
            background-color: #1f1f1f;
            text-align: center;
            padding: 20px;
            color: #777;
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

        .featured-games {
            padding: 40px;
            background-color: #1a1a1a;
        }

        .featured-games h2 {
            color: #f1c40f;
            font-size: 2em;
            margin-bottom: 30px;
            text-align: center;
        }

        .featured-games-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .featured-game-card {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            transition: transform 0.3s ease;
        }

        .featured-game-card:hover {
            transform: translateY(-5px);
        }

        .featured-game-image {
            position: relative;
            width: 100%;
            height: 400px;
        }

        .featured-game-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .featured-game-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.9), rgba(0,0,0,0.4));
            padding: 20px;
            color: white;
        }

        .featured-tag {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #f1c40f;
            color: #000;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.9em;
        }

        .featured-game-info h3 {
            margin: 0 0 10px 0;
            font-size: 1.5em;
            color: #f1c40f;
        }

        .featured-game-info p {
            margin: 0 0 15px 0;
            font-size: 1em;
            opacity: 0.9;
        }

        .featured-button {
            background-color: #f1c40f;
            color: #000;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .featured-button:hover {
            background-color: #f39c12;
        }

        .featured-carousel-section {
            background: transparent;
            padding: 32px 0;
            width: 100%;
            margin: 10px 0 32px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-x: hidden;
        }
        .carousel-title {
            color: #fff;
            font-size: 2.1em;
            font-weight: bold;
            text-shadow: 2px 2px 8px #000, 0 1px 0 #222;
            letter-spacing: 1px;
            margin: 32px 0 24px 0;
            text-align: left;
            width: 100%;
            max-width: 1100px;
            padding-left: 24px;
        }
        .featured-carousel-container {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
        }
        .featured-carousel {
            position: relative;
            display: flex;
            flex-direction: row;
            align-items: stretch;
            background: #222222;
            border-radius: 18px;
            overflow: hidden;
            min-height: 340px;
            width: 100%;
            margin: 0 auto 32px auto;
            box-shadow: 0 0 32px 16px rgba(0,0,0,0.22);
        }
        .carousel-slide {
            width: 100%;
            display: flex;
            flex-direction: row;
            align-items: stretch;
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            pointer-events: none;
            z-index: 1;
            transition: opacity 0.5s cubic-bezier(.4,0,.2,1);
            height: 100%;
        }
        .carousel-slide.active {
            opacity: 1;
            pointer-events: auto;
            z-index: 2;
            position: relative;
        }
        .carousel-main {
            flex: 2.2;
            display: flex;
            align-items: center;
            justify-content: center;
            background: none;
            height: 100%;
        }
        .carousel-banner {
            width: 100%;
            height: 100%;
            object-fit: cover;
            max-height: 340px;
            border-radius: 18px;
            box-shadow: none;
        }
        .carousel-info {
            flex: 1;
            padding: 32px 24px 24px 24px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            background: #222222;
            height: 100%;
            min-width: 260px;
            border-radius: 0 18px 18px 0;
        }
        .carousel-info h2 {
            color: #fff !important;
            font-size: 1.5em;
            margin-bottom: 10px;
            font-weight: bold;
            text-shadow: 1px 1px 4px #000a;
        }
        .carousel-thumbnails {
            display: flex;
            gap: 6px;
            margin: 12px 0;
        }
        .carousel-thumbnails img {
            width: 48px;
            height: 32px;
            object-fit: cover;
            border-radius: 4px;
            border: 2px solid #222;
        }
        .carousel-tags .tag {
            background: #3a4b5c;
            color: #fff;
            border-radius: 3px;
            padding: 2px 8px;
            margin-right: 4px;
            font-size: 0.9em;
        }
        .carousel-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0,0,0,0.7);
            border: none;
            color: #fff;
            font-size: 2.5em;
            padding: 0 16px;
            cursor: pointer;
            z-index: 30;
            height: 56px;
            width: 56px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            opacity: 1;
            transition: opacity 0.2s;
        }
        .carousel-arrow.left { left: 0; }
        .carousel-arrow.right { right: 0; }
        @media (min-width: 1200px) {
            .carousel-arrow.left { left: -72px; }
            .carousel-arrow.right { right: -72px; }
        }
        @media (max-width: 1200px) {
            .featured-carousel-container { max-width: 98vw; }
            .carousel-title { padding-left: 8px; }
        }
        @media (max-width: 700px) {
            .featured-carousel, .carousel-banner {
                min-height: 180px;
                max-height: 180px;
            }
            .carousel-info {
                padding: 10px 6px;
                min-width: 120px;
            }
            .carousel-thumbnails img {
                width: 32px;
                height: 20px;
            }
            .carousel-title { font-size: 1.2em; }
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
            <% if (logado) { %>
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
            <% } else { %>
                <a href="login.jsp">Login</a>
                <a href="cadastro.jsp">Registrar</a>
            <% } %>
        </nav>
    </header>

    <div class="hero">
        <div class="hero-content">
            <h1>Bem-vindo ao JoyStream</h1>
            <p>Descubra, recomende e compartilhe seus jogos favoritos</p>
        </div>
    </div>

    <section class="featured-carousel-section">
        <div class="carousel-title">Destaques e Recomendados</div>
        <div class="featured-carousel-container">
            <button class="carousel-arrow left" onclick="carouselPrev()">&lt;</button>
            <div id="featured-carousel" class="featured-carousel">
                <% for (int i = 0; i < jogosDestaque.size(); i++) {
                    com.joystream.model.Jogo jogo = jogosDestaque.get(i);
                    java.util.List<String> screenshots = jogo.getScreenshots();
                %>
                <div class="carousel-slide<%= (i == 0) ? " active" : "" %>">
                    <div class="carousel-main">
                        <a href="jogos.jsp?id=<%= jogo.getId() %>">
                            <img src="<%= jogo.getImagemUrl() %>" alt="<%= jogo.getNome() %>" class="carousel-banner">
                        </a>
                    </div>
                    <div class="carousel-info">
                        <h2><%= jogo.getNome() %></h2>
                        <div class="carousel-thumbnails">
                            <% if (screenshots != null && !screenshots.isEmpty()) {
                                for (String shot : screenshots) { %>
                                    <img src="<%= shot %>" alt="Screenshot">
                            <%  } } %>
                        </div>
                        <div class="carousel-tags">
                            <span class="tag">Popular</span>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <button class="carousel-arrow right" onclick="carouselNext()">&gt;</button>
        </div>
    </section>

    <section class="games">
        <div class="game-card">
            <img src="<%= request.getContextPath() %>/assets/img/game1.jpg" alt="Assassin's Creed">
            <h3>Assassin's Creed</h3>
            <p>Uma aventura histórica com parkour e combate furtivo.</p>
        </div>
        <div class="game-card">
            <img src="<%= request.getContextPath() %>/assets/img/game2.jpg" alt="League of Legends">
            <h3>League of Legends</h3>
            <p>O maior MOBA competitivo do mundo.</p>
        </div>
        <div class="game-card">
            <img src="<%= request.getContextPath() %>/assets/img/game3.jpg" alt="The Sims">
            <h3>The Sims</h3>
            <p>O clássico simulador de vida virtual.</p>
        </div>
    </section>

    <footer class="footer">
        &copy; 2025 JoyStream. Todos os direitos reservados.
    </footer>

    <script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-slide');
    let autoInterval = null;

    function showSlide(index) {
        slides.forEach((slide, i) => {
            slide.classList.toggle('active', i === index);
        });
    }

    function carouselPrev() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        showSlide(currentSlide);
        resetAuto();
    }

    function carouselNext() {
        currentSlide = (currentSlide + 1) % slides.length;
        showSlide(currentSlide);
        resetAuto();
    }

    function autoCarousel() {
        autoInterval = setInterval(() => {
            carouselNext();
        }, 5000);
    }

    function resetAuto() {
        clearInterval(autoInterval);
        autoCarousel();
    }

    document.addEventListener('DOMContentLoaded', function() {
        showSlide(currentSlide);
        autoCarousel();
    });
    </script>
</body>
</html>
