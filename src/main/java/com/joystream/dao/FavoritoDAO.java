package com.joystream.dao;

import com.joystream.model.Favorito;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoritoDAO {
    
    public void adicionar(Favorito favorito) throws SQLException {
        String sql = "INSERT INTO favoritos (usuario_id, jogo_id, nome_jogo, imagem_url, data_lancamento, nota) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, favorito.getUsuarioId());
            stmt.setInt(2, favorito.getJogoId());
            stmt.setString(3, favorito.getNomeJogo());
            stmt.setString(4, favorito.getImagemUrl());
            stmt.setDate(5, favorito.getDataLancamento());
            stmt.setObject(6, favorito.getNota());
            
            stmt.executeUpdate();
        }
    }
    
    public void remover(int usuarioId, int jogoId) throws SQLException {
        String sql = "DELETE FROM favoritos WHERE usuario_id = ? AND jogo_id = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, jogoId);
            
            stmt.executeUpdate();
        }
    }
    
    public List<Favorito> listarPorUsuario(int usuarioId) throws SQLException {
        List<Favorito> favoritos = new ArrayList<>();
        String sql = "SELECT * FROM favoritos WHERE usuario_id = ? ORDER BY data_favoritado DESC";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Favorito favorito = new Favorito();
                    favorito.setId(rs.getInt("id"));
                    favorito.setUsuarioId(rs.getInt("usuario_id"));
                    favorito.setJogoId(rs.getInt("jogo_id"));
                    favorito.setNomeJogo(rs.getString("nome_jogo"));
                    favorito.setImagemUrl(rs.getString("imagem_url"));
                    favorito.setDataLancamento(rs.getDate("data_lancamento"));
                    favorito.setNota(rs.getObject("nota", Integer.class));
                    favorito.setDataFavoritado(rs.getTimestamp("data_favoritado"));
                    favoritos.add(favorito);
                }
            }
        }
        return favoritos;
    }
    
    public boolean isFavorito(int usuarioId, int jogoId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos WHERE usuario_id = ? AND jogo_id = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, jogoId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
} 