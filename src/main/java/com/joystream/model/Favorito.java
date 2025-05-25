package com.joystream.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Favorito {
    private int id;
    private int usuarioId;
    private int jogoId;
    private String nomeJogo;
    private String imagemUrl;
    private Date dataLancamento;
    private Integer nota;
    private Timestamp dataFavoritado;

    // Construtores
    public Favorito() {}

    public Favorito(int usuarioId, int jogoId, String nomeJogo, String imagemUrl, Date dataLancamento, Integer nota) {
        this.usuarioId = usuarioId;
        this.jogoId = jogoId;
        this.nomeJogo = nomeJogo;
        this.imagemUrl = imagemUrl;
        this.dataLancamento = dataLancamento;
        this.nota = nota;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public int getJogoId() {
        return jogoId;
    }

    public void setJogoId(int jogoId) {
        this.jogoId = jogoId;
    }

    public String getNomeJogo() {
        return nomeJogo;
    }

    public void setNomeJogo(String nomeJogo) {
        this.nomeJogo = nomeJogo;
    }

    public String getImagemUrl() {
        return imagemUrl;
    }

    public void setImagemUrl(String imagemUrl) {
        this.imagemUrl = imagemUrl;
    }

    public Date getDataLancamento() {
        return dataLancamento;
    }

    public void setDataLancamento(Date dataLancamento) {
        this.dataLancamento = dataLancamento;
    }

    public Integer getNota() {
        return nota;
    }

    public void setNota(Integer nota) {
        this.nota = nota;
    }

    public Timestamp getDataFavoritado() {
        return dataFavoritado;
    }

    public void setDataFavoritado(Timestamp dataFavoritado) {
        this.dataFavoritado = dataFavoritado;
    }
} 