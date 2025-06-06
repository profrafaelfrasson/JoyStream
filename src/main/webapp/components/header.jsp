<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.joystream.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logado = (usuario != null);
    String avatarUrl = (usuario != null && usuario.getAvatar() != null && !usuario.getAvatar().isEmpty()) ? 
        ("data:image/png;base64," + usuario.getAvatar()) : 
        (request.getContextPath() + "/assets/img/default-avatar.png");
    
    // Identificar a página atual
    String currentPage = request.getServletPath();
    currentPage = currentPage.substring(currentPage.lastIndexOf("/") + 1);
%>

<style>
    header {
        background-color: #1f1f1f;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 15px 30px;
    }

    header img {
        height: 53px;
    }

    nav {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .nav-links {
        display: flex;
        gap: 20px;
    }

    .nav-links a {
        color: white;
        text-decoration: none;
        font-weight: 500;
        padding: 8px 15px;
        border-radius: 4px;
        transition: all 0.3s ease;
    }

    .nav-links a:hover {
        background-color: #2a2a2a;
    }

    /* Estilo para o item ativo do menu */
    .nav-links a.active {
        background-color: #f1c40f;
        color: #000;
    }

    .nav-links a.active:hover {
        background-color: #f39c12;
    }

    .dropdown {
        position: relative;
        display: inline-block;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        background-color: #2a2a2a;
        box-shadow: 0px 8px 16px rgba(0,0,0,0.3);
        z-index: 1;
        border-radius: 5px;
    }

    .dropdown-content a {
        color: white;
        padding: 10px;
        text-decoration: none;
        display: block;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
    }

    .user-name {
        color: #f1c40f;
        text-decoration: none;
        font-weight: bold;
        cursor: pointer;
        padding: 8px 15px;
        /* border-radius: 4px; */
        transition: background-color 0.3s;
    }

    .user-name:hover {
        background-color: #2a2a2a;
    }

    .auth-buttons {
        display: flex;
        gap: 10px;
    }

    .auth-buttons a {
        text-decoration: none;
        padding: 8px 15px;
        border-radius: 4px;
        font-weight: 500;
        transition: all 0.3s ease;
    }

    .btn-outline-warning {
        color: #f1c40f;
        border: 1px solid #f1c40f;
        background: transparent;
    }

    .btn-outline-warning:hover {
        background-color: #f1c40f;
        color: #000;
    }

    .btn-warning {
        background-color: #f1c40f;
        color: #000;
        border: 1px solid #f1c40f;
    }

    .btn-warning:hover {
        background-color: #f39c12;
        border-color: #f39c12;
    }

    /* Estilos para botões de autenticação ativos */
    .btn-outline-warning.active {
        background-color: #f1c40f !important;
        color: #000 !important;
        border-color: #f1c40f !important;
    }

    .btn-warning.active {
        background-color: #f39c12 !important;
        border-color: #f39c12 !important;
        color: #000 !important;
    }
</style>

<header>
    <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo JoyStream" draggable="false">
    <nav>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/home.jsp" class="<%= currentPage.equals("home.jsp") ? "active" : "" %>">HOME</a>
            <a href="<%= request.getContextPath() %>/jogos.jsp" class="<%= currentPage.equals("jogos.jsp") ? "active" : "" %>">JOGOS</a>
            <% if (logado) { %>
                <a href="<%= request.getContextPath() %>/favoritos.jsp" class="<%= currentPage.equals("favoritos.jsp") ? "active" : "" %>">FAVORITOS</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/suporte.jsp" class="<%= currentPage.equals("suporte.jsp") ? "active" : "" %>">SUPORTE</a>
            <a href="<%= request.getContextPath() %>/sobre.jsp" class="<%= currentPage.equals("sobre.jsp") ? "active" : "" %>">SOBRE</a>
        </div>
        <% if (logado) { %>
            <div class="dropdown">
                <div class="user-info">
                    <img src="<%= avatarUrl %>" alt="Avatar" draggable="false" class="user-avatar">
                    <span class="user-name"><%= usuario.getNmUsuario() %></span>
                </div>
                <div class="dropdown-content">
                    <a href="<%= request.getContextPath() %>/perfil.jsp" class="<%= currentPage.equals("perfil.jsp") ? "active" : "" %>">Meu Perfil</a>
                    <a href="<%= request.getContextPath() %>/favoritos.jsp" class="<%= currentPage.equals("favoritos.jsp") ? "active" : "" %>">Favoritos</a>
                    <a href="<%= request.getContextPath() %>/logout.jsp">Sair</a>
                </div>
            </div>
        <% } else { %>
            <div class="auth-buttons">
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-warning <%= currentPage.equals("login.jsp") ? "active" : "" %>">Login</a>
                <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-warning <%= currentPage.equals("cadastro.jsp") ? "active" : "" %>">Registrar</a>
            </div>
        <% } %>

        <!-- Menu Toggle Button -->
        <button class="menu-toggle" aria-label="Toggle menu">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </nav>
</header>

<!-- Mobile Navigation -->
<div class="mobile-nav">
    <div class="mobile-nav-content">
        <div class="mobile-nav-links">
            <a href="<%= request.getContextPath() %>/home.jsp" class="<%= currentPage.equals("home.jsp") ? "active" : "" %>">HOME</a>
            <a href="<%= request.getContextPath() %>/jogos.jsp" class="<%= currentPage.equals("jogos.jsp") ? "active" : "" %>">JOGOS</a>
            <% if (logado) { %>
                <a href="<%= request.getContextPath() %>/favoritos.jsp" class="<%= currentPage.equals("favoritos.jsp") ? "active" : "" %>">FAVORITOS</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/suporte.jsp" class="<%= currentPage.equals("suporte.jsp") ? "active" : "" %>">SUPORTE</a>
            <a href="<%= request.getContextPath() %>/sobre.jsp" class="<%= currentPage.equals("sobre.jsp") ? "active" : "" %>">SOBRE</a>
        </div>
        
        <% if (logado) { %>
            <div class="mobile-user-info">
                <img src="<%= avatarUrl %>" alt="Avatar" draggable="false" class="mobile-user-avatar">
                <span class="mobile-user-name"><%= usuario.getNmUsuario() %></span>
                <div class="mobile-auth-buttons">
                    <a href="<%= request.getContextPath() %>/perfil.jsp" class="btn btn-outline-warning <%= currentPage.equals("perfil.jsp") ? "active" : "" %>">Meu Perfil</a>
                    <a href="<%= request.getContextPath() %>/logout.jsp" class="btn btn-warning">Sair</a>
                </div>
            </div>
        <% } else { %>
            <div class="mobile-auth-buttons">
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-warning <%= currentPage.equals("login.jsp") ? "active" : "" %>">Login</a>
                <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-warning <%= currentPage.equals("cadastro.jsp") ? "active" : "" %>">Registrar</a>
            </div>
        <% } %>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.querySelector('.menu-toggle');
    const mobileNav = document.querySelector('.mobile-nav');
    const mobileNavContent = document.querySelector('.mobile-nav-content');
    let isOpen = false;

    function closeMenu() {
        if (!isOpen) return;
        isOpen = false;
        menuToggle.classList.remove('active');
        mobileNav.classList.remove('active');
        document.body.style.overflow = '';
    }

    function openMenu() {
        if (isOpen) return;
        isOpen = true;
        menuToggle.classList.add('active');
        mobileNav.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function toggleMenu(e) {
        e.stopPropagation();
        if (isOpen) {
            closeMenu();
        } else {
            openMenu();
        }
    }

    // Toggle menu on button click
    menuToggle.addEventListener('click', toggleMenu);

    // Close menu when clicking on links
    document.querySelectorAll('.mobile-nav-links a, .mobile-auth-buttons a').forEach(link => {
        link.addEventListener('click', closeMenu);
    });

    // Close menu when clicking outside
    document.addEventListener('click', function(e) {
        if (isOpen && !mobileNavContent.contains(e.target) && !menuToggle.contains(e.target)) {
            closeMenu();
        }
    });

    // Prevent menu from closing when clicking inside
    mobileNavContent.addEventListener('click', function(e) {
        e.stopPropagation();
    });

    // Close menu on escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && isOpen) {
            closeMenu();
        }
    });
});
</script> 