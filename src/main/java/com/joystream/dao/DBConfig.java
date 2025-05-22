package com.joystream.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConfig {

    private static final String URL = "jdbc:mysql://localhost:3306/joystream2_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false&allowPublicKeyRetrieval=true&collation=utf8mb4_bin";
    private static final String USUARIO = "root";
    private static final String SENHA = "123456789";

    static {
        try {
            // Carrega explicitamente o driver JDBC do MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Se não encontrar o driver, lança uma exceção em tempo de inicialização
            throw new ExceptionInInitializerError("Driver JDBC do MySQL não encontrado. Adicione o JAR ao classpath.");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
}