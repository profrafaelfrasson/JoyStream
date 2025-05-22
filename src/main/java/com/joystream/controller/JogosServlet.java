package com.joystream.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/jogos")
public class JogosServlet extends HttpServlet {
    private static final String API_KEY = "5c0f001717fe48498900310b7ca4aa41";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recebe filtros da requisição
        String plataforma = request.getParameter("plataforma");
        String genero = request.getParameter("genero");
        String nota = request.getParameter("nota");
        String busca = request.getParameter("busca");
        String pagina = request.getParameter("pagina");
        if (pagina == null || pagina.isEmpty()) {
            pagina = "1";
        }

        // Monta a URL da RAWG API
        StringBuilder apiUrl = new StringBuilder("https://api.rawg.io/api/games?key=" + API_KEY + "&page_size=20&page=" + pagina);
        if (plataforma != null && !plataforma.trim().isEmpty()) apiUrl.append("&platforms=").append(plataforma.trim());
        if (genero != null && !genero.trim().isEmpty()) apiUrl.append("&genres=").append(genero.trim());
        if (nota != null && !nota.trim().isEmpty()) apiUrl.append("&metacritic=").append(nota.trim()).append(",100");
        if (busca != null && !busca.trim().isEmpty()) apiUrl.append("&search=").append(busca.trim());

        // Faz a requisição HTTP
        URL url = new URL(apiUrl.toString());
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

        // Processa o JSON
        JSONObject json = new JSONObject(content.toString());
        JSONArray results = json.getJSONArray("results");
        List<JSONObject> jogos = new ArrayList<>();
        boolean erroApi = false;
        try {
            for (int i = 0; i < results.length(); i++) {
                jogos.add(results.getJSONObject(i));
            }
        } catch (Exception e) {
            erroApi = true;
        }

        // Sempre buscar o count da página 1 para calcular o total de páginas
        int count;
        try {
            if (pagina.equals("1")) {
                count = json.getInt("count");
            } else {
                // Monta a URL da página 1 com os mesmos filtros
                StringBuilder apiUrlPage1 = new StringBuilder("https://api.rawg.io/api/games?key=" + API_KEY + "&page_size=20&page=1");
                if (plataforma != null && !plataforma.trim().isEmpty()) apiUrlPage1.append("&platforms=").append(plataforma.trim());
                if (genero != null && !genero.trim().isEmpty()) apiUrlPage1.append("&genres=").append(genero.trim());
                if (nota != null && !nota.trim().isEmpty()) apiUrlPage1.append("&metacritic=").append(nota.trim()).append(",100");
                if (busca != null && !busca.trim().isEmpty()) apiUrlPage1.append("&search=").append(busca.trim());

                URL urlPage1 = new URL(apiUrlPage1.toString());
                HttpURLConnection connPage1 = (HttpURLConnection) urlPage1.openConnection();
                connPage1.setRequestMethod("GET");
                BufferedReader inPage1 = new BufferedReader(new InputStreamReader(connPage1.getInputStream()));
                String inputLinePage1;
                StringBuilder contentPage1 = new StringBuilder();
                while ((inputLinePage1 = inPage1.readLine()) != null) {
                    contentPage1.append(inputLinePage1);
                }
                inPage1.close();
                connPage1.disconnect();
                JSONObject jsonPage1 = new JSONObject(contentPage1.toString());
                count = jsonPage1.getInt("count");
            }
        } catch (Exception e) {
            count = results.length(); // fallback: só os resultados atuais
            System.out.println("[DEBUG] Falha ao buscar count da página 1, usando results.length: " + count);
        }
        int totalPages = (int) Math.ceil(count / 20.0);
        if (totalPages < 1) totalPages = 1;
        if (totalPages > 25) totalPages = 25; // RAWG API limita a 500 resultados
        System.out.println("Página atual: " + pagina + " | Total de páginas: " + totalPages + " | Count: " + count);
        request.setAttribute("total_pages", Integer.valueOf(totalPages));
        request.setAttribute("current_page", Integer.valueOf(pagina));
        request.setAttribute("jogos", jogos);
        request.setAttribute("erroApi", erroApi);

        // Encaminha para a JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("jogos.jsp");
        dispatcher.forward(request, response);
    }
} 