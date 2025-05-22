package com.joystream.controller;

import com.joystream.dao.UsuarioDAO;
import com.joystream.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding para UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Verificar se já existe uma sessão ativa
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            response.sendRedirect("home.jsp");
            return;
        }

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        // Normalizar o email para garantir consistência
        email = email.toLowerCase().trim();
        senha = senha.trim();

        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuario = dao.login(email, senha);

        if (usuario != null) {
            // Criar nova sessão
            session = request.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setAttribute("nome", usuario.getNome());
            session.setAttribute("email", usuario.getEmail());
            
            // Limpar qualquer mensagem de erro anterior
            session.removeAttribute("erroLogin");
            
            response.sendRedirect("home.jsp");
        } else {
            // Login falhou - usar RequestDispatcher para manter a mensagem de erro
            request.setAttribute("erroLogin", "Email ou senha incorretos!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}