package com.joystream.controller;

import com.joystream.dao.UsuarioDAO;
import com.joystream.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/CadastroServlet")
public class CadastroServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        Usuario usuario = new Usuario();
        usuario.setNome(nome);
        usuario.setEmail(email);
        usuario.setSenha(senha);

        UsuarioDAO dao = new UsuarioDAO();
        boolean sucesso = dao.cadastrar(usuario);

        if (sucesso) {
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("erroCadastro", "E-mail já cadastrado!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("cadastro.jsp");
            dispatcher.forward(request, response);
        }
    }
}
