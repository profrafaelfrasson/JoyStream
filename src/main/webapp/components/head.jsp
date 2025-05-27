<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Variáveis dinâmicas para SEO e compartilhamento social
    String pageTitle = (String) request.getAttribute("pageTitle");
    String pageDescription = (String) request.getAttribute("pageDescription");
    String pageKeywords = (String) request.getAttribute("pageKeywords");
    String pageImage = (String) request.getAttribute("pageImage");
    String pageUrl = request.getRequestURL().toString();

    // Valores padrão
    String defaultTitle = "JoyStream - Recomende e descubra jogos";
    String defaultDescription = "Descubra, recomende e compartilhe seus jogos favoritos na JoyStream. A melhor plataforma para encontrar novos jogos baseados em seus gostos.";
    String defaultKeywords = "jogos, games, recomendações de jogos, gaming, plataforma de jogos, comunidade gamer";
    String defaultImage = request.getContextPath() + "/assets/img/logo.png";

    // Usar valores padrão se as variáveis estiverem vazias
    pageTitle = (pageTitle != null && !pageTitle.trim().isEmpty()) ? pageTitle : defaultTitle;
    pageDescription = (pageDescription != null && !pageDescription.trim().isEmpty()) ? pageDescription : defaultDescription;
    pageKeywords = (pageKeywords != null && !pageKeywords.trim().isEmpty()) ? pageKeywords : defaultKeywords;
    pageImage = (pageImage != null && !pageImage.trim().isEmpty()) ? pageImage : defaultImage;
%>

<!-- Metadados básicos -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title><%= pageTitle %></title>
<meta name="description" content="<%= pageDescription %>">
<meta name="keywords" content="<%= pageKeywords %>">

<!-- Favicon e ícones -->
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/logo.ico">
<link rel="apple-touch-icon" sizes="180x180" href="<%= request.getContextPath() %>/assets/img/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="<%= request.getContextPath() %>/assets/img/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="<%= request.getContextPath() %>/assets/img/favicon-16x16.png">

<!-- SEO tags -->
<link rel="canonical" href="<%= pageUrl %>">
<meta name="robots" content="index, follow">
<meta name="author" content="JoyStream">
<meta name="language" content="pt-BR">

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="<%= pageUrl %>">
<meta property="og:title" content="<%= pageTitle %>">
<meta property="og:description" content="<%= pageDescription %>">
<meta property="og:image" content="<%= pageImage %>">
<meta property="og:locale" content="pt_BR">
<meta property="og:site_name" content="JoyStream">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:url" content="<%= pageUrl %>">
<meta name="twitter:title" content="<%= pageTitle %>">
<meta name="twitter:description" content="<%= pageDescription %>">
<meta name="twitter:image" content="<%= pageImage %>">

<!-- Preconnect para recursos externos -->
<link rel="preconnect" href="https://cdnjs.cloudflare.com">
<link rel="preconnect" href="https://cdn.jsdelivr.net">

<!-- CSS -->
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<!-- Structured Data / JSON-LD -->
<script type="application/ld+json">
{
    "@context": "http://schema.org",
    "@type": "WebSite",
    "name": "JoyStream",
    "url": "<%= request.getScheme() + "://" + request.getServerName() + request.getContextPath() %>",
    "description": "<%= defaultDescription %>",
    "potentialAction": {
        "@type": "SearchAction",
        "target": "<%= request.getScheme() + "://" + request.getServerName() + request.getContextPath() %>/jogos?busca={search_term}",
        "query-input": "required name=search_term"
    }
}
</script> 