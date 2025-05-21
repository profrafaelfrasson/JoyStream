package com.joystream.dao;

import com.joystream.model.Usuario;
import java.sql.*;

public class UsuarioDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/joystream_db";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    private static final String INSERT_SQL = "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)";
    private static final String SELECT_SQL = "SELECT * FROM usuarios WHERE email = ? AND senha = ?";

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("Driver JDBC do MySQL não encontrado!");
            e.printStackTrace();
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
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
            stmt.setString(3, usuario.getSenha());
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
            stmt.setString(2, senha);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNome(rs.getString("nome"));
                u.setEmail(rs.getString("email"));
                u.setSenha(rs.getString("senha"));
                return u;
            }
        } catch (SQLException e) {
            System.out.println("Erro no login:");
            e.printStackTrace();
        }
        return null;
    }
}
