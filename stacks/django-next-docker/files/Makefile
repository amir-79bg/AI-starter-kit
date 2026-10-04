.PHONY: up down logs migrate superuser test

up:
	docker compose up --build

down:
	docker compose down

logs:
	docker compose logs -f

migrate:
	docker compose exec backend python manage.py makemigrations
	docker compose exec backend python manage.py migrate

superuser:
	docker compose exec backend python manage.py createsuperuser

test:
	docker compose exec backend python manage.py test
	docker compose exec frontend npm run lint

