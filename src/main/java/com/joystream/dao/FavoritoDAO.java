package com.joystream.dao;

import com.joystream.model.Favorito;
import com.joystream.model.Jogo;
import com.joystream.model.Avaliacao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FavoritoDAO {
    
    public void adicionar(Favorito favorito) throws SQLException {
        String sql = "INSERT INTO favorito (id_usuario, id_jogo, dt_favoritado, concluido) VALUES (?, ?, NOW(), 0)";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, favorito.getIdUsuario());
            stmt.setInt(2, favorito.getIdJogo());
            
            stmt.executeUpdate();
        }
    }
    
    public void remover(int idUsuario, int idJogo) throws SQLException {
        String sql = "DELETE FROM favorito WHERE id_usuario = ? AND id_jogo = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idJogo);
            
            stmt.executeUpdate();
        }
    }
    
    public List<Favorito> listarPorUsuario(int idUsuario) throws SQLException {
        List<Favorito> favoritos = new ArrayList<>();
        Map<Integer, Avaliacao> avaliacoes = new HashMap<>();
        
        // Query otimizada que busca favoritos e avaliações em uma única consulta
        String sql = "SELECT f.*, a.id_avaliacao, a.nota, a.comentario, a.dt_avaliacao " +
                    "FROM favorito f " +
                    "LEFT JOIN avaliacao a ON f.id_favorito = a.id_favorito " +
                    "WHERE f.id_usuario = ? " +
                    "ORDER BY f.dt_favoritado DESC";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Favorito favorito = new Favorito();
                    favorito.setIdFavorito(rs.getInt("id_favorito"));
                    favorito.setIdUsuario(rs.getInt("id_usuario"));
                    favorito.setIdJogo(rs.getInt("id_jogo"));
                    favorito.setDtFavoritado(rs.getTimestamp("dt_favoritado"));
                    favorito.setConcluido(rs.getBoolean("concluido"));
                    
                    // Se houver avaliação, criar objeto Avaliacao
                    if (rs.getObject("id_avaliacao") != null) {
                        Avaliacao avaliacao = new Avaliacao();
                        avaliacao.setIdAvaliacao(rs.getInt("id_avaliacao"));
                        avaliacao.setIdUsuario(idUsuario);
                        avaliacao.setIdFavorito(favorito.getIdFavorito());
                        avaliacao.setNota(rs.getInt("nota"));
                        avaliacao.setComentario(rs.getString("comentario"));
                        avaliacao.setDtAvaliacao(rs.getTimestamp("dt_avaliacao"));
                        
                        avaliacoes.put(favorito.getIdFavorito(), avaliacao);
                    }
                    
                    favorito.setAvaliacao(avaliacoes.get(favorito.getIdFavorito()));
                    favoritos.add(favorito);
                }
            }
        }
        return favoritos;
    }
    
    public boolean isFavorito(int idUsuario, int idJogo) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favorito WHERE id_usuario = ? AND id_jogo = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idJogo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public void atualizarConcluido(int idUsuario, int idJogo, boolean concluido) throws SQLException {
        String sql = "UPDATE favorito SET concluido = ? WHERE id_usuario = ? AND id_jogo = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, concluido);
            stmt.setInt(2, idUsuario);
            stmt.setInt(3, idJogo);
            
            stmt.executeUpdate();
        }
    }

    public boolean isConcluido(int idUsuario, int idJogo) throws SQLException {
        String sql = "SELECT concluido FROM favorito WHERE id_usuario = ? AND id_jogo = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idJogo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("concluido");
                }
            }
        }
        return false;
    }

    public Integer buscarIdFavorito(int idUsuario, int idJogo) throws SQLException {
        String sql = "SELECT id_favorito FROM favorito WHERE id_usuario = ? AND id_jogo = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idJogo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_favorito");
                }
            }
        }
        return null;
    }
} 