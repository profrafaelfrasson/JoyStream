package com.joystream.model;

import java.sql.Timestamp;

public class Favorito {
    private int idFavorito;
    private int idUsuario;
    private int idJogo;
    private Timestamp dtFavoritado;

    // Construtores
    public Favorito() {}

    public Favorito(int idUsuario, int idJogo) {
        this.idUsuario = idUsuario;
        this.idJogo = idJogo;
    }

    // Getters e Setters
    public int getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(int idFavorito) {
        this.idFavorito = idFavorito;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdJogo() {
        return idJogo;
    }

    public void setIdJogo(int idJogo) {
        this.idJogo = idJogo;
    }

    public Timestamp getDtFavoritado() {
        return dtFavoritado;
    }

    public void setDtFavoritado(Timestamp dtFavoritado) {
        this.dtFavoritado = dtFavoritado;
    }
} 