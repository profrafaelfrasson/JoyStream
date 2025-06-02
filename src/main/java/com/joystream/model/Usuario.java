package com.joystream.model;

import java.sql.Timestamp;

public class Usuario {
    private int idUsuario;
    private String nmUsuario;
    private String email;
    private String senha;
    private String avatar;
    private Timestamp dtCriacao;
    private Timestamp dtAtualizacao;

    public Usuario() {
    }

    public Usuario(String nmUsuario, String email, String senha) {
        this.nmUsuario = nmUsuario;
        this.email = email;
        this.senha = senha;
    }

    // Getters e Setters
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNmUsuario() { return nmUsuario; }
    public void setNmUsuario(String nmUsuario) { this.nmUsuario = nmUsuario; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public Timestamp getDtCriacao() { return dtCriacao; }
    public void setDtCriacao(Timestamp dtCriacao) { this.dtCriacao = dtCriacao; }

    public Timestamp getDtAtualizacao() { return dtAtualizacao; }
    public void setDtAtualizacao(Timestamp dtAtualizacao) { this.dtAtualizacao = dtAtualizacao; }
}