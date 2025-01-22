# README

This README documents the steps necessary to get the application up and running and provides API documentation for the available endpoints.

## Getting Started

### Prerequisites

- Ruby version: `3.2.4`
- Rails version: `7.1.3`
- PostgreSQL

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/aneldanza/dev-exchange-api.git
   cd your-project
   ```

2. Install dependencies:

   ```sh
   bundle install
   ```

3. Set up the database:

   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the Rails server:
   ```sh
   rails server
   ```

## API Documentation

### Authentication

#### JWT Token Authentication with HTTP-only Cookies using Devise and devise-jwt

This application uses `devise-jwt` for authentication, and the tokens are stored in HTTP-only cookies to enhance security.

#### How It Works

- **Login**: When a user logs in, the server generates a JWT token and sends it back to the client in an HTTP-only cookie.
- **Authenticated Requests**: For subsequent requests, the client sends the HTTP-only cookie containing the JWT token. The server verifies the token to authenticate the user.
- **Logout**: To log out, the client can clear the HTTP-only cookie.
