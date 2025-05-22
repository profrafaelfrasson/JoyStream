-- Deletar o banco de dados se existir
DROP DATABASE IF EXISTS joystream2_db;

-- Criar o banco de dados novamente
CREATE DATABASE joystream2_db CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

-- Usar o banco de dados
USE joystream2_db;

-- Criar a tabela de usuários com o campo avatar como LONGTEXT
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(60) NOT NULL,
    avatar LONGTEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin; 