-- Create the database
CREATE DATABASE IF NOT EXISTS joystream;
USE joystream;

-- Create Users table
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    avatar LONGTEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Create Games table
CREATE TABLE IF NOT EXISTS jogos (
    id INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    data_lancamento DATE,
    nota DECIMAL(3,1),
    imagem_url TEXT,
    generos VARCHAR(255),
    plataformas VARCHAR(255),
    desenvolvedor VARCHAR(100),
    publicador VARCHAR(100),
    classificacao_esrb VARCHAR(50),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Favorites table
CREATE TABLE IF NOT EXISTS favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    jogo_id INT NOT NULL,
    data_favoritado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (jogo_id) REFERENCES jogos(id) ON DELETE CASCADE,
    UNIQUE KEY unique_favorito (usuario_id, jogo_id)
);

-- Create index for common queries
CREATE INDEX idx_jogos_nome ON jogos(nome);
CREATE INDEX idx_jogos_nota ON jogos(nota);
CREATE INDEX idx_jogos_lancamento ON jogos(data_lancamento);
CREATE INDEX idx_usuarios_email ON usuarios(email);

-- Insert default admin user (password: admin123)
INSERT INTO usuarios (nome, email, senha) 
VALUES ('Administrador', 'admin@joystream.com', 'e5a7c3675b18d36839bae6f78793baa0');  -- MD5 hash for demonstration

-- Add some sample game genres (optional)
CREATE TABLE IF NOT EXISTS generos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO generos (nome) VALUES 
('Ação'),
('Aventura'),
('RPG'),
('Estratégia'),
('Esporte'),
('Corrida'),
('Simulação'),
('FPS'),
('Puzzle'),
('Plataforma');

-- Add some sample platforms (optional)
CREATE TABLE IF NOT EXISTS plataformas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO plataformas (nome) VALUES 
('PC'),
('PlayStation 5'),
('PlayStation 4'),
('Xbox Series X/S'),
('Xbox One'),
('Nintendo Switch'),
('Mobile');

-- Create table for user support tickets
CREATE TABLE IF NOT EXISTS suporte_tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    assunto VARCHAR(200) NOT NULL,
    mensagem TEXT NOT NULL,
    status ENUM('Aberto', 'Em Andamento', 'Resolvido', 'Fechado') DEFAULT 'Aberto',
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
); 