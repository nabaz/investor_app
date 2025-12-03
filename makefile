# Makefile

.PHONY: build up down test

# Build and start containers
build:
	docker-compose up --build

# Start the app
up:
	docker-compose up

# Stop containers
down:
	docker-compose down

# Run all tests
test:
	docker-compose run --rm -e MIX_ENV=test -e DB_HOST=db app mix test