# README

DevExchange API is a powerful and secure Rails backend, backed by PostgreSQL, designed to fuel an engaging, Stack Overflow-inspired platform. With seamless Devise-JWT authentication. This API empowers frontend clients with rich features, including user profiles, dynamic question-and-answer interactions, versatile tagging, lively comment threads, and intuitive voting capabilities—all the essential tools to create a vibrant and collaborative Q&A community.

## Getting Started

### Prerequisites

- Ruby version: `3.2.4`
- Rails version: `7.1.3`
- PostgreSQL

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/aneldanza/dev-exchange-api.git
   cd dev-exchange-api
   ```

2. Set up database passwords:

   Ensure you have your database passwords set up in your environment variables. Update `database.yml` file accordingly.

3. Install dependencies:

   ```sh
   bundle install
   ```

4. Set up the database:

   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

5. Start the Rails server:
   ```sh
   rails server
   ```

## API Documentation

### Authentication

#### JWT Token Authentication Devise and devise-jwt

This application uses `devise-jwt` for authentication, and the tokens are stored in HTTP-only cookies to enhance security.

#### How It Works

- **Login**: When a user logs in, the server generates a JWT token and sends it back to the client.
- **Authenticated Requests**: The client includes a header containing the JWT token for subsequent requests. The server verifies the token to authenticate the user.
- **Logout**: The client can clear the token from local-storage to log out.
