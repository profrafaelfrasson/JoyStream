package com.joystream.dao;

import com.joystream.model.Avaliacao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvaliacaoDAO {
    
    public void adicionar(Avaliacao avaliacao) throws SQLException {
        String sql = "INSERT INTO avaliacao (id_usuario, id_favorito, nota, comentario, dt_avaliacao) VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, avaliacao.getIdUsuario());
            stmt.setInt(2, avaliacao.getIdFavorito());
            stmt.setInt(3, avaliacao.getNota());
            stmt.setString(4, avaliacao.getComentario());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    avaliacao.setIdAvaliacao(rs.getInt(1));
                }
            }
        }
    }
    
    public void atualizar(Avaliacao avaliacao) throws SQLException {
        String sql = "UPDATE avaliacao SET nota = ?, comentario = ?, dt_avaliacao = NOW() WHERE id_avaliacao = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacao.getNota());
            stmt.setString(2, avaliacao.getComentario());
            stmt.setInt(3, avaliacao.getIdAvaliacao());
            
            stmt.executeUpdate();
        }
    }
    
    public void remover(int idAvaliacao) throws SQLException {
        String sql = "DELETE FROM avaliacao WHERE id_avaliacao = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idAvaliacao);
            stmt.executeUpdate();
        }
    }
    
    public List<Avaliacao> listarPorUsuario(int idUsuario) throws SQLException {
        List<Avaliacao> avaliacoes = new ArrayList<>();
        String sql = "SELECT * FROM avaliacao WHERE id_usuario = ? ORDER BY dt_avaliacao DESC";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    avaliacoes.add(mapResultSetToAvaliacao(rs));
                }
            }
        }
        return avaliacoes;
    }
    
    public List<Avaliacao> listarPorFavorito(int idFavorito) throws SQLException {
        List<Avaliacao> avaliacoes = new ArrayList<>();
        String sql = "SELECT * FROM avaliacao WHERE id_favorito = ? ORDER BY dt_avaliacao DESC";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFavorito);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    avaliacoes.add(mapResultSetToAvaliacao(rs));
                }
            }
        }
        return avaliacoes;
    }
    
    public Avaliacao buscarPorId(int idAvaliacao) throws SQLException {
        String sql = "SELECT * FROM avaliacao WHERE id_avaliacao = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idAvaliacao);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAvaliacao(rs);
                }
            }
        }
        return null;
    }
    
    public void salvarOuAtualizar(int idUsuario, int idFavorito, int nota, String comentario) throws SQLException {
        String sql = "INSERT INTO avaliacao (id_usuario, id_favorito, nota, comentario, dt_avaliacao) VALUES (?, ?, ?, ?, NOW()) " +
                     "ON DUPLICATE KEY UPDATE nota = VALUES(nota), comentario = VALUES(comentario), dt_avaliacao = NOW()";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idFavorito);
            stmt.setInt(3, nota);
            stmt.setString(4, comentario);
            stmt.executeUpdate();
        }
    }
    
    private Avaliacao mapResultSetToAvaliacao(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = new Avaliacao();
        avaliacao.setIdAvaliacao(rs.getInt("id_avaliacao"));
        avaliacao.setIdUsuario(rs.getInt("id_usuario"));
        avaliacao.setIdFavorito(rs.getInt("id_favorito"));
        avaliacao.setNota(rs.getInt("nota"));
        avaliacao.setComentario(rs.getString("comentario"));
        avaliacao.setDtAvaliacao(rs.getTimestamp("dt_avaliacao"));
        return avaliacao;
    }
} 