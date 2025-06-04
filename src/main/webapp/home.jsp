<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%@ page import="com.joystream.model.Jogo" %>
<%@ page import="java.util.List" %>
<%@ page import="com.joystream.service.JogoService" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Buscar jogos em destaque
    JogoService jogoService = new JogoService();
    List<Jogo> jogosDestaque = jogoService.buscarJogosDestaque();
    
    // Buscar jogos recomendados se o usuário estiver logado
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    List<Jogo> jogosRecomendados = null;
    if (logado && usuario.getIdUsuario() > 0) {
        System.out.println("Usuário logado com ID: " + usuario.getIdUsuario());
        jogosRecomendados = jogoService.buscarJogosRecomendados(usuario.getIdUsuario());
        System.out.println("Jogos recomendados encontrados: " + (jogosRecomendados != null ? jogosRecomendados.size() : "null"));
    } else {
        System.out.println("Usuário não está logado ou ID inválido");
    }
    
    request.setAttribute("jogosDestaque", jogosDestaque);
    request.setAttribute("jogosRecomendados", jogosRecomendados);
    
    // Se houver jogos em destaque, usar a imagem do primeiro jogo como imagem de compartilhamento
    if (jogosDestaque != null && !jogosDestaque.isEmpty() && jogosDestaque.get(0).getImagemUrl() != null) {
        request.setAttribute("pageImage", jogosDestaque.get(0).getImagemUrl());
    }
    
    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "JoyStream - Sua plataforma de recomendação de jogos");
    request.setAttribute("pageDescription", "Descubra novos jogos, compartilhe suas experiências e encontre recomendações personalizadas baseadas nos seus gostos. A JoyStream é sua comunidade gamer definitiva.");
    request.setAttribute("pageKeywords", "jogos, games, recomendações de jogos, gaming, comunidade gamer, jogos em destaque, jogos recomendados");

    // Unir e randomizar os jogos de destaque e recomendados para o carrossel
    List<Jogo> jogosCarrossel = new ArrayList<>();
    if (jogosDestaque != null) {
        jogosCarrossel.addAll(jogosDestaque.size() > 6 ? jogosDestaque.subList(0, 6) : jogosDestaque);
    }
    if (jogosRecomendados != null) {
        jogosCarrossel.addAll(jogosRecomendados.size() > 6 ? jogosRecomendados.subList(0, 6) : jogosRecomendados);
    }
    java.util.Collections.shuffle(jogosCarrossel);
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <jsp:include page="components/head.jsp" />
    <style>
        /* ===== HERO SECTION ===== */
        .hero {
            text-align: center;
            padding: 80px 20px;
            position: relative;
            height: auto;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            width: 100%;
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
            color: var(--color-primary);
        }

        .hero p {
            font-size: 1.2em;
            color: var(--color-text);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }

        .game-card {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            background: #fff;
            transition: transform 0.3s ease;
            height: auto;
        }

        .game-card:hover {
            transform: translateY(-5px);
        }

        .game-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .game-info {
            padding: 15px;
        }

        .game-title {
            /* font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333; */

            
            color: #fff;
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 8px;
            line-height: 1.2;


            line-height: 1.2;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .game-meta {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 5px;
        }

        .metacritic-score {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
        }

        .score-high {
            background-color: #6c3;
            color: white;
        }

        .score-medium {
            background-color: #fc3;
            color: white;
        }

        .score-low {
            background-color: #f66;
            color: white;
        }

        .section-title {
            color: #f1c40f;
            font-size: 22px;
            font-weight: bold;
            margin: 30px 0 20px;
            padding: 0 15px;
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            left: 15px;
            bottom: -8px;
            width: 60%;
            height: 2px;
            background: #f1c40f;
        }

        .more-info-btn {
            width: 100%;
            padding: 8px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .more-info-btn:hover {
            background-color: #0056b3;
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
            padding: 30px 0;
            background: var(--color-bg-dark);
            margin-bottom: 20px;
        }

        .carousel-container {
            position: relative;
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px 0;
        }

        .featured-carousel {
            position: relative;
            min-height: 400px;
            height: 400px;
            background: none;
            border-radius: 6px;
            overflow: hidden;
            box-shadow: 10px 10px 20px #000000ab;
        }

        .carousel-slide {
            display: none;
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0; left: 0;
        }

        .carousel-slide.active {
            display: flex;
            position: relative;
            opacity: 1;
            z-index: 2;
            width: 100%;
            height: 100%;
        }

        .carousel-main {
            flex: 2;
            height: 100%;
            position: relative;
            display: flex;
            align-items: stretch;
            background: #111;
            overflow: hidden;
        }
        .carousel-main::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            width: 20%;
            background: linear-gradient(to right, rgba(0, 0, 0, 0), black);
        }

        .carousel-banner {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            display: block;
            background: #111;
        }

        .carousel-info {
            flex: 1;
            padding: 25px;
            background: rgba(0, 0, 0, 0.85);
            min-width: 250px;
            max-width: 300px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .carousel-info-top {
            flex-grow: 1;
        }

        .carousel-info-bottom {
            margin-top: 20px;
        }

        .carousel-button {
            background: linear-gradient(45deg, var(--color-primary), #f39c12);
            color: #000;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(241, 196, 15, 0.3);
        }

        .carousel-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(241, 196, 15, 0.4);
            background: linear-gradient(45deg, #f39c12, var(--color-primary));
        }

        .carousel-button:active {
            transform: translateY(0);
            box-shadow: 0 2px 10px rgba(241, 196, 15, 0.3);
        }

        .carousel-button i {
            font-size: 16px;
            transition: transform 0.3s ease;
        }

        .carousel-button:hover i {
            transform: translateX(3px);
        }

        .carousel-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            background: rgba(0, 0, 0, 0.7);
            border: 2px solid rgba(241, 196, 15, 0.5);
            border-radius: 50%;
            color: #f1c40f;
            font-size: 18px;
            cursor: pointer;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(4px);
        }

        .carousel-arrow:hover {
            background: rgba(241, 196, 15, 0.2);
            border-color: #f1c40f;
            transform: translateY(-50%) scale(1.1);
        }

        .carousel-arrow:active {
            transform: translateY(-50%) scale(0.95);
        }

        .carousel-arrow.prev {
            left: 15px;
        }

        .carousel-arrow.next {
            right: 15px;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateX(20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .carousel-info h2,
        .carousel-info .game-meta {
            animation: fadeIn 0.5s ease-out forwards;
        }

        .carousel-info .game-meta:nth-child(2) {
            animation-delay: 0.1s;
        }

        .carousel-info .game-meta:nth-child(3) {
            animation-delay: 0.2s;
        }

        .carousel-thumbnails {
            display: flex;
            gap: 8px;
            margin-top: 15px;
            animation: fadeIn 0.5s ease-out 0.3s forwards;
        }

        .carousel-thumbnails img {
            width: 60px;
            height: 34px;
            object-fit: cover;
            border-radius: 4px;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .carousel-thumbnails img:hover {
            border-color: #f1c40f;
            transform: scale(1.05);
        }

        .games-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            padding: 15px;
        }

        .game-card {
            background: #333;
            border-radius: 6px;
            overflow: hidden;
            transition: transform 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            max-width: 300px;
            margin: 0 auto;
            height: auto;
            box-shadow: 10px 10px 20px #000000ab;
        }

        .game-image-container {
            position: relative;
            width: 100%;
            padding-top: 56.25%; /* 16:9 Aspect Ratio */
            overflow: hidden;
        }

        .game-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .game-info {
            padding: 12px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .game-meta {
            color: #ccc;
            font-size: 12px;
            margin-bottom: 6px;
            display: flex;
            align-items: baseline;
            gap: 5px;
        }

        .game-meta i {
            width: 14px;
        }

        .metacritic-score {
            display: inline-block;
            padding: 3px 6px;
            border-radius: 3px;
            font-weight: bold;
            font-size: 12px;
            margin-top: 8px;
        }

        .score-high { background-color: #6c3; }
        .score-medium { background-color: #fc3; }
        .score-low { background-color: #f66; }

        .more-info-btn {
            background: #f1c40f;
            color: #000;
            border: none;
            padding: 8px;
            border-radius: 4px;
            font-weight: bold;
            margin-top: 10px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        .more-info-btn i {
            font-size: 14px;
        }

        @media (max-width: 768px) {
            .games-grid {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                gap: 10px;
                padding: 10px;
            }

            .game-title {
                font-size: 14px;
            }

            .game-meta {
                font-size: 11px;
            }

            .carousel-button {
                padding: 10px 16px;
                font-size: 13px;
            }

            .carousel-button i {
                font-size: 14px;
            }

            .carousel-info {
                padding: 20px;
            }
        }

        @media (max-width: 480px) {
            .games-grid {
                grid-template-columns: repeat(2, 1fr);
        }

        .carousel-arrow {
                width: 35px;
                height: 35px;
                font-size: 16px;
            }
        }

        /* Estilos atualizados para as seções de jogos */
        .games-section {
            padding: 40px 0;
            background: var(--color-bg-dark);
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
        }

        .games-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 60px;
            position: relative;
        }

        .games-grid {
            display: flex;
            gap: 20px;
            overflow-x: auto;
            scroll-behavior: smooth;
            scrollbar-width: none;
            -ms-overflow-style: none;
            padding: 20px 0;
            scroll-snap-type: x mandatory;
            -webkit-overflow-scrolling: touch;
        }

        .games-grid::-webkit-scrollbar {
            display: none;
        }

        /* Fade effect for grid edges */
        .games-container::before,
        .games-container::after {
            content: '';
            position: absolute;
            top: 0;
            bottom: 0;
            width: 60px;
            pointer-events: none;
            z-index: 2;
            transition: opacity 0.3s ease;
        }

        .games-container::before {
            left: 0;
            background: linear-gradient(to right, var(--color-bg-dark) 0%, rgba(26,26,26,0) 100%);
        }

        .games-container::after {
            right: 0;
            background: linear-gradient(to left, var(--color-bg-dark) 0%, rgba(26,26,26,0) 100%);
        }

        /* ===== GAME CARDS ===== */
        .game-card {
            flex: 0 0 300px;
            scroll-snap-align: center;
            background: var(--color-bg-light);
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            display: flex;
            flex-direction: column;
            min-width: 300px;
            max-width: 300px;
            opacity: 0.6; /* Cards laterais mais escuros */
            transform: scale(0.9); /* Cards laterais menores */
            transition: all 0.3s ease;
        }

        .game-card.active {
            opacity: 1;
            transform: scale(1);
        }

        .game-image-container {
            position: relative;
            width: 100%;
            padding-top: 56.25%;
            overflow: hidden;
        }

        .game-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .game-info {
            padding: 15px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background: linear-gradient(to bottom, rgba(51,51,51,0.9), #333);
        }


        .game-meta {
            color: var(--color-text);
            font-size: 13px;
            margin-bottom: 6px;
            display: flex;
            gap: 6px;
            opacity: 0.9;
        }

        .game-meta i {
            color: var(--color-primary);
            width: 16px;
        }

        .metacritic-score {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 14px;
            margin-top: 8px;
            width: fit-content;
        }

        .more-info-btn {
            width: 100%;
            background: linear-gradient(45deg, #f1c40f, #f39c12);
            color: #000;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-weight: bold;
            margin-top: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 14px;
        }

        .more-info-btn:hover {
            transform: translateY(-2px);
            background: linear-gradient(45deg, #f39c12, #f1c40f);
        }

        .scroll-button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            background: rgba(0, 0, 0, 0.8);
            border: 2px solid rgba(241, 196, 15, 0.5);
            border-radius: 50%;
            color: #f1c40f;
            font-size: 18px;
            cursor: pointer;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            backdrop-filter: blur(4px);
        }

        .scroll-button:hover {
            background: rgba(241, 196, 15, 0.2);
            border-color: #f1c40f;
        }

        .scroll-button.prev {
            left: 10px;
        }

        .scroll-button.next {
            right: 10px;
        }

        @media (max-width: 1400px) {
            .games-container {
                padding: 0 50px;
            }
        }

        @media (max-width: 768px) {
            .games-container {
                padding: 0 40px;
            }

            .game-card {
                flex: 0 0 260px;
                min-width: 260px;
                max-width: 260px;
            }

            .games-grid {
                padding: 20px calc(50% - 130px); /* Centraliza os cards */
            }
        }

        @media (max-width: 480px) {
            .games-container {
                padding: 0 30px;
            }

            .game-card {
                flex: 0 0 220px;
                min-width: 220px;
                max-width: 220px;
            }

            .games-grid {
                padding: 20px calc(50% - 110px); /* Centraliza os cards */
            }

            .games-container::before,
            .games-container::after {
                width: 40px; /* Degradê menor em telas pequenas */
            }
        }

        /* Estilos para os cards recomendados */
        .recommended-card {
            position: relative;
        }

        .recommendation-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: linear-gradient(45deg, var(--color-primary), #f39c12);
            color: #000;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            z-index: 2;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .compatibility-score {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(0,0,0,0.8);
            color: var(--color-text);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            z-index: 2;
        }

        .compatibility-score i {
            color: var(--color-primary);
            margin-right: 4px;
        }

        .recommendation-info {
            padding: 10px;
            background: rgba(0,0,0,0.8);
            border-radius: 8px;
            margin-top: 10px;
            font-size: 12px;
        }

        .recommendation-reason {
            color: var(--color-text);
            margin-bottom: 6px;
        }

        .recommendation-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            margin-top: 6px;
        }

        .recommendation-tag {
            background: rgba(241, 196, 15, 0.2);
            color: var(--color-primary);
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
        }

        /* ===== RESPONSIVE STYLES ===== */
        @media (max-width: 1400px) {
            .games-container {
                padding: 0 50px;
            }
        }

        @media (max-width: 768px) {
            .games-container {
                padding: 0 40px;
            }

            .game-card {
                flex: 0 0 260px;
                min-width: 260px;
                max-width: 260px;
            }

            .games-grid {
                padding: 20px calc(50% - 130px);
            }

            .carousel-button {
                padding: 10px 16px;
                font-size: 13px;
            }

            .carousel-button i {
                font-size: 14px;
            }

            .carousel-info {
                padding: 20px;
            }
        }

        @media (max-width: 480px) {
            .games-container {
                padding: 0 30px;
            }

            .game-card {
                flex: 0 0 220px;
                min-width: 220px;
                max-width: 220px;
            }

            .games-grid {
                padding: 20px calc(50% - 110px);
            }

            .games-container::before,
            .games-container::after {
                width: 40px;
            }

            .compatibility-score {
                font-size: 9px;
            }

            .recommendation-badge {
                font-size: 9px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <main>

    <div class="hero">
        <div class="hero-content">
            <h1>Bem-vindo ao JoyStream</h1>
            <p>Descubra, recomende e compartilhe seus jogos favoritos!</p>
        </div>
    </div>
    <div class="games-section">
        <div class="games-container">
    <section class="featured-carousel-section">
        <h2 class="section-title">Destaques e Recomendados</h2>
        <div class="carousel-container">
            <button class="carousel-arrow prev" onclick="prevSlide()">
                <i class="fas fa-chevron-left"></i>
            </button>
            <div class="featured-carousel">
                <% for (int i = 0; i < jogosCarrossel.size(); i++) {
                    Jogo jogo = jogosCarrossel.get(i);
                    List<String> screenshots = jogo.getScreenshots();
                %>
                <div class="carousel-slide<%= (i == 0) ? " active" : "" %>" data-index="<%= i %>">
                    <div class="carousel-main">
                            <img src="<%= jogo.getImagemUrl() %>" alt="<%= jogo.getNome() %>" class="carousel-banner">
                    </div>
                    <div class="carousel-info">
                        <div class="carousel-info-top">
                        <h2><%= jogo.getNome() %></h2>
                            <% if (jogo.getGeneros() != null) { %>
                                <p class="game-meta"><i class="fas fa-gamepad"></i> <%= jogo.getGeneros() %></p>
                            <% } %>
                            <% if (jogo.getPlataformas() != null) { %>
                                <p class="game-meta"><i class="fas fa-desktop"></i> <%= jogo.getPlataformas() %></p>
                            <% } %>
                            <% if (jogo.getDataLancamento() != null) { %>
                                <p class="game-meta"><i class="far fa-calendar-alt"></i> <%= jogo.getDataLancamento() %></p>
                            <% } %>
                        <div class="carousel-thumbnails">
                                <% if (screenshots != null) {
                                    for (int j = 0; j < Math.min(screenshots.size(), 3); j++) { %>
                                        <img src="<%= screenshots.get(j) %>" alt="Screenshot" onclick="showScreenshot(this.src)">
                                <% }
                                } %>
                        </div>
                        </div>
                        <div class="carousel-info-bottom">
                            <button class="carousel-button" onclick="window.location.href='detalhe.jsp?id=<%= jogo.getId() %>'">
                                Mais Informações <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <button class="carousel-arrow next" onclick="nextSlide()">
                <i class="fas fa-chevron-right"></i>
            </button>
        </div>
    </section>
    </div>
    </div>

    <div class="games-section">
        <div class="games-container">
            <h2 class="section-title">Jogos em Destaque</h2>
            <button class="scroll-button prev" data-direction="prev">
                <i class="fas fa-chevron-left"></i>
            </button>
            <div class="games-grid" id="featured-games">
                <% for (Jogo jogo : jogosDestaque) { %>
        <div class="game-card">
                        <div class="game-image-container">
                            <img src="<%= jogo.getImagemUrl() %>" alt="<%= jogo.getNome() %>" class="game-image">
        </div>
                        <div class="game-info">
                            <h3 class="game-title"><%= jogo.getNome() %></h3>
                            <% if (jogo.getGeneros() != null) { %>
                                <p class="game-meta"><i class="fas fa-gamepad"></i> <%= jogo.getGeneros() %></p>
                            <% } %>
                            <% if (jogo.getPlataformas() != null) { %>
                                <p class="game-meta"><i class="fas fa-desktop"></i> <%= jogo.getPlataformas() %></p>
                            <% } %>
                            <% if (jogo.getDataLancamento() != null) { %>
                                <p class="game-meta"><i class="far fa-calendar-alt"></i> <%= jogo.getDataLancamento() %></p>
                            <% } %>
                            <% if (jogo.getNota() != null) { %>
                                <div class="metacritic-score <%= jogo.getNota() >= 85 ? "score-high" : jogo.getNota() >= 70 ? "score-medium" : "score-low" %>">
                                    <i class="fas fa-star"></i> <%= jogo.getNota() %>
        </div>
                            <% } %>
                            <button class="more-info-btn" onclick="window.location.href='detalhe.jsp?id=<%= jogo.getId() %>'">
                                Mais Informações <i class="fas fa-arrow-right"></i>
                            </button>
        </div>
                    </div>
                <% } %>
            </div>
            <button class="scroll-button next" data-direction="next">
                <i class="fas fa-chevron-right"></i>
            </button>
        </div>
    </div>

    <% if (logado && jogosRecomendados != null && !jogosRecomendados.isEmpty()) { %>
    <div class="games-section">
        <div class="games-container">
            <h2 class="section-title">Recomendados para Você</h2>
            <button class="scroll-button prev" data-direction="prev">
                <i class="fas fa-chevron-left"></i>
            </button>
            <div class="games-grid" id="recommended-games">
                <% for (Jogo jogo : jogosRecomendados) { %>
                    <div class="game-card recommended-card">
                        <div class="recommendation-badge">
                            Recomendado
                        </div>
                        <div class="game-image-container">
                            <img src="<%= jogo.getImagemUrl() %>" alt="<%= jogo.getNome() %>" class="game-image">
                        </div>
                        <div class="game-info">
                            <h3 class="game-title"><%= jogo.getNome() %></h3>
                            <% if (jogo.getGeneros() != null) { %>
                                <p class="game-meta"><i class="fas fa-gamepad"></i> <%= jogo.getGeneros() %></p>
                            <% } %>
                            <% if (jogo.getPlataformas() != null) { %>
                                <p class="game-meta"><i class="fas fa-desktop"></i> <%= jogo.getPlataformas() %></p>
                            <% } %>
                            <% if (jogo.getDataLancamento() != null) { %>
                                <p class="game-meta"><i class="far fa-calendar-alt"></i> <%= jogo.getDataLancamento() %></p>
                            <% } %>
                            <div class="recommendation-info">
                                <p class="recommendation-reason">
                                    <i class="fas fa-lightbulb"></i>
                                    Recomendado com base nos seus jogos favoritos
                                </p>
                                <div class="recommendation-tags">
                                    <% 
                                    String[] generos = jogo.getGeneros() != null ? jogo.getGeneros().split(",") : new String[0];
                                    for (String genero : generos) { 
                                        if (!genero.trim().isEmpty()) {
                                    %>
                                        <span class="recommendation-tag"><%= genero.trim() %></span>
                                    <% 
                                        }
                                    } 
                                    %>
                                </div>
                            </div>
                            <% if (jogo.getNota() != null) { %>
                                <div class="metacritic-score <%= jogo.getNota() >= 85 ? "score-high" : jogo.getNota() >= 70 ? "score-medium" : "score-low" %>">
                                    <i class="fas fa-star"></i> <%= jogo.getNota() %>
                                </div>
                            <% } %>
                            <button class="more-info-btn" onclick="window.location.href='detalhe.jsp?id=<%= jogo.getId() %>'">
                                Mais Informações <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>
                <% } %>
            </div>
            <button class="scroll-button next" data-direction="next">
                <i class="fas fa-chevron-right"></i>
            </button>
        </div>
    </div>
    <% } %>

    </main>

    <jsp:include page="components/footer.jsp" />

    <script>
        // Código do carrossel principal
    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-slide');
        const totalSlides = slides.length;

    function showSlide(index) {
            currentSlide = (index + totalSlides) % totalSlides;
            
            slides.forEach(slide => {
                slide.classList.remove('active');
                slide.style.opacity = '0';
            });

            const currentSlideElement = slides[currentSlide];
            currentSlideElement.classList.add('active');
            void currentSlideElement.offsetWidth;
            currentSlideElement.style.opacity = '1';
    }

        function nextSlide() {
            showSlide(currentSlide + 1);
            resetInterval();
        }

        function prevSlide() {
            showSlide(currentSlide - 1);
            resetInterval();
        }

        let slideInterval = setInterval(nextSlide, 5000);

        function resetInterval() {
            clearInterval(slideInterval);
            slideInterval = setInterval(nextSlide, 5000);
        }

        // Navegação das seções de jogos
        class GameNavigation {
            constructor(sectionId) {
                this.container = document.getElementById(sectionId);
                this.prevButton = this.container.parentElement.querySelector('.scroll-button.prev');
                this.nextButton = this.container.parentElement.querySelector('.scroll-button.next');
                this.cardWidth = this.calculateCardWidth();
                this.scrolling = false;
                this.setupInfiniteScroll();
                this.setupNavigation();
                this.updateButtonVisibility();
                this.setupIntersectionObserver();

                // Atualizar quando a janela for redimensionada
                window.addEventListener('resize', () => {
                    this.cardWidth = this.calculateCardWidth();
                    this.updateButtonVisibility();
                });
            }

            calculateCardWidth() {
                // Calcula a largura do card baseado no tamanho da tela
                const screenWidth = window.innerWidth;
                if (screenWidth <= 480) return 220;
                if (screenWidth <= 768) return 260;
                return 300;
            }

            setupInfiniteScroll() {
                // Não faz mais nada: rolagem normal, sem duplicar cards nem looping
            }

            setupNavigation() {
                // Remover onclick antigo e adicionar event listeners
                this.prevButton.removeAttribute('onclick');
                this.nextButton.removeAttribute('onclick');

                this.container.addEventListener('scroll', () => {
                    this.updateButtonVisibility();
                });

                this.prevButton.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.scrollToDirection('left');
                });

                this.nextButton.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.scrollToDirection('right');
                });

                // Adicionar suporte a touch
                let startX;
                let scrollLeft;
                let isDown = false;

                this.container.addEventListener('touchstart', (e) => {
                    isDown = true;
                    startX = e.touches[0].pageX - this.container.offsetLeft;
                    scrollLeft = this.container.scrollLeft;
                });

                this.container.addEventListener('touchend', () => {
                    isDown = false;
                    this.snapToNearestCard();
                });

                this.container.addEventListener('touchcancel', () => {
                    isDown = false;
                });

                this.container.addEventListener('touchmove', (e) => {
                    if (!isDown) return;
                    e.preventDefault();
                    const x = e.touches[0].pageX - this.container.offsetLeft;
                    const walk = (x - startX) * 2;
                    this.container.scrollLeft = scrollLeft - walk;
                });
            }

            setupIntersectionObserver() {
                const options = {
                    root: this.container,
                    threshold: 0.7 // Card precisa estar 70% visível
                };

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('active');
                        } else {
                            entry.target.classList.remove('active');
                        }
                    });
                }, options);

                // Observar todos os cards
                this.container.querySelectorAll('.game-card').forEach(card => {
                    observer.observe(card);
                });
            }

            scrollToDirection(direction) {
                if (this.scrolling) return;
                
                this.scrolling = true;
                const containerWidth = this.container.clientWidth;
                const visibleCards = Math.floor(containerWidth / this.cardWidth);
                const scrollAmount = visibleCards * this.cardWidth;
                
                const currentScroll = this.container.scrollLeft;
                const maxScroll = this.container.scrollWidth - containerWidth;
                
                let newScroll;
                if (direction === 'left') {
                    newScroll = currentScroll - this.cardWidth;
                } else {
                    newScroll = currentScroll + this.cardWidth;
                }

                this.container.scrollTo({
                    left: newScroll,
                    behavior: 'smooth'
                });

                setTimeout(() => {
                    this.scrolling = false;
                    this.updateButtonVisibility();
                }, 300);
    }

            snapToNearestCard() {
                const containerWidth = this.container.clientWidth;
                const scrollPosition = this.container.scrollLeft;
                const cardWidth = this.cardWidth;
                const offset = containerWidth / 2 - cardWidth / 2; // Centraliza o card
                
                const nearestCard = Math.round((scrollPosition - offset) / cardWidth) * cardWidth + offset;
                
                this.container.scrollTo({
                    left: nearestCard,
                    behavior: 'smooth'
                });
            }

            updateButtonVisibility() {
                const currentScroll = this.container.scrollLeft;
                const maxScroll = this.container.scrollWidth - this.container.clientWidth;
                const threshold = 10;

                // Atualizar visibilidade dos botões
                this.prevButton.style.opacity = currentScroll > threshold ? '1' : '0';
                this.prevButton.style.visibility = currentScroll > threshold ? 'visible' : 'hidden';
                
                this.nextButton.style.opacity = currentScroll < maxScroll - threshold ? '1' : '0';
                this.nextButton.style.visibility = currentScroll < maxScroll - threshold ? 'visible' : 'hidden';
    }
        }

        // Inicialização
        document.addEventListener('DOMContentLoaded', () => {
            // Inicializar carrossel principal
            if (slides.length > 0) {
                showSlide(0);
            }

            // Inicializar navegação para cada seção de jogos
            const featuredGames = new GameNavigation('featured-games');
            const recommendedGames = document.getElementById('recommended-games');
            if (recommendedGames) {
                new GameNavigation('recommended-games');
            }

            // Pausar autoplay do carrossel quando o mouse estiver sobre ele
            const carousel = document.querySelector('.featured-carousel');
            if (carousel) {
                carousel.addEventListener('mouseenter', () => {
                    clearInterval(slideInterval);
                });

                carousel.addEventListener('mouseleave', () => {
                    resetInterval();
                });
            }
    });
    </script>
</body>
</html>
