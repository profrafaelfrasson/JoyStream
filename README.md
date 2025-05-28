# JoyStream

## 📝 Descrição
JoyStream é uma plataforma web para descoberta e recomendação de jogos, onde os usuários podem encontrar, favoritar e receber recomendações personalizadas de jogos com base em seus interesses.

## 🚀 Tecnologias Utilizadas
- Java 11
- Maven
- Apache Tomcat
- Servlet API 4.0.1
- JSTL 1.2
- MySQL Connector 8.0.33
- BCrypt 0.4 (para hash de senhas)
- Bootstrap (Frontend)
- FontAwesome (Ícones)

## 📋 Pré-requisitos
- Java JDK 11 ou superior
- Maven 3.6 ou superior
- Apache Tomcat 9.x
- MySQL 8.0 ou superior (caso queira criar um banco local e náo apontar pro remoto ou se ele estiver indisponível)
- IDE de sua preferência (recomendamos IntelliJ IDEA ou Eclipse)

## 🔧 Configuração do Ambiente

### 1. Configuração do Maven
1. Clone o repositório:
```bash
git clone [https://github.com/profrafaelfrasson/JoyStream]
cd joystream
```

2. Instale as dependências:
```bash
mvn clean install
```

### 2. Configuração do Banco de Dados
1. Configure o MySQL 8.0 ou superior
2. Importe o schema do banco de dados

### 3. Configuração do Tomcat
1. Configure o Tomcat em sua IDE
2. Adicione o projeto como uma aplicação web
3. Configure o contexto da aplicação para `/joystream`

## 🏃‍♂️ Executando o Projeto
1. Execute o Tomcat através da sua IDE
2. Acesse a aplicação em: `http://localhost:8080/joystream`

## 📦 Estrutura do Projeto
```
joystream/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── joystream/
│   │   │           ├── controller/    # Servlets e controladores
│   │   │           ├── dao/          # Camada de acesso a dados
│   │   │           ├── model/        # Classes de modelo
│   │   │           └── service/      # Lógica de negócios
│   │   ├── resources/               # Recursos e configurações
│   │   └── webapp/
│   │       ├── assets/             # Recursos estáticos (CSS, JS, imagens)
│   │       ├── components/         # Componentes JSP reutilizáveis
│   │       └── WEB-INF/           # Configurações da aplicação web
└── pom.xml                        # Configuração do Maven
```

## 🌟 Funcionalidades Principais
- Sistema de autenticação de usuários
- Catálogo de jogos com informações detalhadas
- Sistema de recomendação personalizado
- Lista de jogos favoritos
- Interface responsiva e moderna
- Integração com sistema de pontuação Metacritic
- Filtragem por gêneros e plataformas

## 🔒 Segurança
- Senhas criptografadas com BCrypt
- Proteção contra SQL Injection
- Validação de formulários no cliente e servidor
- Sessões seguras
- Sanitização de dados de entrada

## 📝 Notas de Desenvolvimento
- O sistema de recomendação utiliza algoritmos baseados nos jogos favoritos do usuário
- A interface foi desenvolvida com foco em UX e responsividade
- Implementação de SEO básico nas páginas principais
- Sistema de logging para monitoramento e debugging

## 🤝 Contribuindo
1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 📧 Contato
Para problemas e sugestões, por favor abra uma issue no repositório do projeto. 