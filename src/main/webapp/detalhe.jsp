<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*" %>
<%@ page import="com.joystream.util.DateUtil" %>
<%@ page import="com.joystream.config.ApiConfig" %>
<%
    String id = request.getParameter("id");
    JSONObject jogo = null;
    if (id != null && !id.isEmpty()) {
        try {
            URL url = new URL(ApiConfig.RAWG_API_BASE_URL + "/" + id + "?key=" + ApiConfig.RAWG_API_KEY);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            conn.disconnect();
            jogo = new JSONObject(content.toString());

            // Buscar screenshots adicionais
            url = new URL(ApiConfig.RAWG_API_BASE_URL + "/" + id + "/screenshots?key=" + ApiConfig.RAWG_API_KEY);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            conn.disconnect();
            JSONObject screenshotsJson = new JSONObject(content.toString());
            request.setAttribute("screenshots", screenshotsJson.getJSONArray("results"));
        } catch (Exception e) {
            out.println("<p>Erro ao buscar detalhes do jogo.</p>");
        }
    }

    String nomeUsuario = "";
    if (session.getAttribute("usuario") != null) {
        com.joystream.model.Usuario usuario = (com.joystream.model.Usuario) session.getAttribute("usuario");
        nomeUsuario = usuario.getNmUsuario();
    }

   if (jogo != null) {
    // Configurar variáveis para o SEO da página
    request.setAttribute("pageTitle", jogo.getString("name") + " | Detalhes do Jogo - JoyStream");
    request.setAttribute("pageDescription", "Descubra mais sobre o jogo " + jogo.getString("name"));
    
    // Construir keywords com nome do jogo e gêneros
    StringBuilder keywords = new StringBuilder(jogo.getString("name"));
    
    if (jogo.has("genres") && !jogo.isNull("genres")) {
        JSONArray genres = jogo.getJSONArray("genres");
        if (genres.length() > 0) {
            keywords.append(", ");
            for (int i = 0; i < genres.length(); i++) {
                JSONObject genre = genres.getJSONObject(i);
                keywords.append(genre.getString("name"));
                if (i < genres.length() - 1) {
                    keywords.append(", ");
                }
            }
        }
    }
    
    request.setAttribute("pageKeywords", keywords.toString());
   }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <jsp:include page="components/head.jsp" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css"/>

    <style>
        body { 
            background: #121212; 
            color: #fff; 
            font-family: 'Segoe UI', sans-serif; 
        }

        .container { 
            max-width: 1200px; 
            margin: 40px auto; 
            padding: 0 20px;
        }

        .game-content {
            background: #1f1f1f;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            display: grid;
            grid-template-columns: 1fr;
            gap: 30px;
        }

        .game-header { 
            display: grid;
            grid-template-columns: minmax(400px, 1fr) 1fr;
            gap: 30px;
        }

        @media (max-width: 968px) {
            .game-header {
                grid-template-columns: 1fr;
            }
        }

        .game-cover { 
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            aspect-ratio: 16/9;
            height: 100%;
            max-height: 300px;
        }

        .game-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.3s ease;
        }

        .game-cover:hover img {
            transform: scale(1.05);
        }

        .game-info { 
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .game-title-container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 15px;
            flex-wrap: wrap;
        }

        .game-title { 
            font-size: clamp(1.5em, 3vw, 2em);
            color: #f1c40f;
            margin: 0;
            font-weight: 700;
            line-height: 1.2;
            word-break: break-word;
            flex: 1;
            min-width: 200px;
        }

        .game-meta-grid {
            display: grid;
            grid-template-areas: 
                "platforms platforms genres"
                "launch metacritic website";
            gap: 15px;
            background: #2a2a2a;
            border-radius: 10px;
        }

        .meta-platforms {
            grid-area: platforms;
        }

        .meta-genres {
            grid-area: genres;
        }

        .meta-launch {
            grid-area: launch;
        }

        .meta-metacritic {
            grid-area: metacritic;
        }

        .meta-website {
            grid-area: website;
        }

        .meta-item {
            background: #2a2a2a;
            padding: 15px;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        @media (max-width: 600px) {
            .game-meta-grid {
                grid-template-areas: 
                    "platforms"
                    "genres"
                    "launch"
                    "metacritic"
                    "website";
            }
        }

        .game-description {
            background: #2a2a2a;
            padding: 25px;
            border-radius: 10px;
            line-height: 1.6;
            width: 100%;
        }

        .game-description h2 {
            color: #f1c40f;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 1.3em;
        }

        .platforms-list, .genres-list {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin: -2px;
        }

        .platform-tag, .genre-tag {
            background: #1f1f1f;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
            margin: 2px;
            white-space: nowrap;
        }

        .gallery-section {
            width: 100%;
        }

        .gallery-title {
            color: #f1c40f;
            font-size: 1.3em;
            margin-bottom: 20px;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            width: 100%;
        }

        .gallery-item {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            aspect-ratio: 16/9;
        }

        .gallery-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .gallery-item:hover img {
            transform: scale(1.05);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            color: #f1c40f;
            text-decoration: none;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: #2a2a2a;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .back-link i {
            margin-right: 10px;
        }

        .back-link:hover {
            background: #f1c40f;
            color: #000;
            transform: translateX(-5px);
        }

        .favorite-btn {
            background-color: #2a2a2a;
            border: none;
            border-radius: 25px;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            color: white;
        }

        .favorite-btn i {
            font-size: 1.2em;
            transition: all 0.3s;
        }

        .favorite-btn:hover {
            background-color: #f1c40f;
            color: #000;
        }

        .favorite-btn.active {
            background-color: #f1c40f;
            color: #000;
        }

        .website-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f1c40f;
            color: #000;
            padding: 8px 15px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9em;
            transition: all 0.3s ease;
        }

        .website-btn:hover {
            background: #f39c12;
            transform: translateY(-2px);
        }

        .website-btn i {
            font-size: 1.2em;
        }

        #avaliacao-usuario {
            background: #2a2a2a;
            padding: 25px;
            border-radius: 10px;
            width: 100%;
        }

        .rating-badge {
            background: #f1c40f;
            color: #000;
            padding: 3px 10px;
            border-radius: 12px;
            font-weight: bold;
            display: inline-block;
            font-size: 0.9em;
        }

        .user-rating {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .user-rating-header {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-rating-content {
            display: grid;
            gap: 10px;
        }

        .user-comment {
            background: #1f1f1f;
            padding: 15px;
            border-radius: 8px;
        }

        .meta-label {
            color: #f1c40f;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .meta-value {
            color: #fff;
            font-size: 1em;
        }

        .meta-platforms, .meta-genres, .meta-launch, .meta-metacritic, .meta-website {
            background: #2a2a2a;
            padding: 15px;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <main>
        <div class="container">
            <a href="#" class="back-link" onclick="history.back(); return false;">
                <i class="fas fa-arrow-left"></i> Voltar
            </a>
            
            <% if (jogo != null) { %>
            <div class="game-content">
                <div class="game-header">
                    <div class="game-cover">
                        <img src="<%= jogo.has("background_image") ? jogo.getString("background_image") : "assets/img/default-game.png" %>" 
                             alt="<%= jogo.getString("name") %>">
                    </div>
                    <div class="game-info">
                        <div class="game-title-container">
                            <h1 class="game-title"><%= jogo.getString("name") %></h1>
                            <% if (session.getAttribute("usuario") != null) { %>
                                <% 
                                    String nomeJogo = jogo.getString("name").replace("'", "\\'");
                                    String imagemJogo = (jogo.has("background_image") ? jogo.getString("background_image") : "assets/img/default-game.png").replace("'", "\\'");
                                    String dataLancamento = DateUtil.formatarDataBrasileira(jogo.optString("released", "")).replace("'", "\\'");
                                    String nota = (jogo.has("metacritic") && !jogo.isNull("metacritic")) ? String.valueOf(jogo.getInt("metacritic")) : "";
                                %>
                                <button class="favorite-btn"
                                    data-id="<%= jogo.getInt("id") %>"
                                    data-nome="<%= nomeJogo %>"
                                    data-imagem="<%= imagemJogo %>"
                                    data-lancamento="<%= dataLancamento %>"
                                    data-nota="<%= nota %>"
                                    onclick="toggleFavorito(<%= jogo.getInt("id") %>, this)">
                                    <i class="far fa-heart"></i>
                                    <span>Favoritar</span>
                                </button>
                            <% } %>
                        </div>

                        <div class="game-meta-grid">
                            <div class="meta-platforms">
                                <span class="meta-label">Plataformas</span>
                                <div class="platforms-list">
                                    <% JSONArray plats = jogo.getJSONArray("platforms");
                                       for (int p = 0; p < plats.length(); p++) { %>
                                        <span class="platform-tag">
                                            <%= plats.getJSONObject(p).getJSONObject("platform").getString("name") %>
                                        </span>
                                    <% } %>
                                </div>
                            </div>
                            <div class="meta-genres">
                                <span class="meta-label">Gêneros</span>
                                <div class="genres-list">
                                    <% JSONArray gens = jogo.getJSONArray("genres");
                                       for (int g = 0; g < gens.length(); g++) { %>
                                        <span class="genre-tag">
                                            <%= gens.getJSONObject(g).getString("name") %>
                                        </span>
                                    <% } %>
                                </div>
                            </div>
                            <div class="meta-launch">
                                <span class="meta-label">Lançamento</span>
                                <span class="meta-value"><%= DateUtil.formatarDataBrasileira(jogo.optString("released", "N/A")) %></span>
                            </div>
                            <% if (jogo.has("metacritic") && !jogo.isNull("metacritic")) { %>
                            <div class="meta-metacritic">
                                <span class="meta-label">Nota</span>
                                <span class="meta-value">
                                    <span class="rating-badge"><%= jogo.getInt("metacritic") %></span>
                                </span>
                            </div>
                            <% } %>
                            <% if (jogo.has("website") && !jogo.getString("website").isEmpty()) { %>
                            <div class="meta-website">
                                <span class="meta-label">Site Oficial</span>
                                <a href="<%= jogo.getString("website") %>" target="_blank" class="website-btn">
                                    <i class="fas fa-external-link-alt"></i>
                                    Visitar
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="game-description">
                    <h2>Descrição</h2>
                    <div><%= jogo.has("description_raw") ? jogo.getString("description_raw") : "Sem descrição disponível." %></div>
                </div>

                <%-- Galeria de Screenshots --%>
                <% 
                JSONArray screenshots = (JSONArray) request.getAttribute("screenshots");
                if (screenshots != null && screenshots.length() > 0) { 
                %>
                <div class="gallery-section">
                    <h2 class="gallery-title">Galeria</h2>
                    <div class="gallery-grid">
                        <% for (int i = 0; i < screenshots.length(); i++) { 
                            JSONObject screenshot = screenshots.getJSONObject(i);
                        %>
                            <a href="<%= screenshot.getString("image") %>" 
                               class="gallery-item" 
                               data-fancybox="gallery"
                               data-caption="Screenshot <%= i + 1 %> - <%= jogo.getString("name") %>">
                                <img src="<%= screenshot.getString("image") %>" 
                                     alt="Screenshot <%= i + 1 %> - <%= jogo.getString("name") %>">
                            </a>
                        <% } %>
                    </div>
                </div>
                <% } %>

                <%-- Avaliação do Usuário (só aparece se estiver logado e tiver avaliação) --%>
                <% if (session.getAttribute("usuario") != null) { %>
                    <div id="avaliacao-usuario" style="display: none;"></div>
                <% } %>
            </div>
            <% } else { %>
                <div class="game-content">
                    <p>Jogo não encontrado.</p>
                </div>
            <% } %>
        </div>
    </main>

    <jsp:include page="components/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js"></script>
    <script src="assets/js/alert.js"></script>
    <script>
        Fancybox.bind("[data-fancybox]", {
            // Custom options
        });

        function toggleFavorito(jogoId, button) {
            const isActive = button.classList.contains('active');
            fetch('favorito?action=' + (isActive ? 'remover' : 'adicionar') + '&jogoId=' + jogoId, {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    button.classList.toggle('active');
                    const icon = button.querySelector('i');
                    const text = button.querySelector('span');
                    if (isActive) {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                        text.textContent = 'Favoritar';
                        showSuccess('Sucesso', 'Jogo removido dos favoritos');
                    } else {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                        text.textContent = 'Favoritado';
                        showSuccess('Sucesso', 'Jogo adicionado aos favoritos');
                    }
                } else {
                    showError('Erro', 'Não foi possível ' + (isActive ? 'remover dos' : 'adicionar aos') + ' favoritos');
                }
            }).catch(error => {
                console.error('Erro:', error);
                showError('Erro', 'Não foi possível processar a requisição');
            });
        }

        // Verifica o estado inicial do favorito
        window.onload = function() {
            const btn = document.querySelector('.favorite-btn');
            if (btn) {
                const jogoId = btn.dataset.id;
                fetch('favorito/check?jogoId=' + jogoId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.isFavorito) {
                            btn.classList.add('active');
                            btn.querySelector('i').classList.remove('far');
                            btn.querySelector('i').classList.add('fas');
                            btn.querySelector('span').textContent = 'Favoritado';
                        }
                    })
                    .catch(error => console.error('Erro:', error));
            }
        };

        // Exibir avaliação do usuário apenas se estiver logado e tiver avaliação
        document.addEventListener('DOMContentLoaded', function() {
            const avaliacaoDiv = document.getElementById('avaliacao-usuario');
            if (avaliacaoDiv) {
                const urlParams = new URLSearchParams(window.location.search);
                const jogoId = urlParams.get('id');
                if (jogoId) {
                    fetch('avaliacao?jogoId=' + jogoId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.nota !== null && data.nota !== undefined) {
                                let html = '<div class="user-rating">';
                                html += '<div class="user-rating-header" style="display: block;">';
                                html += '<h2 class="gallery-title">Sua avaliação</h2>';
                                html += '<div class="meta-metacritic" style="padding: 0px;"><span class="meta-label">Nota</span><span class="meta-value"><span class="rating-badge">' + data.nota + '</span></span></div>';
                                html += '</div>';
                                if (data.comentario && data.comentario.length > 0) {
                                    html += '<div class="user-rating-content">';
                                    html += '<span class="meta-label">Comentário</span><div class="user-comment">' + data.comentario.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</div>';
                                    html += '</div>';
                                }
                                html += '</div>';
                                avaliacaoDiv.innerHTML = html;
                                avaliacaoDiv.style.display = 'block';
                            }
                        })
                        .catch(error => {
                            console.error('Erro ao carregar avaliação:', error);
                        });
                }
            }
        });

        var nomeUsuario = '<%= nomeUsuario %>';
    </script>
</body>
</html> 