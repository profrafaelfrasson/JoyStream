package com.joystream.model;

import java.sql.Timestamp;

public class Avaliacao {
    private Integer idAvaliacao;
    private Integer idUsuario;
    private Integer idFavorito;
    private Integer nota;
    private String comentario;
    private Timestamp dtAvaliacao;
    private String nomeUsuario; // Campo adicional para exibição

    // Construtores
    public Avaliacao() {}

    public Avaliacao(int idUsuario, int idFavorito, int nota, String comentario) {
        this.idUsuario = idUsuario;
        this.idFavorito = idFavorito;
        this.nota = nota;
        this.comentario = comentario;
    }

    // Getters e Setters
    public Integer getIdAvaliacao() {
        return idAvaliacao;
    }

    public void setIdAvaliacao(Integer idAvaliacao) {
        this.idAvaliacao = idAvaliacao;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public Integer getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(Integer idFavorito) {
        this.idFavorito = idFavorito;
    }

    public Integer getNota() {
        return nota;
    }

    public void setNota(Integer nota) {
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

    public String getNomeUsuario() {
        return nomeUsuario;
    }

    public void setNomeUsuario(String nomeUsuario) {
        this.nomeUsuario = nomeUsuario;
    }
} 