<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.*" %>
<%@ page import="com.joystream.dao.*" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Jogo> jogos = (List<Jogo>) request.getAttribute("favoritos");
    List<Favorito> favoritos = (List<Favorito>) request.getAttribute("favoritos_detalhes");
    if (favoritos == null || jogos == null) {
        response.sendRedirect("favorito");
        return;
    }
    
    String avatarUrl = (usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? 
        ("data:image/png;base64," + usuario.getAvatar()) : (request.getContextPath() + "/assets/img/default-avatar.png");
    
    String nomeUsuario = "";
    if (usuario != null) {
        nomeUsuario = usuario.getNmUsuario();
    }
    
    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", "JoyStream - Meus Favoritos");
    request.setAttribute("pageDescription", "Meus jogos favoritos");
    request.setAttribute("pageKeywords", "favoritos, jogos favoritos, meus favoritos");

    // Instanciar DAOs
    AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();
    FavoritoDAO favoritoDAO = new FavoritoDAO();
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
            align-items: baseline;
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

        .nota-btn {
            background: #333;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 4px 10px;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.2s ease;
            margin: 0 1px;
            outline: none;
        }
        .nota-btn:hover {
            background: #444;
            transform: translateY(-2px);
        }

        .nota-btn.selected {
            background: #f1c40f;
            color: #222;
            font-weight: bold;
            box-shadow: 0 0 0 2px rgba(241,196,15,0.3);
            transform: translateY(-2px);
        }

        .analise-icone {
            position: absolute;
            top: 10px;
            left: 10px;
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 2;
            transition: background 0.3s;
        }
        
        .analise-icone.avaliado {
            background: #27ae60;
        }
        
        .analise-icone.nao-avaliado {
            background: rgba(241,196,15,0.9);
        }
        
        .analise-icone i {
            font-size: 1.2em;
        }
        
        .analise-icone.avaliado i {
            color: #fff;
        }
        
        .analise-icone.nao-avaliado i {
            color: #222;
        }
        
        .concluido-btn {
            width: 100%;
            margin-top: 8px;
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            padding: 10px 0;
            transition: background 0.3s, color 0.3s;
            font-family: 'Segoe UI', sans-serif;
            font-size: 15px;
        }
        
        .concluido-btn.finalizado {
            background: #27ae60;
        }
        
        .concluido-btn.nao-finalizado {
            background: #c0392b;
        }
        
        .avaliacao-usuario {
            background: #222;
            padding: 12px;
            border-radius: 6px;
            margin-top: 8px;
        }
        
        .avaliacao-usuario h5 {
            color: #f1c40f;
            margin-bottom: 6px;
            font-size: 1em;
        }
        
        .avaliacao-nota {
            background: #f1c40f;
            color: #222;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: bold;
        }
        
        .avaliacao-comentario {
            color: #fff;
            white-space: pre-line;
            font-size: 0.95em;
        }

        /* Estilos do Modal */
        .modal-analise {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.8);
            z-index: 1001;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: #222;
            padding: 24px 32px;
            border-radius: 8px;
            text-align: center;
            min-width: 320px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .modal-title {
            color: #f1c40f;
            margin-bottom: 16px;
            font-size: 1.5em;
            font-weight: bold;
        }

        .modal-textarea {
            width: 100%;
            border-radius: 6px;
            border: 1px solid #333;
            padding: 12px;
            font-size: 1em;
            resize: vertical;
            margin-bottom: 16px;
            background: #333;
            color: #fff;
            min-height: 120px;
            max-height: 300px;
            box-sizing: border-box;
        }

        .modal-textarea:focus {
            outline: none;
            border-color: #f1c40f;
            box-shadow: 0 0 0 2px rgba(241,196,15,0.2);
        }

        .modal-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .modal-btn {
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1em;
        }

        .modal-btn-publicar {
            background: #f1c40f;
            color: #222;
        }

        .modal-btn-publicar:hover {
            background: #f39c12;
            transform: translateY(-2px);
        }

        .modal-btn-cancelar {
            background: #c0392b;
            color: #fff;
        }

        .modal-btn-cancelar:hover {
            background: #e74c3c;
            transform: translateY(-2px);
        }

        .modal-btn-disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none !important;
        }

        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            margin-left: 8px;
            border: 2px solid #222;
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <main>
        <div class="main-content">
            <h1 class="page-title">Meus Jogos Favoritos</h1>
            
            <div class="games-grid">
                <% if (jogos != null && !jogos.isEmpty()) { %>
                    <% for (int i = 0; i < jogos.size(); i++) { %>
                        <% 
                            Jogo jogo = jogos.get(i);
                            Favorito favorito = favoritos.get(i);
                            Avaliacao avaliacao = favorito.getAvaliacao();
                            boolean concluido = favorito.isConcluido();
                            int jogoId = jogo.getId().intValue();
                        %>
                        <div class="game-card" id="game-<%= jogoId %>">
                            <button class="remove-favorite" onclick="removerFavorito(<%= jogoId %>)">
                                <i class="fas fa-heart-broken"></i>
                            </button>
                            <button 
                                class="analise-icone <%= avaliacao != null ? "avaliado" : "nao-avaliado" %>" 
                                id="analise-icone-<%= jogoId %>" 
                                onclick="abrirModalAnalise(<%= jogoId %>)">
                                <i class="fas fa-pen fa-lg"></i>
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
                                </div>
                                <div>
                                    <% if (jogo.getNota() != null) { %>
                                        <div class="metacritic-score <%= jogo.getNota() >= 85 ? "score-high" : jogo.getNota() >= 70 ? "score-medium" : "score-low" %>">
                                            <i class="fas fa-star"></i> <%= jogo.getNota() %>
                                        </div>
                                    <% } %>
                                <button class="more-info-btn" onclick="window.location.href='detalhe.jsp?id=<%= jogoId %>'">
                                    Mais Informações <i class="fas fa-arrow-right"></i>
                                </button>
                                <button 
                                    class="concluido-btn <%= concluido ? "finalizado" : "nao-finalizado" %>" 
                                    id="btn-concluido-<%= jogoId %>" 
                                    onclick="toggleConcluido(<%= jogoId %>)">
                                    <span id="txt-concluido-<%= jogoId %>"><%= concluido ? "Finalizado!" : "Não finalizado" %></span>
                                </button>
                            </div>
                                <% if (avaliacao != null) { %>
                                    <div class="avaliacao-usuario">
                                        <h5>Sua avaliação:</h5>
                                        <div style="margin-bottom:4px;"><b><%= nomeUsuario %></b></div>
                                        <div style="font-size:1em;margin-bottom:4px;">
                                            <b>Nota:</b> <span class="avaliacao-nota"><%= avaliacao.getNota() %></span>
                                        </div>
                                        <% if (avaliacao.getComentario() != null && !avaliacao.getComentario().isEmpty()) { %>
                                            <div style="margin-bottom:2px;"><b>Comentário:</b></div>
                                            <div class="avaliacao-comentario"><%= avaliacao.getComentario().replace("<", "&lt;").replace(">", "&gt;") %></div>
                                        <% } %>
                                    </div>
                                <% } %>
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

    <!-- Modal de análise -->
    <div id="modal-analise" class="modal-analise">
        <div class="modal-content">
            <h3 class="modal-title">Publique sua análise</h3>
            <textarea id="analise-text" class="modal-textarea" placeholder="Escreva sua análise..."></textarea>
            <div>
                <label style="color:#fff;margin-right:8px;">Nota:</label>
                <div id="analise-nota-btns" style="display:flex;gap:4px;justify-content:center;align-items:center;margin-top:8px;">
                    <button type="button" class="nota-btn" data-nota="0">0</button>
                    <button type="button" class="nota-btn" data-nota="1">1</button>
                    <button type="button" class="nota-btn" data-nota="2">2</button>
                    <button type="button" class="nota-btn" data-nota="3">3</button>
                    <button type="button" class="nota-btn" data-nota="4">4</button>
                    <button type="button" class="nota-btn" data-nota="5">5</button>
                    <button type="button" class="nota-btn" data-nota="6">6</button>
                    <button type="button" class="nota-btn" data-nota="7">7</button>
                    <button type="button" class="nota-btn" data-nota="8">8</button>
                    <button type="button" class="nota-btn" data-nota="9">9</button>
                    <button type="button" class="nota-btn" data-nota="10">10</button>
                </div>
            </div>
            <div class="modal-buttons">
                <button id="btn-cancelar-analise" class="modal-btn modal-btn-cancelar">Cancelar</button>
                <button id="btn-publicar-analise" class="modal-btn modal-btn-publicar">
                    <span>Publicar</span>
                    <div class="loading-spinner"></div>
                </button>
            </div>
        </div>
    </div>
    <script>
    let jogoIdAnalise = null;
    let notaSelecionada = null;

    function abrirModalAnalise(jogoId) {
        jogoIdAnalise = jogoId;
        // Buscar avaliação existente
        fetch('avaliacao?jogoId=' + jogoId)
            .then(response => {
                if (!response.ok) {
                    throw new Error('Erro ao buscar avaliação');
                }
                return response.json();
            })
            .then(data => {
                const textArea = document.getElementById('analise-text');
                textArea.value = data.comentario || '';
                
                // Ajusta a altura do textarea baseado no conteúdo
                textArea.style.height = 'auto';
                textArea.style.height = Math.min(300, Math.max(120, textArea.scrollHeight)) + 'px';
                
                notaSelecionada = data.nota;
                destacarNotaSelecionada();
                document.getElementById('modal-analise').style.display = 'flex';
            })
            .catch(error => {
                console.error('Erro ao buscar avaliação:', error);
                document.getElementById('analise-text').value = '';
                notaSelecionada = null;
                destacarNotaSelecionada();
                document.getElementById('modal-analise').style.display = 'flex';
            });
    }

    function destacarNotaSelecionada() {
        document.querySelectorAll('#analise-nota-btns .nota-btn').forEach(function(btn) {
            if (btn.getAttribute('data-nota') === String(notaSelecionada)) {
                btn.classList.add('selected');
            } else {
                btn.classList.remove('selected');
            }
        });
    }

    document.querySelectorAll('#analise-nota-btns .nota-btn').forEach(function(btn) {
        btn.onclick = function() {
            const clickedNota = btn.getAttribute('data-nota');
            // Se a nota clicada já estava selecionada, remove a seleção
            if (clickedNota === String(notaSelecionada)) {
                notaSelecionada = null;
                btn.classList.remove('selected');
            } else {
                notaSelecionada = clickedNota;
                destacarNotaSelecionada();
            }
        };
    });

    // Ajusta a altura do textarea automaticamente enquanto o usuário digita
    document.getElementById('analise-text').addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = Math.min(300, Math.max(120, this.scrollHeight)) + 'px';
    });

    document.getElementById('btn-publicar-analise').onclick = function() {
        if (jogoIdAnalise) {
            const btnPublicar = this;
            const texto = document.getElementById('analise-text').value.trim();
            const nota = notaSelecionada || '';
            
            if (!nota) {
                showError('Erro', 'Por favor, selecione uma nota para o jogo');
                return;
            }

            // Desabilitar botão e mostrar loading
            btnPublicar.classList.add('modal-btn-disabled');
            btnPublicar.querySelector('.loading-spinner').style.display = 'inline-block';

            fetch('avaliacao', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: 'jogoId=' + jogoIdAnalise + '&nota=' + nota + '&comentario=' + encodeURIComponent(texto)
            }).then(response => {
                if (response.ok) {
                    fecharModalAnalise();
                    window.location.reload();
                } else {
                    showError('Erro', 'Não foi possível salvar sua avaliação');
                    // Reabilitar botão e esconder loading em caso de erro
                    btnPublicar.classList.remove('modal-btn-disabled');
                    btnPublicar.querySelector('.loading-spinner').style.display = 'none';
                }
            }).catch(error => {
                console.error('Erro:', error);
                showError('Erro', 'Não foi possível salvar sua avaliação');
                // Reabilitar botão e esconder loading em caso de erro
                btnPublicar.classList.remove('modal-btn-disabled');
                btnPublicar.querySelector('.loading-spinner').style.display = 'none';
            });
        }
    };

    document.getElementById('btn-cancelar-analise').onclick = function() {
        fecharModalAnalise();
    };

    function fecharModalAnalise() {
        document.getElementById('modal-analise').style.display = 'none';
        jogoIdAnalise = null;
        // Limpar estado do botão publicar
        const btnPublicar = document.getElementById('btn-publicar-analise');
        btnPublicar.classList.remove('modal-btn-disabled');
        btnPublicar.querySelector('.loading-spinner').style.display = 'none';
    }

    function toggleConcluido(jogoId) {
        const btn = document.getElementById('btn-concluido-' + jogoId);
        const txt = document.getElementById('txt-concluido-' + jogoId);
        const isConcluido = txt.textContent === 'Não finalizado';

        fetch('favorito?action=concluido&jogoId=' + jogoId + '&concluido=' + isConcluido, {
            method: 'POST'
        }).then(response => response.json())
        .then(data => {
            if (data.success) {
                btn.style.background = data.concluido ? '#27ae60' : '#c0392b';
                txt.textContent = data.concluido ? 'Finalizado!' : 'Não finalizado';
            } else {
                showError('Erro', 'Não foi possível atualizar o status do jogo');
            }
        }).catch(error => {
            console.error('Erro:', error);
            showError('Erro', 'Não foi possível atualizar o status do jogo');
        });
    }
    </script>
</body>
</html> 