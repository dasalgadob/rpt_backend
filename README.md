# RPT Backend API

This is a Ruby on Rails API-only application with PostgreSQL database, configured for Docker development.

## Docker Development Setup

### Prerequisites
- Docker
- Docker Compose

### Getting Started

1. **Build and start the services:**
   ```bash
   docker-compose up --build
   ```

2. **Create and migrate the database:**
   ```bash
   docker-compose exec web bundle exec rails db:create db:migrate
   ```

3. **Access the application:**
   - API: http://localhost:3010
   - PostgreSQL: localhost:5434

### Useful Docker Commands

- **Start services:** `docker-compose up`
- **Stop services:** `docker-compose down`
- **Run Rails commands:** `docker-compose exec web bundle exec rails [command]`
- **Access Rails console:** `docker-compose exec web bundle exec rails console`
- **Run tests:** `docker-compose exec web bundle exec rails test`
- **View logs:** `docker-compose logs web`

## Configuration

* Ruby version: 3.0.2
* Database: PostgreSQL 15
* Rails version: 7.1.5
