SHELL := /bin/bash

# ── Metadata & Configuration ──────────────────────────────────────────────────
.PHONY: *

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ── Build Operations ──────────────────────────────────────────────────────────
build:  
	docker compose --profile all build 

# ── Runtime Control ───────────────────────────────────────────────────────────
up: 
	docker compose --profile all up -d

down: 
	docker compose --profile all down

restart: down up 

ps: 
	docker compose --profile all ps

logs:
	docker compose --profile all logs -f

tail: 
	docker compose logs -f | grep -iEv "(/health|/execute)"

# ── Maintenance & Clean ───────────────────────────────────────────────────────
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +

	docker system prune -f
