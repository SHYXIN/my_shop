
#############################
# Sandbox management commands
#############################
sandbox: install build_sandbox ## Install requirements and create a sandbox

build_sandbox: sandbox_clean sandbox_load_user sandbox_load_data ## Creates a sandbox from scratch

sandbox_clean: ## Clean sandbox images,cache,static and database
	# Remove media
	rm -rf media/images
	rm -rf media/cache
	rm -rf static
	rm -f db.sqlite3
	# Create database
	python manage.py migrate
	sleep 2

sandbox_load_user: ## Load user data into sandboxd
	python manage.py loaddata fixtures/auth.json

sandbox_load_data: ## Import fixtures and collect static
	# Import some fixtures. Order is important as JSON fixtures include primary keys
	python manage.py loaddata fixtures/child_products.json
	python manage.py oscar_import_catalogue fixtures/*.csv
	python manage.py oscar_import_catalogue_images fixtures/images.tar.gz
	python manage.py oscar_populate_countries --initial-only
	python manage.py loaddata fixtures/pages.json fixtures/ranges.json fixtures/offers.json
	python manage.py loaddata fixtures/orders.json
	python manage.py clear_index --noinput
	python manage.py update_index catalogue
	python manage.py thumbnail cleanup
	python manage.py collectstatic --noinput

