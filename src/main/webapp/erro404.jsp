<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Página não encontrada</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 2rem;
            background: linear-gradient(135deg, var(--color-bg-darker) 0%, var(--color-bg-dark) 100%);
        }

        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: var(--color-primary);
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            margin-bottom: 1rem;
            animation: pulse 2s infinite;
        }

        .error-message {
            font-size: 1.5rem;
            color: var(--color-text);
            margin-bottom: 2rem;
        }

        .error-description {
            color: #888;
            margin-bottom: 2rem;
            max-width: 600px;
        }

        .back-button {
            padding: 1rem 2rem;
            background-color: var(--color-primary);
            color: #000;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(241, 196, 15, 0.3);
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        @media (max-width: 768px) {
            .error-code {
                font-size: 6rem;
            }

            .error-message {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-message">Página não encontrada</h1>
        <p class="error-description">
            Ops! Parece que você se perdeu no caminho. A página que você está procurando não existe ou foi movida.
        </p>
        <a href="<%= request.getContextPath() %>/home.jsp" class="back-button">Voltar para Home</a>
    </div>
</body>
</html>
