package com.joystream.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/jogos")
public class JogosServlet extends HttpServlet {
    private static final String API_KEY = "e8c8ed1f44d54169b5b06a88a45348d1";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Recebe filtros da requisição
            String[] plataformas = request.getParameterValues("plataforma");
            String[] generos = request.getParameterValues("genero");
            String notaMin = request.getParameter("nota_min");
            String busca = request.getParameter("busca");
            String buscaPrecisa = request.getParameter("busca_precisa");
            String pagina = request.getParameter("pagina");
            
            if (pagina == null || pagina.isEmpty()) {
                pagina = "1";
            }

            // Monta a URL da RAWG API
            StringBuilder apiUrl = new StringBuilder("https://api.rawg.io/api/games?key=" + API_KEY + "&page_size=20&page=" + pagina);
            
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

            // Filtragem por nota mínima (apenas se tiver um valor válido)
            if (notaMin != null && !notaMin.trim().isEmpty() && !"".equals(notaMin.trim())) {
                try {
                    int nota = Integer.parseInt(notaMin.trim());
                    if (nota > 0) {
                        apiUrl.append("&metacritic=").append(nota).append(",100");
                    }
                } catch (NumberFormatException e) {
                    // Se não for um número válido, ignora o parâmetro
                    System.out.println("Nota mínima inválida: " + notaMin);
                }
            }

            // Busca com opção de precisão
            if (busca != null && !busca.trim().isEmpty()) {
                apiUrl.append("&search=").append(URLEncoder.encode(busca.trim(), StandardCharsets.UTF_8));
                if ("true".equals(buscaPrecisa)) {
                    apiUrl.append("&search_precise=true");
                }
            }

            // Log da URL para debug
            System.out.println("URL da API: " + apiUrl.toString());

            // Faz a requisição HTTP
            URL url = new URL(apiUrl.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                throw new IOException("Erro na API. Código: " + responseCode);
            }

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            conn.disconnect();

            // Processa o JSON
            JSONObject json = new JSONObject(content.toString());
            JSONArray results = json.getJSONArray("results");
            List<JSONObject> jogos = new ArrayList<>();
            
            for (int i = 0; i < results.length(); i++) {
                jogos.add(results.getJSONObject(i));
            }

            // Calcula total de páginas
            int count = json.getInt("count");
            int totalPages = (int) Math.ceil(count / 20.0);
            if (totalPages < 1) totalPages = 1;
            if (totalPages > 25) totalPages = 25; // RAWG API limita a 500 resultados
            
            request.setAttribute("total_pages", totalPages);
            request.setAttribute("current_page", Integer.valueOf(pagina));
            request.setAttribute("jogos", jogos);
            request.setAttribute("erroApi", false);

        } catch (Exception e) {
            // Log do erro para debug
            System.out.println("Erro ao processar requisição: " + e.getMessage());
            
            request.setAttribute("erroApi", true);
            request.setAttribute("jogos", new ArrayList<>());
            request.setAttribute("total_pages", 1);
            request.setAttribute("current_page", 1);
        }

        // Encaminha para a JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("jogos.jsp");
        dispatcher.forward(request, response);
    }
} 