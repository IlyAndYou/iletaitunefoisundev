build:
	$(MAKE) prepare-test
	$(MAKE) analyze
	$(MAKE) tests

it:
	${MAKE} prepare-dev
	${MAKE} analyse

tests:
	${MAKE} prepare-test
	sh vendor/bin/simple-phpunit


.PHONY: analyse
analyse: 
	npm audit
	composer valid
	php bin/console doctrine:schema:valid --skip-sync --env=test
	bin/phpcs

.PHONY: prepare-dev
prepare-dev:
	npm install
	npm run dev
	composer install --no-suggest --prefer-dist
	php bin/console doctrine:database:drop --if-exists -f --env=dev
	php bin/console doctrine:database:create --env=dev
	php bin/console doctrine:schema:update -f --env=dev
	php bin/console doctrine:fixtures:load -n --env=dev

prepare-test:
	npm install
	npm run dev
	composer install --prefer-dist
	php bin/console cache:clear --env=test
	php bin/console doctrine:database:drop --if-exists -f --env=test
	php bin/console doctrine:database:create --env=test
	php bin/console doctrine:schema:update -f --env=test
	php bin/console doctrine:fixtures:load -n --env=test