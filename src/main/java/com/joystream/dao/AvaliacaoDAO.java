package com.joystream.dao;

import com.joystream.model.Avaliacao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AvaliacaoDAO {
    
    public void adicionar(Avaliacao avaliacao) throws SQLException {
        String sql = "INSERT INTO avaliacao (id_usuario, id_favorito, nota, comentario, dt_avaliacao) VALUES (?, ?, ?, ?, NOW())";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacao.getIdUsuario());
            stmt.setInt(2, avaliacao.getIdFavorito());
            stmt.setInt(3, avaliacao.getNota());
            stmt.setString(4, avaliacao.getComentario());
            
            stmt.executeUpdate();
        }
    }
    
    public void atualizar(Avaliacao avaliacao) throws SQLException {
        String sql = "UPDATE avaliacao SET nota = ?, comentario = ?, dt_avaliacao = NOW() WHERE id_favorito = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacao.getNota());
            stmt.setString(2, avaliacao.getComentario());
            stmt.setInt(3, avaliacao.getIdFavorito());
            
            stmt.executeUpdate();
        }
    }
    
    public void remover(int idUsuario, int idFavorito) throws SQLException {
        String sql = "DELETE FROM avaliacao WHERE id_usuario = ? AND id_favorito = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idFavorito);
            
            stmt.executeUpdate();
        }
    }
    
    public Avaliacao buscarPorUsuarioEJogo(int idUsuario, int idJogo) throws SQLException {
        // Primeiro, buscar o id_favorito correspondente
        String sqlFavorito = "SELECT id_favorito FROM favorito WHERE id_usuario = ? AND id_jogo = ?";
        int idFavorito = -1;
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmtFavorito = conn.prepareStatement(sqlFavorito)) {
            
            stmtFavorito.setInt(1, idUsuario);
            stmtFavorito.setInt(2, idJogo);
            
            try (ResultSet rs = stmtFavorito.executeQuery()) {
                if (rs.next()) {
                    idFavorito = rs.getInt("id_favorito");
                } else {
                    return null; // Se não encontrou o favorito, não pode ter avaliação
                }
            }
        }
        
        // Agora buscar a avaliação usando o id_favorito
        String sql = "SELECT * FROM avaliacao WHERE id_usuario = ? AND id_favorito = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idUsuario);
            stmt.setInt(2, idFavorito);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
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
        }
        return null;
    }
    
    public List<Avaliacao> listarPorJogo(int idJogo) throws SQLException {
        List<Avaliacao> avaliacoes = new ArrayList<>();
        String sql = "SELECT a.*, u.nm_usuario FROM avaliacao a " +
                    "INNER JOIN usuario u ON a.id_usuario = u.id_usuario " +
                    "INNER JOIN favorito f ON a.id_favorito = f.id_favorito " +
                    "WHERE f.id_jogo = ? " +
                    "ORDER BY a.dt_avaliacao DESC";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idJogo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Avaliacao avaliacao = new Avaliacao();
                    avaliacao.setIdAvaliacao(rs.getInt("id_avaliacao"));
                    avaliacao.setIdUsuario(rs.getInt("id_usuario"));
                    avaliacao.setIdFavorito(rs.getInt("id_favorito"));
                    avaliacao.setNota(rs.getInt("nota"));
                    avaliacao.setComentario(rs.getString("comentario"));
                    avaliacao.setDtAvaliacao(rs.getTimestamp("dt_avaliacao"));
                    avaliacao.setNomeUsuario(rs.getString("nm_usuario"));
                    avaliacoes.add(avaliacao);
                }
            }
        }
        return avaliacoes;
    }

    public Avaliacao buscarPorFavorito(Integer idFavorito) throws SQLException {
        String sql = "SELECT * FROM avaliacao WHERE id_favorito = ?";
        
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idFavorito);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
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
        }
        return null;
    }
} 