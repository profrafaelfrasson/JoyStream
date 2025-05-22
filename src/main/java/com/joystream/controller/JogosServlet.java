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
        for (int i = 0; i < results.length(); i++) {
            jogos.add(results.getJSONObject(i));
        }

        // Adiciona informações de paginação
        request.setAttribute("total_pages", json.getInt("count") / 20 + 1);
        request.setAttribute("current_page", Integer.parseInt(pagina));
        request.setAttribute("jogos", jogos);

        // Encaminha para a JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("jogos.jsp");
        dispatcher.forward(request, response);
    }
} 