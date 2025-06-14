package com.joystream.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.joystream.dao.FavoritoDAO;
import com.joystream.model.Favorito;
import com.joystream.model.Jogo;
import com.joystream.model.Usuario;
import com.joystream.service.JogoService;

@WebServlet("/favorito/*")
public class FavoritoServlet extends HttpServlet {
    private FavoritoDAO favoritoDAO = new FavoritoDAO();
    private JogoService jogoService = new JogoService();

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
                
                // Make cache operations asynchronous
                new Thread(() -> {
                    try {
                        // Adicionar o novo jogo ao cache existente
                        jogoService.adicionarJogoAoCacheFavoritos(usuario.getIdUsuario(), jogoId);
                        
                        // Atualizar o cache de recomendações
                        jogoService.atualizarCacheRecomendacoes(usuario.getIdUsuario(), jogoId);
                    } catch (Exception e) {
                        System.out.println("Erro ao atualizar caches em background: " + e.getMessage());
                    }
                }).start();
                
                response.setStatus(HttpServletResponse.SC_OK);
                
            } else if ("remover".equals(action)) {
                favoritoDAO.remover(usuario.getIdUsuario(), jogoId);
                
                // Make cache operations asynchronous
                new Thread(() -> {
                    try {
                        // Remover o jogo do cache existente
                        jogoService.removerJogoDoCacheFavoritos(usuario.getIdUsuario(), jogoId);
                    } catch (Exception e) {
                        System.out.println("Erro ao atualizar caches em background: " + e.getMessage());
                    }
                }).start();
                
                response.setStatus(HttpServletResponse.SC_OK);
            } else if ("concluido".equals(action)) {
                boolean concluido = Boolean.parseBoolean(request.getParameter("concluido"));
                favoritoDAO.atualizarConcluido(usuario.getIdUsuario(), jogoId, concluido);
                
                JSONObject json = new JSONObject();
                json.put("success", true);
                json.put("concluido", concluido);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
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
                // Carregar favoritos com avaliações em uma única query
                List<Favorito> favoritos = favoritoDAO.listarPorUsuario(usuario.getIdUsuario());
                
                // Carregar detalhes dos jogos usando o cache
                List<Jogo> jogosFavoritos = jogoService.buscarDetalhesJogosFavoritos(favoritos);
                
                request.setAttribute("favoritos", jogosFavoritos);
                request.setAttribute("favoritos_detalhes", favoritos);
                request.getRequestDispatcher("/favoritos.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println("Erro ao listar favoritos: " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/erro.jsp");
            }
        }
    }
} 