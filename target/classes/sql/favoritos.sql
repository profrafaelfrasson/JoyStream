CREATE TABLE IF NOT EXISTS favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    jogo_id INT NOT NULL,
    nome_jogo VARCHAR(255) NOT NULL,
    imagem_url TEXT,
    data_lancamento DATE,
    nota INT,
    data_favoritado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    UNIQUE KEY unique_favorito (usuario_id, jogo_id)
); 