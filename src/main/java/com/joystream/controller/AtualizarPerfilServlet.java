package com.joystream.controller;

import com.joystream.dao.UsuarioDAO;
import com.joystream.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

@WebServlet("/atualizar-perfil")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
public class AtualizarPerfilServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configurar encoding para UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Verificar se o usuário está logado
        HttpSession session = request.getSession();
        Usuario usuarioAtual = (Usuario) session.getAttribute("usuario");
        if (usuarioAtual == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Obter parâmetros do formulário
        String nome = request.getParameter("nome");
        String senha = request.getParameter("senha");
        String senhaAtual = request.getParameter("senhaAtual");
        Part avatarPart = request.getPart("avatar");

        // Validar nome
        if (nome == null || nome.trim().isEmpty()) {
            request.setAttribute("erro", "O nome não pode estar vazio!");
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
            return;
        }

        // Processar avatar se foi enviado
        String avatarBase64 = null;
        if (avatarPart != null && avatarPart.getSize() > 0) {
            try (InputStream inputStream = avatarPart.getInputStream()) {
                java.io.ByteArrayOutputStream buffer = new java.io.ByteArrayOutputStream();
                int nRead;
                byte[] data = new byte[16384];
                while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                buffer.flush();
                byte[] bytes = buffer.toByteArray();
                avatarBase64 = Base64.getEncoder().encodeToString(bytes);
            }
        } else {
            // Se não enviou novo avatar, mantém o antigo
            avatarBase64 = usuarioAtual.getAvatar();
        }

        // Buscar usuário atualizado do banco para garantir senha correta
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuarioBanco = dao.buscarPorEmail(usuarioAtual.getEmail());

        usuarioAtual.setNome(nome);
        usuarioAtual.setAvatar(avatarBase64);

        // Se o usuário quer alterar a senha
        if (senha != null && !senha.trim().isEmpty()) {
            System.out.println("Senha atual digitada: [" + senhaAtual + "]");
            System.out.println("Senha no banco: [" + usuarioBanco.getSenha() + "]");
            if (senhaAtual == null || senhaAtual.isEmpty() || !senhaAtual.equals(usuarioBanco.getSenha())) {
                request.setAttribute("erro", "Para alterar a senha, informe corretamente sua senha atual.");
                request.getRequestDispatcher("perfil.jsp").forward(request, response);
                return;
            }
            usuarioAtual.setSenha(senha);
        } else {
            usuarioAtual.setSenha(usuarioBanco.getSenha());
        }

        // Atualizar no banco de dados
        boolean sucesso = dao.atualizarPerfil(usuarioAtual);

        if (sucesso) {
            // Atualizar sessão
            session.setAttribute("usuario", usuarioAtual);
            session.setAttribute("nome", usuarioAtual.getNome());
            
            // Redirecionar com mensagem de sucesso
            response.sendRedirect("perfil.jsp?sucesso=true");
        } else {
            request.setAttribute("erro", "Erro ao atualizar perfil!");
            request.getRequestDispatcher("perfil.jsp").forward(request, response);
        }
    }
} 