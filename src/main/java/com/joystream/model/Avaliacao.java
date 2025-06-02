package com.joystream.model;

import java.sql.Timestamp;

public class Avaliacao {
    private int idAvaliacao;
    private int idUsuario;
    private int idFavorito;
    private int nota;
    private String comentario;
    private Timestamp dtAvaliacao;

    // Construtores
    public Avaliacao() {}

    public Avaliacao(int idUsuario, int idFavorito, int nota, String comentario) {
        this.idUsuario = idUsuario;
        this.idFavorito = idFavorito;
        this.nota = nota;
        this.comentario = comentario;
    }

    // Getters e Setters
    public int getIdAvaliacao() {
        return idAvaliacao;
    }

    public void setIdAvaliacao(int idAvaliacao) {
        this.idAvaliacao = idAvaliacao;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(int idFavorito) {
        this.idFavorito = idFavorito;
    }

    public int getNota() {
        return nota;
    }

    public void setNota(int nota) {
        this.nota = nota;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public Timestamp getDtAvaliacao() {
        return dtAvaliacao;
    }

    public void setDtAvaliacao(Timestamp dtAvaliacao) {
        this.dtAvaliacao = dtAvaliacao;
    }
} 