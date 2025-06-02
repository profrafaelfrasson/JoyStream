<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.*" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Jogo> favoritos = (List<Jogo>) request.getAttribute("favoritos");
    if (favoritos == null) {
        response.sendRedirect("favorito");
        return;
    }
    
    String avatarUrl = (usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? 
        ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");
    
    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "JoyStream - Meus Favoritos");
    request.setAttribute("pageDescription", "Meus jogos favoritos");
    request.setAttribute("pageKeywords", "favoritos, jogos favoritos, meus favoritos");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <jsp:include page="components/head.jsp" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #121212;
            color: white;
        }

        .main-content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .page-title {
            color: #f1c40f;
            margin-bottom: 30px;
            font-size: 2em;
            text-align: center;
        }

        .games-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            padding: 20px;
        }

        .game-card {
            background-color: #1f1f1f;
            border-radius: 10px;
            overflow: hidden;
            transition: transform 0.2s;
            position: relative;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .game-card:hover {
            transform: translateY(-5px);
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
            padding: 15px;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .game-title {
            font-size: 1.2em;
            margin: 0 0 10px 0;
            color: white;
            font-weight: bold;
        }

        .game-meta {
            color: #aaa;
            font-size: 0.9em;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .game-meta i {
            color: #f1c40f;
            width: 16px;
        }

        .remove-favorite {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(0, 0, 0, 0.7);
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            z-index: 2;
        }

        .remove-favorite:hover {
            background-color: rgba(255, 0, 0, 0.7);
            transform: scale(1.1);
        }

        .remove-favorite i {
            color: white;
            font-size: 1.2em;
        }

        .no-favorites {
            text-align: center;
            padding: 40px;
            background-color: #1f1f1f;
            border-radius: 10px;
            grid-column: 1 / -1;
        }

        .no-favorites h3 {
            color: #f1c40f;
            margin-bottom: 15px;
        }

        .no-favorites a {
            color: #f1c40f;
            text-decoration: none;
            transition: color 0.3s;
        }

        .no-favorites a:hover {
            color: #f39c12;
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

        .score-high { background-color: #6c3; color: white; }
        .score-medium { background-color: #fc3; color: black; }
        .score-low { background-color: #f66; color: white; }

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

        .more-info-btn i {
            font-size: 14px;
            transition: transform 0.3s;
        }

        .more-info-btn:hover i {
            transform: translateX(3px);
        }

        @media (max-width: 768px) {
            .games-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 15px;
                padding: 15px;
            }

            .game-title {
                font-size: 1.1em;
            }

            .game-meta {
                font-size: 0.85em;
            }
        }

        @media (max-width: 480px) {
            .games-grid {
                grid-template-columns: 1fr;
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <main>
        <div class="main-content">
            <h1 class="page-title">Meus Jogos Favoritos</h1>
            
            <div class="games-grid">
                <% if (favoritos != null && !favoritos.isEmpty()) { %>
                    <% for (Jogo jogo : favoritos) { %>
                        <div class="game-card" id="game-<%= jogo.getId() %>">
                            <button class="remove-favorite" onclick="removerFavorito(<%= jogo.getId() %>)">
                                <i class="fas fa-heart-broken"></i>
                            </button>
                            <div class="game-image-container">
                                <img src="<%= jogo.getImagemUrl() != null ? jogo.getImagemUrl() : request.getContextPath() + "/assets/img/game-placeholder.jpg" %>" 
                                     alt="<%= jogo.getNome() %>" 
                                     class="game-image">
                            </div>
                            <div class="game-info">
                                <div>
                                    <h3 class="game-title"><%= jogo.getNome() %></h3>
                                    <% if (jogo.getGeneros() != null) { %>
                                        <p class="game-meta">
                                            <i class="fas fa-gamepad"></i>
                                            <%= jogo.getGeneros() %>
                                        </p>
                                    <% } %>
                                    <% if (jogo.getPlataformas() != null) { %>
                                        <p class="game-meta">
                                            <i class="fas fa-desktop"></i>
                                            <%= jogo.getPlataformas() %>
                                        </p>
                                    <% } %>
                                    <% if (jogo.getDataLancamento() != null) { %>
                                        <p class="game-meta">
                                            <i class="far fa-calendar-alt"></i>
                                            <%= jogo.getDataLancamento() %>
                                        </p>
                                    <% } %>
                                    <% if (jogo.getNota() != null) { %>
                                        <div class="metacritic-score <%= jogo.getNota() >= 85 ? "score-high" : jogo.getNota() >= 70 ? "score-medium" : "score-low" %>">
                                            <i class="fas fa-star"></i> <%= jogo.getNota() %>
                                        </div>
                                    <% } %>
                                </div>
                                <button class="more-info-btn" onclick="window.location.href='detalhe.jsp?id=<%= jogo.getId() %>'">
                                    Mais Informações <i class="fas fa-arrow-right"></i>
                                </button>
                            </div>
                        </div>
                    <% } %>
                <% } else { %>
                    <div class="no-favorites">
                        <h3>Você ainda não tem jogos favoritos</h3>
                        <p>Vá para a página de <a href="jogos.jsp">Jogos</a> e favorite alguns!</p>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <jsp:include page="components/footer.jsp" />

    <script src="assets/js/alert.js"></script>
    <script>
        function removerFavorito(jogoId) {
            confirmAction(
                'Remover dos Favoritos',
                'Tem certeza que deseja remover este jogo dos seus favoritos?',
                'Sim, remover',
                'Cancelar'
            ).then((result) => {
                if (result.isConfirmed) {
                    fetch('favorito?action=remover&jogoId=' + jogoId, {
                        method: 'POST'
                    }).then(response => {
                        if (response.ok) {
                            const card = document.getElementById('game-' + jogoId);
                            card.style.transform = 'scale(0.8)';
                            card.style.opacity = '0';
                            setTimeout(() => {
                                card.remove();
                                
                                // Verificar se ainda existem jogos favoritos
                                const gamesGrid = document.querySelector('.games-grid');
                                if (!gamesGrid.querySelector('.game-card')) {
                                    gamesGrid.innerHTML = `
                                        <div class="no-favorites">
                                            <h3>Você ainda não tem jogos favoritos</h3>
                                            <p>Vá para a página de <a href="jogos.jsp">Jogos</a> e favorite alguns!</p>
                                        </div>
                                    `;
                                }
                                showSuccess('Jogo removido dos favoritos');
                            }, 300);
                        } else {
                            showError('Erro', 'Não foi possível remover o jogo dos favoritos');
                        }
                    }).catch(error => {
                        console.error('Erro:', error);
                        showError('Erro', 'Não foi possível remover o jogo dos favoritos');
                    });
                }
            });
        }
    </script>
</body>
</html> 