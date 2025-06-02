package com.joystream.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
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
    private static final long CACHE_EXPIRATION_MS = 60 * 60 * 1000; // 1 hora

    // Cache para recomendações por usuário
    private static final Map<Integer, CacheEntry> recomendacoesCache = new HashMap<>();
    // Cache global para destaques
    private static CacheEntry destaquesCache = null;

    private static class CacheEntry {
        List<Jogo> jogos;
        long timestamp;
        CacheEntry(List<Jogo> jogos, long timestamp) {
            this.jogos = jogos;
            this.timestamp = timestamp;
        }
    }

    public List<Jogo> buscarJogosDestaque() {
        long now = System.currentTimeMillis();
        if (destaquesCache != null && (now - destaquesCache.timestamp) < CACHE_EXPIRATION_MS) {
            return randomizarJogos(destaquesCache.jogos, 6);
        }
        List<Jogo> jogos = new ArrayList<>();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            // Buscar jogos lançados no último ano, sem filtro de nota
            LocalDate hoje = LocalDate.now();
            LocalDate umAnoAtras = hoje.minus(1, ChronoUnit.YEARS);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String dataInicio = umAnoAtras.format(formatter);
            String dataFim = hoje.format(formatter);
            String urlApi = API_BASE_URL + "?key=" + API_KEY + "&ordering=-rating&page_size=40&dates=" + dataInicio + "," + dataFim;
            HttpGet request = new HttpGet(urlApi);
            request.setHeader("Accept", "application/json");

            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() == 200) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    JSONObject json = new JSONObject(jsonResponse);
                    JSONArray results = json.getJSONArray("results");
                    for (int i = 0; i < results.length(); i++) {
                        JSONObject gameJson = results.getJSONObject(i);
                        // Filtrar para garantir que só jogos já lançados (data <= hoje)
                        if (gameJson.has("released") && !gameJson.isNull("released")) {
                            String dataLancamentoStr = gameJson.getString("released");
                            try {
                                LocalDate dataLancamento = LocalDate.parse(dataLancamentoStr, formatter);
                                if (dataLancamento.isAfter(hoje)) {
                                    continue; // Pula jogos ainda não lançados
                                }
                            } catch (Exception e) {
                                continue;
                            }
                        } else {
                            continue;
                        }
                        Jogo jogo = new Jogo();
                        jogo.setId(gameJson.getLong("id"));
                        jogo.setNome(gameJson.getString("name"));
                        jogo.setDescricao(gameJson.optString("description_raw", "Já disponível"));
                        String imagemUrl = gameJson.optString("background_image", "/assets/img/game1.jpg");
                        jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");
                        jogo.setDestaque(true);
                        if (gameJson.has("genres")) {
                            JSONArray generos = gameJson.getJSONArray("genres");
                            List<String> generosList = new ArrayList<>();
                            for (int j = 0; j < generos.length(); j++) {
                                generosList.add(generos.getJSONObject(j).getString("name"));
                            }
                            jogo.setGeneros(String.join(", ", generosList));
                        }
                        if (gameJson.has("platforms")) {
                            JSONArray plataformas = gameJson.getJSONArray("platforms");
                            List<String> plataformasList = new ArrayList<>();
                            for (int j = 0; j < plataformas.length(); j++) {
                                plataformasList.add(plataformas.getJSONObject(j).getJSONObject("platform").getString("name"));
                            }
                            jogo.setPlataformas(String.join(", ", plataformasList));
                        }
                        if (gameJson.has("metacritic") && !gameJson.isNull("metacritic")) {
                            jogo.setNota(gameJson.getDouble("metacritic"));
                        }
                        if (gameJson.has("released")) {
                            jogo.setDataLancamento(gameJson.getString("released"));
                        }
                        List<String> screenshots = buscarScreenshots(gameJson.getLong("id"));
                        jogo.setScreenshots(screenshots);
                        jogos.add(jogo);
                    }
                }
            }
        } catch (Exception e) {
        }
        // Filtro para destaques
        jogos = jogos.stream().filter(j -> !isConteudoSexualExplicito(j)).collect(Collectors.toList());
        destaquesCache = new CacheEntry(jogos, now);
        return randomizarJogos(jogos, 6);
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
        long now = System.currentTimeMillis();
        CacheEntry cache = recomendacoesCache.get(usuarioId);
        if (cache != null && (now - cache.timestamp) < CACHE_EXPIRATION_MS) {
            return randomizarJogos(cache.jogos, 6);
        }
        List<Jogo> recomendacoes = new ArrayList<>();
        System.out.println("Iniciando busca de recomendações para usuário ID: " + usuarioId);
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            // Buscar IDs dos jogos favoritos do usuário
            String sql = "SELECT id_jogo FROM favorito WHERE id_usuario = ?";
            try (Connection conn = DBConfig.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, usuarioId);
                ResultSet rs = stmt.executeQuery();
                List<Integer> jogosFavoritos = new ArrayList<>();
                while (rs.next()) {
                    int jogoId = rs.getInt("id_jogo");
                    jogosFavoritos.add(jogoId);
                }
                if (!jogosFavoritos.isEmpty()) {
                    // Buscar detalhes dos jogos favoritos da API RAWG
                    List<String> todosGeneros = new ArrayList<>();
                    List<String> todasPlataformas = new ArrayList<>();
                    for (Integer jogoId : jogosFavoritos) {
                        String detalhesUrl = API_BASE_URL + "/" + jogoId + "?key=" + API_KEY;
                        HttpGet request = new HttpGet(detalhesUrl);
                        request.setHeader("Accept", "application/json");
                        try (CloseableHttpResponse response = client.execute(request)) {
                            String jsonResponse = EntityUtils.toString(response.getEntity());
                            JSONObject jogoJson = new JSONObject(jsonResponse);
                            if (jogoJson.has("genres")) {
                                JSONArray generos = jogoJson.getJSONArray("genres");
                                for (int i = 0; i < generos.length(); i++) {
                                    String generoId = String.valueOf(generos.getJSONObject(i).getInt("id"));
                                    todosGeneros.add(generoId);
                                }
                            }
                            if (jogoJson.has("platforms")) {
                                JSONArray plataformas = jogoJson.getJSONArray("platforms");
                                for (int i = 0; i < plataformas.length(); i++) {
                                    String plataformaId = String.valueOf(plataformas.getJSONObject(i).getJSONObject("platform").getInt("id"));
                                    todasPlataformas.add(plataformaId);
                                }
                            }
                        } catch (Exception e) {
                        }
                    }
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
                    // Buscar jogos similares com nota > 60
                    StringBuilder apiUrl = new StringBuilder(API_BASE_URL + "?key=" + API_KEY);
                    apiUrl.append("&ordering=-rating");
                    apiUrl.append("&page_size=20");
                    apiUrl.append("&metacritic=61,100");
                    if (!generosFrequentes.isEmpty()) {
                        apiUrl.append("&genres=").append(generosFrequentes);
                    }
                    if (!plataformasFrequentes.isEmpty()) {
                        apiUrl.append("&platforms=").append(plataformasFrequentes);
                    }
                    String jogosFavoritosStr = jogosFavoritos.stream()
                        .map(String::valueOf)
                        .collect(Collectors.joining(","));
                    if (!jogosFavoritosStr.isEmpty()) {
                        apiUrl.append("&exclude=").append(jogosFavoritosStr);
                    }
                    HttpGet request = new HttpGet(apiUrl.toString());
                    request.setHeader("Accept", "application/json");
                    try (CloseableHttpResponse response = client.execute(request)) {
                        String jsonResponse = EntityUtils.toString(response.getEntity());
                        JSONObject jsonObject = new JSONObject(jsonResponse);
                        JSONArray results = jsonObject.getJSONArray("results");
                        for (int i = 0; i < results.length(); i++) {
                            JSONObject jogoJson = results.getJSONObject(i);
                            if (jogoJson.has("metacritic") && !jogoJson.isNull("metacritic") && jogoJson.getDouble("metacritic") > 60) {
                                Jogo jogo = new Jogo();
                                jogo.setId(Long.valueOf(jogoJson.getInt("id")));
                                jogo.setNome(jogoJson.getString("name"));
                                if (jogoJson.has("background_image")) {
                                    jogo.setImagemUrl(jogoJson.getString("background_image"));
                                }
                                jogo.setNota(jogoJson.getDouble("metacritic"));
                                recomendacoes.add(jogo);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao buscar recomendações: " + e.getMessage());
        }
        // Filtro para recomendações
        recomendacoes = recomendacoes.stream().filter(j -> !isConteudoSexualExplicito(j)).collect(Collectors.toList());
        recomendacoesCache.put(usuarioId, new CacheEntry(recomendacoes, now));
        return randomizarJogos(recomendacoes, 6);
    }

    private List<Jogo> randomizarJogos(List<Jogo> lista, int quantidade) {
        if (lista == null || lista.isEmpty()) return Collections.emptyList();
        List<Jogo> copia = new ArrayList<>(lista);
        Collections.shuffle(copia, new Random());
        return copia.subList(0, Math.min(quantidade, copia.size()));
    }

    // Adicionar metodo auxiliar para filtrar jogos com conteúdo sexual explícito
    private boolean isConteudoSexualExplicito(Jogo jogo) {
        String[] termosProibidos = {"porn", "sexual", "erotic", "adult", "nsfw", "hentai", "explicit"};
        String generos = jogo.getGeneros() != null ? jogo.getGeneros().toLowerCase() : "";
        String descricao = jogo.getDescricao() != null ? jogo.getDescricao().toLowerCase() : "";
        for (String termo : termosProibidos) {
            if (generos.contains(termo) || descricao.contains(termo)) {
                return true;
            }
        }
        return false;
    }
} 