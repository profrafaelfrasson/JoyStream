package com.joystream.service;

import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import com.joystream.dao.DBConfig;
import com.joystream.model.Jogo;

public class JogoService {
    private static final String API_KEY = "5c0f001717fe48498900310b7ca4aa41";
    private static final String API_BASE_URL = "https://api.rawg.io/api/games";
    
    public List<Jogo> buscarJogosDestaque() {
        List<Jogo> jogos = new ArrayList<>();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpGet request = new HttpGet(API_BASE_URL + "?key=" + API_KEY + "&ordering=-rating&page_size=5&metacritic=80,100");
            request.setHeader("Accept", "application/json");

            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() == 200) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    JSONObject json = new JSONObject(jsonResponse);
                    JSONArray results = json.getJSONArray("results");

                    for (int i = 0; i < results.length(); i++) {
                        JSONObject gameJson = results.getJSONObject(i);
                        Jogo jogo = new Jogo();

                        jogo.setId(gameJson.getLong("id"));
                        jogo.setNome(gameJson.getString("name"));
                        jogo.setDescricao(gameJson.optString("description_raw", "Já disponível"));
                        String imagemUrl = gameJson.optString("background_image", "/assets/img/game1.jpg");
                        jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");
                        jogo.setDestaque(true);

                        // Adicionar gêneros
                        if (gameJson.has("genres")) {
                            JSONArray generos = gameJson.getJSONArray("genres");
                            List<String> generosList = new ArrayList<>();
                            for (int j = 0; j < generos.length(); j++) {
                                generosList.add(generos.getJSONObject(j).getString("name"));
                            }
                            jogo.setGeneros(String.join(", ", generosList));
                        }

                        // Adicionar plataformas
                        if (gameJson.has("platforms")) {
                            JSONArray plataformas = gameJson.getJSONArray("platforms");
                            List<String> plataformasList = new ArrayList<>();
                            for (int j = 0; j < plataformas.length(); j++) {
                                plataformasList.add(plataformas.getJSONObject(j).getJSONObject("platform").getString("name"));
                            }
                            jogo.setPlataformas(String.join(", ", plataformasList));
                        }

                        // Adicionar nota Metacritic
                        if (gameJson.has("metacritic")) {
                            jogo.setNota(gameJson.getDouble("metacritic"));
                        }

                        // Adicionar data de lançamento
                        if (gameJson.has("released")) {
                            jogo.setDataLancamento(gameJson.getString("released"));
                        }

                        // Buscar screenshots
                        List<String> screenshots = buscarScreenshots(gameJson.getLong("id"));
                        jogo.setScreenshots(screenshots);

                        jogos.add(jogo);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jogos;
    }

    private List<String> buscarScreenshots(Long gameId) {
        List<String> screenshots = new ArrayList<>();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            String url = API_BASE_URL + "/" + gameId + "/screenshots?key=" + API_KEY;
            HttpGet request = new HttpGet(url);
            request.setHeader("Accept", "application/json");

            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() == 200) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    JSONObject json = new JSONObject(jsonResponse);
                    JSONArray results = json.getJSONArray("results");
                    for (int i = 0; i < results.length() && i < 4; i++) {
                        JSONObject shot = results.getJSONObject(i);
                        screenshots.add(shot.getString("image"));
                    }
                }
            }
        } catch (Exception e) {
            // Se der erro, só retorna vazio
        }
        return screenshots;
    }

    public List<Jogo> buscarJogosRecomendados(int usuarioId) {
        List<Jogo> recomendacoes = new ArrayList<>();
        System.out.println("Iniciando busca de recomendações para usuário ID: " + usuarioId);
        
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            // 1. Primeiro, buscar os IDs dos jogos favoritos do usuário
            String sql = "SELECT id_jogo FROM favorito WHERE id_usuario = ?";
            
            System.out.println("SQL para buscar favoritos: " + sql);
            
            // Conectar ao banco e buscar os dados
            try (Connection conn = DBConfig.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, usuarioId);
                ResultSet rs = stmt.executeQuery();
                
                List<Integer> jogosFavoritos = new ArrayList<>();
                while (rs.next()) {
                    int jogoId = rs.getInt("id_jogo");
                    jogosFavoritos.add(jogoId);
                    System.out.println("Jogo favorito encontrado: ID=" + jogoId);
                }

                System.out.println("Total de jogos favoritos encontrados: " + jogosFavoritos.size());

                if (!jogosFavoritos.isEmpty()) {
                    // Buscar detalhes dos jogos favoritos da API RAWG
                    List<String> todosGeneros = new ArrayList<>();
                    List<String> todasPlataformas = new ArrayList<>();

                    for (Integer jogoId : jogosFavoritos) {
                        String detalhesUrl = API_BASE_URL + "/" + jogoId + "?key=" + API_KEY;
                        System.out.println("Buscando detalhes do jogo na API: " + detalhesUrl);
                        
                        HttpGet request = new HttpGet(detalhesUrl);
                        request.setHeader("Accept", "application/json");

                        try (CloseableHttpResponse response = client.execute(request)) {
                            String jsonResponse = EntityUtils.toString(response.getEntity());
                            JSONObject jogoJson = new JSONObject(jsonResponse);

                            // Coletar gêneros
                            if (jogoJson.has("genres")) {
                                JSONArray generos = jogoJson.getJSONArray("genres");
                                for (int i = 0; i < generos.length(); i++) {
                                    String generoId = String.valueOf(generos.getJSONObject(i).getInt("id"));
                                    todosGeneros.add(generoId);
                                    System.out.println("Gênero encontrado: " + generoId);
                                }
                            }

                            // Coletar plataformas
                            if (jogoJson.has("platforms")) {
                                JSONArray plataformas = jogoJson.getJSONArray("platforms");
                                for (int i = 0; i < plataformas.length(); i++) {
                                    String plataformaId = String.valueOf(plataformas.getJSONObject(i).getJSONObject("platform").getInt("id"));
                                    todasPlataformas.add(plataformaId);
                                    System.out.println("Plataforma encontrada: " + plataformaId);
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Erro ao buscar detalhes do jogo " + jogoId + ": " + e.getMessage());
                            continue;
                        }
                    }

                    // Encontrar os gêneros e plataformas mais frequentes
                    String generosFrequentes = todosGeneros.stream()
                        .collect(Collectors.groupingBy(g -> g, Collectors.counting()))
                        .entrySet().stream()
                        .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                        .limit(3)
                        .map(e -> e.getKey())
                        .collect(Collectors.joining(","));
                    
                    String plataformasFrequentes = todasPlataformas.stream()
                        .collect(Collectors.groupingBy(p -> p, Collectors.counting()))
                        .entrySet().stream()
                        .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                        .limit(2)
                        .map(e -> e.getKey())
                        .collect(Collectors.joining(","));
                    
                    System.out.println("Gêneros mais frequentes: " + generosFrequentes);
                    System.out.println("Plataformas mais frequentes: " + plataformasFrequentes);

                    // 2. Buscar jogos similares usando a API RAWG
                    if (!generosFrequentes.isEmpty() || !plataformasFrequentes.isEmpty()) {
                        StringBuilder apiUrl = new StringBuilder(API_BASE_URL + "?key=" + API_KEY);
                        apiUrl.append("&ordering=-rating");
                        apiUrl.append("&page_size=6");
                        apiUrl.append("&metacritic=75,100");
                        
                        if (!generosFrequentes.isEmpty()) {
                            apiUrl.append("&genres=").append(URLEncoder.encode(generosFrequentes, "UTF-8"));
                        }
                        if (!plataformasFrequentes.isEmpty()) {
                            apiUrl.append("&platforms=").append(URLEncoder.encode(plataformasFrequentes, "UTF-8"));
                        }
                        
                        // Excluir jogos que já estão nos favoritos
                        String jogosFavoritosStr = jogosFavoritos.stream()
                            .map(String::valueOf)
                            .collect(Collectors.joining(","));
                        
                        if (!jogosFavoritosStr.isEmpty()) {
                            apiUrl.append("&exclude=").append(jogosFavoritosStr);
                        }
                        
                        System.out.println("URL da API para recomendações: " + apiUrl.toString());
                        
                        HttpGet request = new HttpGet(apiUrl.toString());
                        request.setHeader("Accept", "application/json");
                        
                        try (CloseableHttpResponse response = client.execute(request)) {
                            String jsonResponse = EntityUtils.toString(response.getEntity());
                            JSONObject jsonObject = new JSONObject(jsonResponse);
                            JSONArray results = jsonObject.getJSONArray("results");
                            
                            System.out.println("Número de jogos recomendados encontrados: " + results.length());
                            
                            for (int i = 0; i < results.length(); i++) {
                                JSONObject jogoJson = results.getJSONObject(i);
                                Jogo jogo = new Jogo();
                                jogo.setId(Long.valueOf(jogoJson.getInt("id")));
                                jogo.setNome(jogoJson.getString("name"));
                                if (jogoJson.has("background_image")) {
                                    jogo.setImagemUrl(jogoJson.getString("background_image"));
                                }
                                recomendacoes.add(jogo);
                                System.out.println("Jogo recomendado adicionado: " + jogo.getNome());
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao buscar recomendações: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("Total de recomendações retornadas: " + recomendacoes.size());
        return recomendacoes;
    }
} 