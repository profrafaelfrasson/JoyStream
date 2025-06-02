package com.joystream.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

import com.joystream.model.Usuario;

public class UsuarioDAO {
    private static final String INSERT_SQL = "INSERT INTO usuario (nm_usuario, email, senha, avatar, dt_criacao, dt_atualizacao) VALUES (?, ?, ?, ?, NOW(), NOW())";
    private static final String SELECT_SQL = "SELECT * FROM usuario WHERE email = ?";

    protected Connection getConnection() throws SQLException {
        return DBConfig.getConnection();
    }

    public boolean emailExiste(String email) {
        String sql = "SELECT id_usuario FROM usuario WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cadastrar(Usuario usuario) {
        if (emailExiste(usuario.getEmail())) {
            return false;
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_SQL)) {
            stmt.setString(1, usuario.getNmUsuario());
            stmt.setString(2, usuario.getEmail());
            String senhaHash = BCrypt.hashpw(usuario.getSenha(), BCrypt.gensalt());
            stmt.setString(3, senhaHash);
            stmt.setString(4, usuario.getAvatar());
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao cadastrar usuário:");
            e.printStackTrace();
            return false;
        }
    }

    public Usuario login(String email, String senha) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_SQL)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String senhaHash = rs.getString("senha");
                
                // Se a senha não estiver no formato BCrypt, converte e atualiza
                if (!senhaHash.startsWith("$2")) {
                    String novoHash = BCrypt.hashpw(senha, BCrypt.gensalt());
                    atualizarSenha(rs.getInt("id_usuario"), novoHash);
                    senhaHash = novoHash;
                }
                
                if (BCrypt.checkpw(senha, senhaHash)) {
                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setNmUsuario(rs.getString("nm_usuario"));
                    u.setEmail(rs.getString("email"));
                    u.setSenha(senhaHash);
                    u.setAvatar(rs.getString("avatar"));
                    u.setDtCriacao(rs.getTimestamp("dt_criacao"));
                    u.setDtAtualizacao(rs.getTimestamp("dt_atualizacao"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.out.println("Erro no login:");
            e.printStackTrace();
        }
        return null;
    }

    private void atualizarSenha(int idUsuario, String novaSenhaHash) {
        String sql = "UPDATE usuario SET senha = ?, dt_atualizacao = NOW() WHERE id_usuario = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novaSenhaHash);
            stmt.setInt(2, idUsuario);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Usuario buscarPorEmail(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_SQL)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNmUsuario(rs.getString("nm_usuario"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setAvatar(rs.getString("avatar"));
                usuario.setDtCriacao(rs.getTimestamp("dt_criacao"));
                usuario.setDtAtualizacao(rs.getTimestamp("dt_atualizacao"));
                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean atualizarPerfil(Usuario usuario) {
        String sql = "UPDATE usuario SET nm_usuario = ?, avatar = ?, dt_atualizacao = NOW() WHERE id_usuario = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, usuario.getNmUsuario());
            stmt.setString(2, usuario.getAvatar());
            stmt.setInt(3, usuario.getIdUsuario());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarSenha(Usuario usuario) {
        String sql = "UPDATE usuario SET senha = ?, dt_atualizacao = NOW() WHERE id_usuario = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String senhaHash = BCrypt.hashpw(usuario.getSenha(), BCrypt.gensalt());
            stmt.setString(1, senhaHash);
            stmt.setInt(2, usuario.getIdUsuario());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
