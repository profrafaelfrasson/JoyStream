package com.joystream.dao;

import com.joystream.model.Favorito;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoritoDAO {
    
    public void adicionar(Favorito favorito) throws SQLException {
        String sql = "INSERT INTO favorito (id_usuario, id_jogo, dt_favoritado) VALUES (?, ?, NOW())";
        
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
        String sql = "SELECT * FROM favorito WHERE id_usuario = ? ORDER BY dt_favoritado DESC";
        
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
} 