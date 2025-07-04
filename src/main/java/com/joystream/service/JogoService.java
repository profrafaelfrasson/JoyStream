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
import com.joystream.model.Favorito;
import com.joystream.model.Jogo;
import com.joystream.util.DateUtil;
import com.joystream.config.ApiConfig;

public class JogoService {
    private static final String API_BASE_URL = ApiConfig.RAWG_API_BASE_URL;
    private static final long CACHE_EXPIRATION_MS = 60 * 60 * 1000; // 1 hora
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    // Cache para recomendações por usuário
    private static final Map<Integer, CacheEntry> recomendacoesCache = new HashMap<>();
    // Cache global para destaques
    private static CacheEntry destaquesCache = null;
    // Cache para detalhes dos favoritos por usuário
    private static final Map<Integer, CacheEntry> favoritosDetalhesCache = new HashMap<>();

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
            String urlApi = API_BASE_URL + "?key=" + ApiConfig.RAWG_API_KEY + "&ordering=-rating&page_size=20&dates=" + dataInicio + "," + dataFim;
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
                            jogo.setDataLancamento(DateUtil.formatarDataBrasileira(gameJson.getString("released")));
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
            String url = API_BASE_URL + "/" + gameId + "/screenshots?key=" + ApiConfig.RAWG_API_KEY;
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
                        String detalhesUrl = API_BASE_URL + "/" + jogoId + "?key=" + ApiConfig.RAWG_API_KEY;
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
                    StringBuilder apiUrl = new StringBuilder(API_BASE_URL + "?key=" + ApiConfig.RAWG_API_KEY);
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
                            // Garantir que jogos recomendados tenham nota > 60 E estejam lançados (opcional, se a API não garantir)
                            // Se a API já filtrou por metacritic=61,100 e ordering=-rating, a verificação de nota já está feita

                            Jogo jogo = new Jogo();
                            jogo.setId(Long.valueOf(jogoJson.getInt("id")));
                            jogo.setNome(jogoJson.getString("name"));
                            jogo.setDescricao(jogoJson.optString("description_raw", "Já disponível")); // Adicionar descrição
                            String imagemUrl = jogoJson.optString("background_image", "/assets/img/game1.jpg");
                            jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");
                            // jogo.setDestaque(false); // Recomendados não são destaque por padrão
                            
                            if (jogoJson.has("genres")) { // Adicionar gêneros
                                JSONArray generos = jogoJson.getJSONArray("genres");
                                List<String> generosList = new ArrayList<>();
                                for (int j = 0; j < generos.length(); j++) {
                                    generosList.add(generos.getJSONObject(j).getString("name"));
                                }
                                jogo.setGeneros(String.join(", ", generosList));
                            }
                            if (jogoJson.has("platforms")) { // Adicionar plataformas
                                JSONArray plataformas = jogoJson.getJSONArray("platforms");
                                List<String> plataformasList = new ArrayList<>();
                                for (int j = 0; j < plataformas.length(); j++) {
                                    plataformasList.add(plataformas.getJSONObject(j).getJSONObject("platform").getString("name"));
                                }
                                jogo.setPlataformas(String.join(", ", plataformasList));
                            }
                            if (jogoJson.has("metacritic") && !jogoJson.isNull("metacritic")) { // Adicionar nota
                                jogo.setNota(jogoJson.getDouble("metacritic"));
                            } else {
                                jogo.setNota(null); // Definir como null se não houver nota
                            }
                            if (jogoJson.has("released")) {
                                jogo.setDataLancamento(DateUtil.formatarDataBrasileira(jogoJson.getString("released")));
                            }
                            List<String> screenshots = buscarScreenshots(jogoJson.getLong("id")); // Adicionar screenshots
                            jogo.setScreenshots(screenshots);

                            // Verificar filtro de conteúdo sexual ANTES de adicionar à lista
                            if (!isConteudoSexualExplicito(jogo)) {
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

    public List<Jogo> buscarDetalhesJogosFavoritos(List<Favorito> favoritos) {
        if (favoritos == null || favoritos.isEmpty()) return new ArrayList<>();
        int usuarioId = favoritos.get(0).getIdUsuario();
        long now = System.currentTimeMillis();
        CacheEntry cache = favoritosDetalhesCache.get(usuarioId);
        if (cache != null && (now - cache.timestamp) < CACHE_EXPIRATION_MS) {
            return cache.jogos;
        }
        List<Jogo> jogos = new ArrayList<>();
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            for (Favorito favorito : favoritos) {
                try {
                    String detalhesUrl = API_BASE_URL + "/" + favorito.getIdJogo() + "?key=" + ApiConfig.RAWG_API_KEY;
                    HttpGet request = new HttpGet(detalhesUrl);
                    request.setHeader("Accept", "application/json");
                    try (CloseableHttpResponse response = client.execute(request)) {
                        if (response.getStatusLine().getStatusCode() == 200) {
                            String jsonResponse = EntityUtils.toString(response.getEntity());
                            JSONObject jogoJson = new JSONObject(jsonResponse);
                            Jogo jogo = new Jogo();
                            jogo.setId(jogoJson.getLong("id"));
                            jogo.setNome(jogoJson.getString("name"));
                            jogo.setDescricao(jogoJson.optString("description_raw", ""));
                            String imagemUrl = jogoJson.optString("background_image", "/assets/img/game1.jpg");
                            jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");
                            if (jogoJson.has("genres")) {
                                JSONArray generos = jogoJson.getJSONArray("genres");
                                List<String> generosList = new ArrayList<>();
                                for (int j = 0; j < generos.length(); j++) {
                                    generosList.add(generos.getJSONObject(j).getString("name"));
                                }
                                jogo.setGeneros(String.join(", ", generosList));
                            }
                            if (jogoJson.has("platforms")) {
                                JSONArray plataformas = jogoJson.getJSONArray("platforms");
                                List<String> plataformasList = new ArrayList<>();
                                for (int j = 0; j < plataformas.length(); j++) {
                                    plataformasList.add(plataformas.getJSONObject(j).getJSONObject("platform").getString("name"));
                                }
                                jogo.setPlataformas(String.join(", ", plataformasList));
                            }
                            if (jogoJson.has("metacritic") && !jogoJson.isNull("metacritic")) {
                                jogo.setNota(jogoJson.getDouble("metacritic"));
                            }
                            if (jogoJson.has("released")) {
                                jogo.setDataLancamento(DateUtil.formatarDataBrasileira(jogoJson.getString("released")));
                            }
                            List<String> screenshots = buscarScreenshots(jogoJson.getLong("id"));
                            jogo.setScreenshots(screenshots);
                            jogos.add(jogo);
                        }
                    }
                } catch (Exception e) {
                    // Se der erro em um jogo, ignora e segue para o próximo
                }
            }
        } catch (Exception e) {
            // Se der erro geral, retorna o que conseguiu
        }
        favoritosDetalhesCache.put(usuarioId, new CacheEntry(jogos, now));
        return jogos;
    }

    public void invalidarFavoritosDetalhesCache(int usuarioId) {
        favoritosDetalhesCache.remove(usuarioId);
    }

    public void adicionarJogoAoCacheFavoritos(int usuarioId, int jogoId) {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            String detalhesUrl = API_BASE_URL + "/" + jogoId + "?key=" + ApiConfig.RAWG_API_KEY;
            HttpGet request = new HttpGet(detalhesUrl);
            request.setHeader("Accept", "application/json");

            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() == 200) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    JSONObject jogoJson = new JSONObject(jsonResponse);
                    
                    Jogo jogo = new Jogo();
                    jogo.setId(jogoJson.getLong("id"));
                    jogo.setNome(jogoJson.getString("name"));
                    jogo.setDescricao(jogoJson.optString("description_raw", ""));
                    String imagemUrl = jogoJson.optString("background_image", "/assets/img/game1.jpg");
                    jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");
                    
                    if (jogoJson.has("genres")) {
                        JSONArray generos = jogoJson.getJSONArray("genres");
                        List<String> generosList = new ArrayList<>();
                        for (int j = 0; j < generos.length(); j++) {
                            generosList.add(generos.getJSONObject(j).getString("name"));
                        }
                        jogo.setGeneros(String.join(", ", generosList));
                    }
                    
                    if (jogoJson.has("platforms")) {
                        JSONArray plataformas = jogoJson.getJSONArray("platforms");
                        List<String> plataformasList = new ArrayList<>();
                        for (int j = 0; j < plataformas.length(); j++) {
                            plataformasList.add(plataformas.getJSONObject(j).getJSONObject("platform").getString("name"));
                        }
                        jogo.setPlataformas(String.join(", ", plataformasList));
                    }
                    
                    if (jogoJson.has("metacritic") && !jogoJson.isNull("metacritic")) {
                        jogo.setNota(jogoJson.getDouble("metacritic"));
                    }
                    
                    if (jogoJson.has("released")) {
                        jogo.setDataLancamento(DateUtil.formatarDataBrasileira(jogoJson.getString("released")));
                    }
                    
                    List<String> screenshots = buscarScreenshots(jogoJson.getLong("id"));
                    jogo.setScreenshots(screenshots);

                    // Atualizar o cache existente
                    CacheEntry cacheEntry = favoritosDetalhesCache.get(usuarioId);
                    if (cacheEntry != null) {
                        List<Jogo> jogosAtualizados = new ArrayList<>(cacheEntry.jogos);
                        jogosAtualizados.add(jogo);
                        favoritosDetalhesCache.put(usuarioId, new CacheEntry(jogosAtualizados, System.currentTimeMillis()));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao adicionar jogo ao cache: " + e.getMessage());
        }
    }

    public void removerJogoDoCacheFavoritos(int usuarioId, int jogoId) {
        CacheEntry cacheEntry = favoritosDetalhesCache.get(usuarioId);
        if (cacheEntry != null) {
            List<Jogo> jogosAtualizados = cacheEntry.jogos.stream()
                .filter(jogo -> jogo.getId() != jogoId)
                .collect(Collectors.toList());
            
            if (!jogosAtualizados.isEmpty()) {
                favoritosDetalhesCache.put(usuarioId, new CacheEntry(jogosAtualizados, System.currentTimeMillis()));
            } else {
                // Se a lista ficar vazia, remove a entrada do cache
                favoritosDetalhesCache.remove(usuarioId);
            }
        }
    }

    public void atualizarCacheRecomendacoes(int usuarioId, int jogoId) {
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            // Buscar detalhes do novo jogo favorito
            String detalhesUrl = API_BASE_URL + "/" + jogoId + "?key=" + ApiConfig.RAWG_API_KEY;
            HttpGet request = new HttpGet(detalhesUrl);
            request.setHeader("Accept", "application/json");

            try (CloseableHttpResponse response = client.execute(request)) {
                if (response.getStatusLine().getStatusCode() == 200) {
                    String jsonResponse = EntityUtils.toString(response.getEntity());
                    JSONObject jogoJson = new JSONObject(jsonResponse);

                    // Coletar gêneros e plataformas do novo jogo
                    List<String> novosGeneros = new ArrayList<>();
                    List<String> novasPlataformas = new ArrayList<>();

                    if (jogoJson.has("genres")) {
                        JSONArray generos = jogoJson.getJSONArray("genres");
                        for (int i = 0; i < generos.length(); i++) {
                            String generoId = String.valueOf(generos.getJSONObject(i).getInt("id"));
                            novosGeneros.add(generoId);
                        }
                    }

                    if (jogoJson.has("platforms")) {
                        JSONArray plataformas = jogoJson.getJSONArray("platforms");
                        for (int i = 0; i < plataformas.length(); i++) {
                            String plataformaId = String.valueOf(plataformas.getJSONObject(i).getJSONObject("platform").getInt("id"));
                            novasPlataformas.add(plataformaId);
                        }
                    }

                    // Buscar jogos similares com base nos novos gêneros e plataformas
                    StringBuilder apiUrl = new StringBuilder(API_BASE_URL + "?key=" + ApiConfig.RAWG_API_KEY);
                    apiUrl.append("&ordering=-rating");
                    apiUrl.append("&page_size=20");
                    apiUrl.append("&metacritic=61,100");

                    if (!novosGeneros.isEmpty()) {
                        apiUrl.append("&genres=").append(String.join(",", novosGeneros));
                    }
                    if (!novasPlataformas.isEmpty()) {
                        apiUrl.append("&platforms=").append(String.join(",", novasPlataformas));
                    }

                    // Excluir o jogo que acabou de ser adicionado aos favoritos
                    apiUrl.append("&exclude=").append(jogoId);

                    HttpGet recomendacoesRequest = new HttpGet(apiUrl.toString());
                    recomendacoesRequest.setHeader("Accept", "application/json");

                    try (CloseableHttpResponse recomendacoesResponse = client.execute(recomendacoesRequest)) {
                        if (recomendacoesResponse.getStatusLine().getStatusCode() == 200) {
                            String recomendacoesJson = EntityUtils.toString(recomendacoesResponse.getEntity());
                            JSONObject jsonObject = new JSONObject(recomendacoesJson);
                            JSONArray results = jsonObject.getJSONArray("results");

                            List<Jogo> novasRecomendacoes = new ArrayList<>();
                            for (int i = 0; i < results.length(); i++) {
                                JSONObject jogoRecomendadoJson = results.getJSONObject(i);
                                Jogo jogo = new Jogo();
                                jogo.setId(Long.valueOf(jogoRecomendadoJson.getInt("id")));
                                jogo.setNome(jogoRecomendadoJson.getString("name"));
                                jogo.setDescricao(jogoRecomendadoJson.optString("description_raw", "Já disponível"));
                                String imagemUrl = jogoRecomendadoJson.optString("background_image", "/assets/img/game1.jpg");
                                jogo.setImagemUrl(imagemUrl != null ? imagemUrl : "/assets/img/game1.jpg");

                                if (jogoRecomendadoJson.has("genres")) {
                                    JSONArray generos = jogoRecomendadoJson.getJSONArray("genres");
                                    List<String> generosList = new ArrayList<>();
                                    for (int j = 0; j < generos.length(); j++) {
                                        generosList.add(generos.getJSONObject(j).getString("name"));
                                    }
                                    jogo.setGeneros(String.join(", ", generosList));
                                }

                                if (jogoRecomendadoJson.has("platforms")) {
                                    JSONArray plataformas = jogoRecomendadoJson.getJSONArray("platforms");
                                    List<String> plataformasList = new ArrayList<>();
                                    for (int j = 0; j < plataformas.length(); j++) {
                                        plataformasList.add(plataformas.getJSONObject(j).getJSONObject("platform").getString("name"));
                                    }
                                    jogo.setPlataformas(String.join(", ", plataformasList));
                                }

                                if (jogoRecomendadoJson.has("metacritic") && !jogoRecomendadoJson.isNull("metacritic")) {
                                    jogo.setNota(jogoRecomendadoJson.getDouble("metacritic"));
                                }

                                if (jogoRecomendadoJson.has("released")) {
                                    jogo.setDataLancamento(DateUtil.formatarDataBrasileira(jogoRecomendadoJson.getString("released")));
                                }

                                List<String> screenshots = buscarScreenshots(jogoRecomendadoJson.getLong("id"));
                                jogo.setScreenshots(screenshots);

                                if (!isConteudoSexualExplicito(jogo)) {
                                    novasRecomendacoes.add(jogo);
                                }
                            }

                            // Atualizar o cache de recomendações
                            recomendacoesCache.put(usuarioId, new CacheEntry(novasRecomendacoes, System.currentTimeMillis()));
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Erro ao atualizar cache de recomendações: " + e.getMessage());
        }
    }
} 