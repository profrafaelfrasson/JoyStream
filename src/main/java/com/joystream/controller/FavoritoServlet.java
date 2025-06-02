package com.joystream.controller;

import com.joystream.dao.FavoritoDAO;
import com.joystream.model.Favorito;
import com.joystream.model.Usuario;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/favorito/*")
public class FavoritoServlet extends HttpServlet {
    private FavoritoDAO favoritoDAO = new FavoritoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            System.out.println("Erro: Usuário não está logado");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            String action = request.getParameter("action");
            int jogoId = Integer.parseInt(request.getParameter("jogoId"));
            
            System.out.println("Ação solicitada: " + action);
            System.out.println("ID do jogo: " + jogoId);
            System.out.println("ID do usuário: " + usuario.getIdUsuario());
            
            if ("adicionar".equals(action)) {
                Favorito favorito = new Favorito();
                favorito.setIdUsuario(usuario.getIdUsuario());
                favorito.setIdJogo(jogoId);
                
                favoritoDAO.adicionar(favorito);
                response.setStatus(HttpServletResponse.SC_OK);
                
            } else if ("remover".equals(action)) {
                favoritoDAO.remover(usuario.getIdUsuario(), jogoId);
                response.setStatus(HttpServletResponse.SC_OK);
            }
            
        } catch (NumberFormatException e) {
            System.out.println("Erro ao converter números: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (IllegalArgumentException e) {
            System.out.println("Erro nos dados fornecidos: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("Erro ao processar requisição: " + e.getMessage());
            System.out.println("Tipo de erro: " + e.getClass().getName());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String pathInfo = request.getPathInfo();
        if ("/check".equals(pathInfo)) {
            try {
                int jogoId = Integer.parseInt(request.getParameter("jogoId"));
                boolean isFavorito = favoritoDAO.isFavorito(usuario.getIdUsuario(), jogoId);
                
                JSONObject json = new JSONObject();
                json.put("isFavorito", isFavorito);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
                
            } catch (Exception e) {
                System.out.println("Erro ao verificar favorito: " + e.getMessage());
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            try {
                List<Favorito> favoritos = favoritoDAO.listarPorUsuario(usuario.getIdUsuario());
                request.setAttribute("favoritos", favoritos);
                request.getRequestDispatcher("/favoritos.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("Erro ao listar favoritos: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/erro.jsp");
            }
        }
    }
} 