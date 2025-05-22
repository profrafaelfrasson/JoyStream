package com.joystream.dao;

import com.joystream.model.Usuario;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {
    private static final String INSERT_SQL = "INSERT INTO usuarios (nome, email, senha, avatar) VALUES (?, ?, ?, ?)";
    private static final String SELECT_SQL = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";

    protected Connection getConnection() throws SQLException {
        return DBConfig.getConnection();
    }

    public boolean emailExiste(String email) {
        String sql = "SELECT id FROM usuarios WHERE email = ?";
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
            stmt.setString(1, usuario.getNome());
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
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM usuarios WHERE email = ?")) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String senhaHash = rs.getString("senha");
                
                // Se a senha não estiver no formato BCrypt, converte e atualiza
                if (!senhaHash.startsWith("$2")) {
                    String novoHash = BCrypt.hashpw(senha, BCrypt.gensalt());
                    atualizarSenha(rs.getInt("id"), novoHash);
                    senhaHash = novoHash;
                }
                
                if (BCrypt.checkpw(senha, senhaHash)) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNome(rs.getString("nome"));
                    u.setEmail(rs.getString("email"));
                    u.setSenha(senhaHash);
                    u.setAvatar(rs.getString("avatar"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.out.println("Erro no login:");
            e.printStackTrace();
        }
        return null;
    }

    private void atualizarSenha(int userId, String novaSenhaHash) {
        String sql = "UPDATE usuarios SET senha = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novaSenhaHash);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Usuario buscarPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setNome(rs.getString("nome"));
                usuario.setEmail(rs.getString("email"));
                usuario.setSenha(rs.getString("senha"));
                usuario.setAvatar(rs.getString("avatar"));
                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean atualizarPerfil(Usuario usuario) {
        String sql = "UPDATE usuarios SET nome = ?, senha = ?, avatar = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNome());

            // Buscar o hash atual do banco
            Usuario usuarioAtual = buscarPorEmail(usuario.getEmail());
            if (usuarioAtual == null) {
                return false;
            }

            String senhaParaSalvar;
            // Se a senha atual não estiver no formato BCrypt, converte
            if (!usuarioAtual.getSenha().startsWith("$2")) {
                senhaParaSalvar = BCrypt.hashpw(usuario.getSenha(), BCrypt.gensalt());
            } else {
                // Se a senha informada for diferente do hash atual, gera novo hash
                if (!BCrypt.checkpw(usuario.getSenha(), usuarioAtual.getSenha())) {
                    senhaParaSalvar = BCrypt.hashpw(usuario.getSenha(), BCrypt.gensalt());
                } else {
                    // Se for igual, mantém o hash antigo
                    senhaParaSalvar = usuarioAtual.getSenha();
                }
            }

            stmt.setString(2, senhaParaSalvar);
            stmt.setString(3, usuario.getAvatar());
            stmt.setInt(4, usuario.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
