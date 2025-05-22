package com.joystream.controller; 

import com.joystream.dao.UsuarioDAO;
import com.joystream.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;

@WebServlet("/CadastroServlet")
public class CadastroServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding para UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        // Normalizar o email apenas para minúsculas e remover espaços
        email = email.toLowerCase().trim();

        Usuario usuario = new Usuario();
        usuario.setNome(nome);
        usuario.setEmail(email);
        usuario.setSenha(senha);

        UsuarioDAO dao = new UsuarioDAO();
        boolean sucesso = dao.cadastrar(usuario);

        if (sucesso) {
            // Criar sessão e armazenar informações do usuário
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("nome", usuario.getNome());
            session.setAttribute("email", usuario.getEmail());
            
            response.sendRedirect("home.jsp");
        } else {
            request.setAttribute("erroCadastro", "E-mail já cadastrado!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("cadastro.jsp");
            dispatcher.forward(request, response);
        }
    }
}
