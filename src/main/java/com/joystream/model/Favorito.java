package com.joystream.model;

import java.sql.Timestamp;

public class Favorito {
    private Integer idFavorito;
    private Integer idUsuario;
    private Integer idJogo;
    private Timestamp dtFavoritado;
    private boolean concluido;
    private Avaliacao avaliacao;

    // Construtores
    public Favorito() {}

    public Favorito(int idUsuario, int idJogo) {
        this.idUsuario = idUsuario;
        this.idJogo = idJogo;
        this.concluido = false;
    }

    // Getters e Setters
    public Integer getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(Integer idFavorito) {
        this.idFavorito = idFavorito;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Integer getIdJogo() {
        return idJogo;
    }

    public void setIdJogo(Integer idJogo) {
        this.idJogo = idJogo;
    }

    public Timestamp getDtFavoritado() {
        return dtFavoritado;
    }

    public void setDtFavoritado(Timestamp dtFavoritado) {
        this.dtFavoritado = dtFavoritado;
    }

    public boolean isConcluido() {
        return concluido;
    }

    public void setConcluido(boolean concluido) {
        this.concluido = concluido;
    }

    public Avaliacao getAvaliacao() {
        return avaliacao;
    }

    public void setAvaliacao(Avaliacao avaliacao) {
        this.avaliacao = avaliacao;
    }
} 