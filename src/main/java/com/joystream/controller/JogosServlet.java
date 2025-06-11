package com.joystream.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import com.joystream.config.ApiConfig;

@WebServlet("/jogos")
public class JogosServlet extends HttpServlet {
    private static final int ITEMS_PER_PAGE = 20;
    private static final int MAX_PAGES = 25;

    // Mapa de aliases conhecidos para jogos populares
    private static final Set<String[]> GAME_ALIASES = new HashSet<>(Arrays.asList(
        new String[]{"lol", "league of legends", "league", "wild rift"},
        new String[]{"cod", "call of duty"},
        new String[]{"cs", "cs:go", "csgo", "counter strike", "counter-strike"},
        new String[]{"gta", "grand theft auto"},
        new String[]{"wow", "world of warcraft"},
        new String[]{"dota", "dota 2", "defense of the ancients"},
        new String[]{"pubg", "playerunknown's battlegrounds"},
        new String[]{"fortnite", "fort nite"},
        new String[]{"minecraft", "mine craft"},
        new String[]{"apex", "apex legends"}
    ));

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Recebe filtros da requisição
            String[] plataformas = request.getParameterValues("plataforma");
            String[] generos = request.getParameterValues("genero");
            String notaMin = request.getParameter("nota_min");
            String busca = request.getParameter("busca");
            String buscaPrecisa = request.getParameter("busca_precisa");
            String paginaStr = request.getParameter("pagina");
            
            int paginaAtual = 1;
            try {
                if (paginaStr != null && !paginaStr.isEmpty()) {
                    paginaAtual = Integer.parseInt(paginaStr);
                    if (paginaAtual < 1) paginaAtual = 1;
                }
            } catch (NumberFormatException e) {
                paginaAtual = 1;
            }

            // Monta a URL da RAWG API
            StringBuilder apiUrl = new StringBuilder(ApiConfig.RAWG_API_BASE_URL + "?key=" + ApiConfig.RAWG_API_KEY + "&page_size=40");
            
            // Adiciona plataformas (múltipla seleção)
            if (plataformas != null && plataformas.length > 0) {
                String plataformasStr = String.join(",", plataformas);
                apiUrl.append("&platforms=").append(plataformasStr);
            }

            // Adiciona gêneros (múltipla seleção)
            if (generos != null && generos.length > 0) {
                String generosStr = String.join(",", generos);
                apiUrl.append("&genres=").append(generosStr);
            }

            // Filtragem por nota mínima
            if (notaMin != null && !notaMin.trim().isEmpty() && !"".equals(notaMin.trim())) {
                try {
                    int nota = Integer.parseInt(notaMin.trim());
                    if (nota > 0) {
                        apiUrl.append("&metacritic=").append(nota).append(",100");
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Nota mínima inválida: " + notaMin);
                }
            }

            // Lista para armazenar todos os resultados
            List<JSONObject> todosJogos = new ArrayList<>();

            // Se houver busca, faz múltiplas chamadas para diferentes variações do termo
            if (busca != null && !busca.trim().isEmpty()) {
                String buscaOriginal = busca.trim().toLowerCase();
                Set<String> termosParaBuscar = new HashSet<>();
                termosParaBuscar.add(buscaOriginal);

                // Adiciona aliases conhecidos
                for (String[] aliasGroup : GAME_ALIASES) {
                    boolean encontrouMatch = false;
                    for (String alias : aliasGroup) {
                        if (buscaOriginal.contains(alias) || alias.contains(buscaOriginal)) {
                            encontrouMatch = true;
                            break;
                        }
                    }
                    if (encontrouMatch) {
                        termosParaBuscar.addAll(Arrays.asList(aliasGroup));
                    }
                }

                // Faz a busca para cada termo
                for (String termo : termosParaBuscar) {
                    // Faz múltiplas chamadas para obter mais resultados
                    for (int page = 1; page <= 3; page++) {
                        StringBuilder searchUrl = new StringBuilder(apiUrl);
                        searchUrl.append("&page=").append(page);
                        searchUrl.append("&search=").append(URLEncoder.encode(termo, StandardCharsets.UTF_8));
                        if ("true".equals(buscaPrecisa)) {
                            searchUrl.append("&search_precise=true");
                        }
                        searchUrl.append("&ordering=relevance,-rating,name");

                        // Faz a requisição HTTP
                        URL url = new URL(searchUrl.toString());
                        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                        conn.setRequestMethod("GET");
                        conn.setConnectTimeout(5000);
                        conn.setReadTimeout(5000);

                        if (conn.getResponseCode() == 200) {
                            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                            StringBuilder content = new StringBuilder();
                            String inputLine;
                            while ((inputLine = in.readLine()) != null) {
                                content.append(inputLine);
                            }
                            in.close();

                            JSONObject json = new JSONObject(content.toString());
                            JSONArray results = json.getJSONArray("results");
                            
                            // Se não houver mais resultados, interrompe as chamadas
                            if (results.length() == 0) break;
                            
                            for (int i = 0; i < results.length(); i++) {
                                JSONObject jogo = results.getJSONObject(i);
                                // Evita duplicatas verificando se o jogo já existe na lista
                                boolean jogoJaExiste = todosJogos.stream()
                                    .anyMatch(j -> j.getInt("id") == jogo.getInt("id"));
                                if (!jogoJaExiste) {
                                    todosJogos.add(jogo);
                                }
                            }
                        }
                        conn.disconnect();
                    }
                }

                // Ordena todos os resultados por relevância
                final String termoBuscaFinal = buscaOriginal;
                Collections.sort(todosJogos, new Comparator<JSONObject>() {
                    @Override
                    public int compare(JSONObject j1, JSONObject j2) {
                        String nome1 = j1.getString("name").toLowerCase();
                        String nome2 = j2.getString("name").toLowerCase();
                        
                        // Prioridade 1: Match exato com o termo original
                        boolean exactMatch1 = nome1.equals(termoBuscaFinal);
                        boolean exactMatch2 = nome2.equals(termoBuscaFinal);
                        if (exactMatch1 && !exactMatch2) return -1;
                        if (!exactMatch1 && exactMatch2) return 1;
                        
                        // Prioridade 2: Começa com o termo de busca
                        boolean startsWith1 = nome1.startsWith(termoBuscaFinal);
                        boolean startsWith2 = nome2.startsWith(termoBuscaFinal);
                        if (startsWith1 && !startsWith2) return -1;
                        if (!startsWith1 && startsWith2) return 1;
                        
                        // Prioridade 3: Contém o termo como palavra completa
                        boolean containsWord1 = nome1.matches(".*\\b" + termoBuscaFinal + "\\b.*");
                        boolean containsWord2 = nome2.matches(".*\\b" + termoBuscaFinal + "\\b.*");
                        if (containsWord1 && !containsWord2) return -1;
                        if (!containsWord1 && containsWord2) return 1;
                        
                        // Prioridade 4: Match com aliases e agrupamento de séries
                        int aliasScore1 = getAliasMatchScore(nome1, termoBuscaFinal);
                        int aliasScore2 = getAliasMatchScore(nome2, termoBuscaFinal);
                        if (aliasScore1 != aliasScore2) {
                            return aliasScore2 - aliasScore1;
                        }
                        
                        // Prioridade 5: Mantém jogos da mesma série juntos
                        String base1 = getBaseGameName(nome1);
                        String base2 = getBaseGameName(nome2);
                        if (base1.equals(base2)) {
                            // Se são da mesma série, ordena por data de lançamento ou nome
                            if (j1.has("released") && j2.has("released")) {
                                return j2.getString("released").compareTo(j1.getString("released"));
                            }
                            return nome1.compareTo(nome2);
                        }
                        
                        // Prioridade 6: Contém o termo em qualquer lugar
                        boolean contains1 = nome1.contains(termoBuscaFinal);
                        boolean contains2 = nome2.contains(termoBuscaFinal);
                        if (contains1 && !contains2) return -1;
                        if (!contains1 && contains2) return 1;
                        
                        return nome1.compareTo(nome2);
                    }
                });
            } else {
                // Se não houver busca, faz uma única chamada
                URL url = new URL(apiUrl.toString());
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setConnectTimeout(5000);
                conn.setReadTimeout(5000);

                if (conn.getResponseCode() == 200) {
                    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    StringBuilder content = new StringBuilder();
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        content.append(inputLine);
                    }
                    in.close();

                    JSONObject json = new JSONObject(content.toString());
                    JSONArray results = json.getJSONArray("results");
                    for (int i = 0; i < results.length(); i++) {
                        todosJogos.add(results.getJSONObject(i));
                    }
                }
                conn.disconnect();
            }

            // Calcula o total de páginas baseado no número real de resultados
            int totalJogos = todosJogos.size();
            int totalPages = (int) Math.ceil((double) totalJogos / ITEMS_PER_PAGE);
            if (totalPages < 1) totalPages = 1;
            if (totalPages > MAX_PAGES) totalPages = MAX_PAGES;

            // Ajusta a página atual se necessário
            if (paginaAtual > totalPages) {
                paginaAtual = totalPages;
            }

            // Calcula os índices para a página atual
            int startIndex = (paginaAtual - 1) * ITEMS_PER_PAGE;
            int endIndex = Math.min(startIndex + ITEMS_PER_PAGE, totalJogos);

            // Obtém os jogos para a página atual
            List<JSONObject> jogos = startIndex < totalJogos ? 
                                   todosJogos.subList(startIndex, endIndex) : 
                                   new ArrayList<>();

            request.setAttribute("total_pages", totalPages);
            request.setAttribute("current_page", paginaAtual);
            request.setAttribute("jogos", jogos);
            request.setAttribute("erroApi", false);

        } catch (Exception e) {
            System.out.println("Erro ao processar requisição: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("erroApi", true);
            request.setAttribute("jogos", new ArrayList<>());
            request.setAttribute("total_pages", 1);
            request.setAttribute("current_page", 1);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("jogos.jsp");
        dispatcher.forward(request, response);
    }

    private int getAliasMatchScore(String nome, String termoBusca) {
        int maxScore = 0;
        for (String[] aliasGroup : GAME_ALIASES) {
            boolean nomeContemAlias = false;
            boolean termoContemAlias = false;
            
            for (String alias : aliasGroup) {
                if (nome.toLowerCase().contains(alias.toLowerCase())) nomeContemAlias = true;
                if (termoBusca.toLowerCase().contains(alias.toLowerCase())) termoContemAlias = true;
            }
            
            if (nomeContemAlias && termoContemAlias) {
                maxScore = Math.max(maxScore, 3);
            } else if (nomeContemAlias || termoContemAlias) {
                maxScore = Math.max(maxScore, 1);
            }
        }
        return maxScore;
    }

    private String getBaseGameName(String nome) {
        // Remove números e caracteres especiais do final do nome
        nome = nome.toLowerCase().trim();
        // Remove ano entre parênteses, se houver
        nome = nome.replaceAll("\\s*\\(\\d{4}\\)\\s*", " ");
        // Remove números romanos do final (I, II, III, IV, V, etc)
        nome = nome.replaceAll("\\s+(?:i{1,3}|iv|vi{0,3}|ix|xi{0,2}|)\\s*$", " ");
        // Remove números do final
        nome = nome.replaceAll("\\s+\\d+\\s*$", " ");
        // Remove espaços extras
        nome = nome.trim();
        return nome;
    }
} 