<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erro - Requisição Inválida</title>
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

        .error-icon {
            font-size: 5rem;
            color: #e67e22;
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
        }

        .error-code {
            font-size: 2.5rem;
            font-weight: bold;
            color: #e67e22;
            margin-bottom: 1rem;
        }

        .error-message {
            font-size: 1.5rem;
            color: var(--color-text);
            margin-bottom: 1.5rem;
        }

        .error-description {
            color: #888;
            margin-bottom: 2rem;
            max-width: 600px;
            line-height: 1.6;
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

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-20px); }
            60% { transform: translateY(-10px); }
        }

        @media (max-width: 768px) {
            .error-icon {
                font-size: 4rem;
            }

            .error-code {
                font-size: 2rem;
            }

            .error-message {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <div class="error-code">
            <%
                Integer statusCode = (Integer)request.getAttribute("javax.servlet.error.status_code");
                String errorMessage = (String)request.getAttribute("javax.servlet.error.message");
                if (statusCode != null) {
                    out.print("Erro " + statusCode);
                } else {
                    out.print("Erro");
                }
            %>
        </div>
        <h1 class="error-message">Requisição Inválida</h1>
        <p class="error-description">
            <%
                if (errorMessage != null && !errorMessage.isEmpty()) {
                    out.print(errorMessage);
                } else {
                    out.print("Desculpe, não foi possível processar sua solicitação. Por favor, verifique se a URL está correta e tente novamente.");
                }
            %>
        </p>
        <a href="<%= request.getContextPath() %>/home.jsp" class="back-button">Voltar para Home</a>
    </div>
</body>
</html> 