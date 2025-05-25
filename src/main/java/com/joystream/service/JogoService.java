package com.joystream.service;

import com.joystream.model.Jogo;
import java.util.List;
import java.util.ArrayList;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;

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
                        jogo.setDescricao("Já disponível");
                        String imagemUrl = gameJson.optString("background_image", "/assets/img/game1.jpg");
                        jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");
                        jogo.setDestaque(true);

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
} 