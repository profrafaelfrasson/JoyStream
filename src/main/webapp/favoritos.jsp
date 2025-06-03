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
                            <button class="analise-icone" id="analise-icone-<%= jogo.getId() %>" onclick="abrirModalAnalise(<%= jogo.getId() %>)" style="position:absolute;top:10px;left:10px;background:rgba(241,196,15,0.9);border:none;border-radius:50%;width:36px;height:36px;display:flex;align-items:center;justify-content:center;cursor:pointer;z-index:2;transition:background 0.3s;">
                                <i class="fas fa-pen fa-lg" id="analise-icon-fa-<%= jogo.getId() %>" style="color:#222;"></i>
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
                                <button class="concluido-btn" id="btn-concluido-<%= jogo.getId() %>" onclick="toggleConcluido(<%= jogo.getId() %>)" style="width:100%;margin-top:8px;background:#c0392b;color:#fff;font-weight:bold;border:none;border-radius:6px;padding:10px 0;transition:background 0.3s, color 0.3s;font-family:'Segoe UI',sans-serif;font-size:15px;">
                                    <span id="txt-concluido-<%= jogo.getId() %>">Não finalizado</span>
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

    <!-- Modal simples -->
    <div id="modal-concluido" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);z-index:999;align-items:center;justify-content:center;">
        <div style="background:#222;padding:24px 32px;border-radius:8px;text-align:center;min-width:260px;">
            <p style="color:#fff;font-size:1.1em;">Você finalizou esse game?</p>
            <div style="margin-top:16px;">
                <button id="btn-sim" style="margin-right:16px;padding:8px 24px;background:#27ae60;color:#fff;border:none;border-radius:4px;cursor:pointer;">Sim</button>
                <button id="btn-nao" style="padding:8px 24px;background:#c0392b;color:#fff;border:none;border-radius:4px;cursor:pointer;">Não</button>
            </div>
        </div>
    </div>

    <script>
    let jogoIdAtual = null;

    function perguntarConcluido(jogoId) {
        jogoIdAtual = jogoId;
        document.getElementById('modal-concluido').style.display = 'flex';
    }

    document.getElementById('btn-sim').onclick = function() {
        if (jogoIdAtual) {
            localStorage.setItem('concluido_' + jogoIdAtual, '1');
            atualizarBotaoConcluido(jogoIdAtual);
        }
        fecharModalConcluido();
    };

    document.getElementById('btn-nao').onclick = function() {
        if (jogoIdAtual) {
            localStorage.setItem('concluido_' + jogoIdAtual, '0');
            atualizarBotaoConcluido(jogoIdAtual);
        }
        fecharModalConcluido();
    };

    function fecharModalConcluido() {
        document.getElementById('modal-concluido').style.display = 'none';
        jogoIdAtual = null;
    }

    function toggleConcluido(jogoId) {
        const status = localStorage.getItem('concluido_' + jogoId);
        if (status === '1') {
            localStorage.setItem('concluido_' + jogoId, '0');
        } else {
            localStorage.setItem('concluido_' + jogoId, '1');
        }
        atualizarBotaoConcluido(jogoId);
    }

    function atualizarBotaoConcluido(jogoId) {
        const status = localStorage.getItem('concluido_' + jogoId);
        const btn = document.getElementById('btn-concluido-' + jogoId);
        const txt = document.getElementById('txt-concluido-' + jogoId);
        btn.style.fontWeight = 'bold';
        btn.style.fontFamily = "'Segoe UI',sans-serif";
        btn.style.fontSize = '15px';
        btn.style.borderRadius = '6px';
        btn.style.border = 'none';
        btn.style.transition = 'background 0.3s, color 0.3s';
        if (status === '1') {
            btn.style.background = '#27ae60';
            btn.style.color = '#fff';
            txt.textContent = 'Finalizado!';
        } else {
            btn.style.background = '#c0392b';
            btn.style.color = '#fff';
            txt.textContent = 'Não finalizado';
        }
    }

    function carregarConcluidos() {
        document.querySelectorAll('.concluido-btn').forEach(function(btn) {
            const jogoId = btn.id.replace('btn-concluido-', '');
            atualizarBotaoConcluido(jogoId);
        });
    }

    window.onload = function() {
        carregarConcluidos();
    };
    </script>

    <!-- Modal de análise -->
    <div id="modal-analise" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);z-index:1001;align-items:center;justify-content:center;">
        <div style="background:#222;padding:24px 32px;border-radius:8px;text-align:center;min-width:320px;max-width:90vw;">
            <h3 style="color:#f1c40f;margin-bottom:16px;">Publique sua análise</h3>
            <textarea id="analise-text" rows="5" style="width:100%;border-radius:6px;border:none;padding:10px;font-size:1em;resize:vertical;margin-bottom:16px;" placeholder="Escreva sua análise..."></textarea>
            <div style="margin-bottom:16px;">
                <label style="color:#fff;margin-right:8px;">Nota:</label>
                <div id="analise-nota-btns" style="display:flex;gap:4px;justify-content:center;align-items:center;">
                    <!-- Botões de nota de 0 a 10 -->
                    <script>
                    for (let i = 0; i <= 10; i++) {
                        document.write('<button type="button" class="nota-btn" data-nota="'+i+'" style="background:#333;color:#fff;border:none;border-radius:4px;padding:4px 8px;font-size:1em;cursor:pointer;transition:background 0.2s;">'+i+'</button>');
                    }
                    </script>
                </div>
            </div>
            <div style="margin-top:12px;">
                <button id="btn-publicar-analise" style="background:#f1c40f;color:#222;font-weight:bold;border:none;border-radius:6px;padding:8px 24px;margin-right:12px;cursor:pointer;">Publicar</button>
                <button id="btn-cancelar-analise" style="background:#c0392b;color:#fff;font-weight:bold;border:none;border-radius:6px;padding:8px 24px;cursor:pointer;">Cancelar</button>
            </div>
        </div>
    </div>
    <script>
    let jogoIdAnalise = null;
    let notaSelecionada = null;

    function abrirModalAnalise(jogoId) {
        jogoIdAnalise = jogoId;
        document.getElementById('analise-text').value = localStorage.getItem('analise_' + jogoId) || '';
        notaSelecionada = localStorage.getItem('nota_' + jogoId) || null;
        destacarNotaSelecionada();
        document.getElementById('modal-analise').style.display = 'flex';
    }

    function destacarNotaSelecionada() {
        document.querySelectorAll('#analise-nota-btns .nota-btn').forEach(function(btn) {
            if (btn.getAttribute('data-nota') === String(notaSelecionada)) {
                btn.style.background = '#f1c40f';
                btn.style.color = '#222';
                btn.style.fontWeight = 'bold';
            } else {
                btn.style.background = '#333';
                btn.style.color = '#fff';
                btn.style.fontWeight = 'normal';
            }
        });
    }

    document.querySelectorAll('#analise-nota-btns .nota-btn').forEach(function(btn) {
        btn.onclick = function() {
            notaSelecionada = btn.getAttribute('data-nota');
            destacarNotaSelecionada();
        };
    });

    document.getElementById('btn-publicar-analise').onclick = function() {
        if (jogoIdAnalise) {
            const texto = document.getElementById('analise-text').value.trim();
            localStorage.setItem('analise_' + jogoIdAnalise, texto);
            localStorage.setItem('nota_' + jogoIdAnalise, notaSelecionada || '');
            atualizarIconeAnalise(jogoIdAnalise);
        }
        fecharModalAnalise();
    };

    document.getElementById('btn-cancelar-analise').onclick = function() {
        fecharModalAnalise();
    };

    function fecharModalAnalise() {
        document.getElementById('modal-analise').style.display = 'none';
        jogoIdAnalise = null;
    }

    function atualizarIconeAnalise(jogoId) {
        const texto = localStorage.getItem('analise_' + jogoId);
        const nota = localStorage.getItem('nota_' + jogoId);
        const icone = document.getElementById('analise-icone-' + jogoId);
        const faIcon = document.getElementById('analise-icon-fa-' + jogoId);
        if ((texto && texto.length > 0) || (nota && nota.length > 0)) {
            icone.style.background = '#27ae60';
            faIcon.style.color = '#fff';
        } else {
            icone.style.background = 'rgba(241,196,15,0.9)';
            faIcon.style.color = '#222';
        }
    }

    function carregarAnalises() {
        document.querySelectorAll('.analise-icone').forEach(function(btn) {
            const jogoId = btn.id.replace('analise-icone-', '');
            atualizarIconeAnalise(jogoId);
        });
    }

    window.onload = function() {
        carregarConcluidos();
        carregarAnalises();
    };
    </script>
</body>
</html> 