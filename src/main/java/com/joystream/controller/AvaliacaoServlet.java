package com.joystream.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.joystream.dao.AvaliacaoDAO;
import com.joystream.dao.FavoritoDAO;
import com.joystream.model.Avaliacao;
import com.joystream.model.Usuario;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/avaliacao/*")
public class AvaliacaoServlet extends HttpServlet {
    private AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();
    private FavoritoDAO favoritoDAO = new FavoritoDAO();

    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int jogoId = Integer.parseInt(request.getParameter("jogoId"));
            String all = request.getParameter("all");
            if (all != null && all.equals("true")) {
                // Retornar todas as avaliações do jogo
                java.util.List<Avaliacao> avaliacoes = avaliacaoDAO.listarPorJogo(jogoId);
                JSONArray arr = new JSONArray();
                for (Avaliacao av : avaliacoes) {
                    JSONObject obj = new JSONObject();
                    obj.put("nota", av.getNota());
                    obj.put("comentario", av.getComentario());
                    obj.put("nomeUsuario", av.getNomeUsuario());
                    obj.put("dtAvaliacao", av.getDtAvaliacao() != null ? av.getDtAvaliacao().toString() : "");
                    arr.put(obj);
                }
                response.getWriter().write(arr.toString());
                return;
            }
            
            // Primeiro busca o id_favorito
            Integer idFavorito = favoritoDAO.buscarIdFavorito(usuario.getIdUsuario(), jogoId);
            
            JSONObject json = new JSONObject();
            
            if (idFavorito != null) {
                // Busca a avaliação usando o id_favorito
                Avaliacao avaliacao = avaliacaoDAO.buscarPorFavorito(idFavorito);
                
                if (avaliacao != null) {
                    json.put("nota", Integer.valueOf(avaliacao.getNota()));
                    json.put("comentario", avaliacao.getComentario());
                } else {
                    json.put("nota", JSONObject.NULL);
                    json.put("comentario", "");
                }
            } else {
                json.put("nota", JSONObject.NULL);
                json.put("comentario", "");
            }
            
            response.getWriter().write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            int jogoId = Integer.parseInt(request.getParameter("jogoId"));
            int nota = Integer.parseInt(request.getParameter("nota"));
            String comentario = request.getParameter("comentario");

            // Busca o id_favorito
            Integer idFavorito = favoritoDAO.buscarIdFavorito(usuario.getIdUsuario(), jogoId);
            
            if (idFavorito == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            // Verifica se já existe uma avaliação
            Avaliacao avaliacaoExistente = avaliacaoDAO.buscarPorFavorito(idFavorito);
            
            if (avaliacaoExistente != null) {
                // Atualiza a avaliação existente
                avaliacaoExistente.setNota(nota);
                avaliacaoExistente.setComentario(comentario);
                avaliacaoDAO.atualizar(avaliacaoExistente);
            } else {
                // Cria uma nova avaliação
                Avaliacao novaAvaliacao = new Avaliacao();
                novaAvaliacao.setIdUsuario(usuario.getIdUsuario());
                novaAvaliacao.setIdFavorito(idFavorito);
                novaAvaliacao.setNota(nota);
                novaAvaliacao.setComentario(comentario);
                avaliacaoDAO.adicionar(novaAvaliacao);
            }

            response.setStatus(HttpServletResponse.SC_OK);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
} 