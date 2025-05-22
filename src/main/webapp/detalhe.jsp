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
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Jogo</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.4.2/mdb.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
    </style>
</head>
<body>
    <div class="container">
        <a href="jogos" class="back-link"><i class="fas fa-arrow-left"></i> Voltar para Jogos</a>
        <% if (jogo != null) { %>
            <div class="game-header">
                <img src="<%= jogo.has("background_image") ? jogo.getString("background_image") : "assets/img/default-game.png" %>" alt="<%= jogo.getString("name") %>">
                <div class="game-info">
                    <div class="game-title"><%= jogo.getString("name") %></div>
                    <div class="game-meta">
                        <p>Lançamento: <%= jogo.optString("released", "N/A") %></p>
                        <% if (jogo.has("metacritic")) { %>
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
        <% } else { %>
            <p>Jogo não encontrado.</p>
        <% } %>
    </div>
</body>
</html> 