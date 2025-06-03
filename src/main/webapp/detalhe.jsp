<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.*" %>
<%
    String id = request.getParameter("id");
    String apiKey = "5c0f001717fe48498900310b7ca4aa41";
    JSONObject jogo = null;
    if (id != null && !id.isEmpty()) {
        try {
            URL url = new URL("https://api.rawg.io/api/games/" + id + "?key=" + apiKey);
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
        } catch (Exception e) {
            out.println("<p>Erro ao buscar detalhes do jogo.</p>");
        }
    }

    String nomeUsuario = "";
    if (session.getAttribute("usuario") != null) {
        com.joystream.model.Usuario usuario = (com.joystream.model.Usuario) session.getAttribute("usuario");
        nomeUsuario = usuario.getNmUsuario();
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Jogo</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Sweetalert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body { background: #121212; color: #fff; font-family: 'Segoe UI', sans-serif; }
        .container { max-width: 900px; margin: 40px auto; background: #1f1f1f; border-radius: 10px; padding: 30px; }
        .game-header { display: flex; gap: 30px; align-items: flex-start; }
        .game-header img { width: 300px; border-radius: 10px; }
        .game-info { flex: 1; }
        .game-title { font-size: 2em; color: #f1c40f; margin-bottom: 10px; }
        .game-meta { color: #aaa; margin-bottom: 10px; }
        .game-description { margin-top: 20px; }
        .back-link { color: #f1c40f; text-decoration: none; margin-bottom: 20px; display: inline-block; }
        .back-link:hover { text-decoration: underline; }
        
        .favorite-btn {
            background-color: rgba(0, 0, 0, 0.5);
            border: none;
            border-radius: 50%;
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            margin-left: 10px;
        }

        .favorite-btn i {
            color: white;
            font-size: 1.2em;
            transition: all 0.3s;
        }

        .favorite-btn:hover {
            background-color: rgba(241, 196, 15, 0.8);
        }

        .favorite-btn.active {
            background-color: rgba(241, 196, 15, 0.8);
        }

        .favorite-btn.active i {
            color: #fff;
        }

        .title-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="#" class="back-link" onclick="history.back(); return false;"><i class="fas fa-arrow-left"></i> Voltar</a>
        <% if (jogo != null) { %>
            <div class="game-header">
                <img src="<%= jogo.has("background_image") ? jogo.getString("background_image") : "assets/img/default-game.png" %>" alt="<%= jogo.getString("name") %>">
                <div class="game-info">
                    <div class="title-container">
                        <div class="game-title"><%= jogo.getString("name") %></div>
                        <% if (session.getAttribute("usuario") != null) { %>
                            <% 
                                String nomeJogo = jogo.getString("name").replace("'", "\\'");
                                String imagemJogo = (jogo.has("background_image") ? jogo.getString("background_image") : "assets/img/default-game.png").replace("'", "\\'");
                                String dataLancamento = jogo.optString("released", "").replace("'", "\\'");
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
                            </button>
                        <% } %>
                    </div>
                    <div class="game-meta">
                        <p>Lançamento: <%= jogo.optString("released", "N/A") %></p>
                        <% if (jogo.has("metacritic") && !jogo.isNull("metacritic")) { %>
                            <p>Nota: <%= jogo.getInt("metacritic") %></p>
                        <% } %>
                        <% if (jogo.has("platforms")) { %>
                            <p>Plataformas: 
                                <% JSONArray plats = jogo.getJSONArray("platforms");
                                   for (int p = 0; p < plats.length(); p++) { %>
                                    <%= plats.getJSONObject(p).getJSONObject("platform").getString("name") %><%= p < plats.length() - 1 ? ", " : "" %>
                                <% } %>
                            </p>
                        <% } %>
                        <% if (jogo.has("genres")) { %>
                            <p>Gêneros: 
                                <% JSONArray gens = jogo.getJSONArray("genres");
                                   for (int g = 0; g < gens.length(); g++) { %>
                                    <%= gens.getJSONObject(g).getString("name") %><%= g < gens.length() - 1 ? ", " : "" %>
                                <% } %>
                            </p>
                        <% } %>
                        <% if (jogo.has("website") && !jogo.getString("website").isEmpty()) { %>
                            <p><a href="<%= jogo.getString("website") %>" target="_blank" style="color:#f1c40f;">Site Oficial</a></p>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="game-description">
                <h4>Descrição</h4>
                <div><%= jogo.has("description_raw") ? jogo.getString("description_raw") : "Sem descrição disponível." %></div>
            </div>
            <%-- Galeria de screenshots --%>
            <% if (jogo.has("short_screenshots")) { JSONArray shots = jogo.getJSONArray("short_screenshots"); if (shots.length() > 1) { %>
                <div style="margin-top:30px;">
                    <h4>Screenshots</h4>
                    <div style="display:flex;gap:15px;flex-wrap:wrap;">
                        <% for (int s = 1; s < shots.length(); s++) { %>
                            <img src="<%= shots.getJSONObject(s).getString("image") %>" alt="Screenshot" style="width:180px;border-radius:8px;">
                        <% } %>
                    </div>
                </div>
            <% } } %>
            <%-- Trailer do YouTube --%>
            <% if (jogo.has("clip") && !jogo.isNull("clip")) { JSONObject clip = jogo.getJSONObject("clip"); if (clip.has("video")) { %>
                <div style="margin-top:30px;">
                    <h4>Trailer</h4>
                    <video controls style="width:100%;max-width:600px;border-radius:8px;">
                        <source src="<%= clip.getString("video") %>" type="video/mp4">
                        Seu navegador não suporta vídeo.
                    </video>
                </div>
            <% } } %>
            <%-- Exibir avaliações do usuário (localStorage) --%>
            <div id="avaliacao-usuario" style="margin-top:40px;"></div>
        <% } else { %>
            <p>Jogo não encontrado.</p>
        <% } %>
    </div>
    <script src="assets/js/alert.js"></script>
    <script>
        function toggleFavorito(jogoId, button) {
            const isActive = button.classList.contains('active');
            fetch('favorito?action=' + (isActive ? 'remover' : 'adicionar') + '&jogoId=' + jogoId, {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    button.classList.toggle('active');
                    const icon = button.querySelector('i');
                    if (isActive) {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                        showSuccess('Sucesso', 'Jogo removido dos favoritos');
                    } else {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
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
                        }
                    })
                    .catch(error => console.error('Erro:', error));
            }
        };

        // Exibir avaliação do usuário (localStorage)
        document.addEventListener('DOMContentLoaded', function() {
            // Pega o id do jogo da URL
            const urlParams = new URLSearchParams(window.location.search);
            const jogoId = urlParams.get('id');
            if (jogoId) {
                const comentario = localStorage.getItem('analise_' + jogoId);
                const nota = localStorage.getItem('nota_' + jogoId);
                if ((comentario && comentario.length > 0) || (nota && nota.length > 0)) {
                    let html = '<div style="background:#222;padding:20px;border-radius:8px;margin-top:30px;">';
                    html += '<h4 style="color:#f1c40f;margin-bottom:10px;">Sua avaliação:</h4>';
                    html += '<div style="margin-bottom:8px;"><b>' + nomeUsuario + '</b></div>';
                    if (nota && nota.length > 0) {
                        html += '<div style="font-size:1.2em;margin-bottom:8px;"><b>Nota:</b> <span style="background:#f1c40f;color:#222;padding:4px 12px;border-radius:6px;font-weight:bold;">' + nota + '</span></div>';
                    }
                    if (comentario && comentario.length > 0) {
                        html += '<div style="margin-bottom:4px;"><b>Comentário:</b></div>';
                        html += '<div style="color:#fff;white-space:pre-line;">' + comentario.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</div>';
                    }
                    html += '</div>';
                    document.getElementById('avaliacao-usuario').innerHTML = html;
                }
            }
        });

        var nomeUsuario = "<%= nomeUsuario.replace("\"","\\\"") %>";

    </script>
</body>
</html> 