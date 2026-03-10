SHELL := bash
SCRIPT := ubuntu_cleaner.sh
TESTS := tests/ubuntu_cleaner.bats

.PHONY: lint format-check test validate install-runtime-deps install-dev-deps

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(SCRIPT); \
	else \
		echo "shellcheck nao instalado; pulando lint."; \
	fi

format-check:
	@if command -v shfmt >/dev/null 2>&1; then \
		shfmt -d $(SCRIPT) $(TESTS); \
	else \
		echo "shfmt nao instalado; pulando format-check."; \
	fi

test:
	@bash -n $(SCRIPT)
	@if command -v bats >/dev/null 2>&1; then \
		bats $(TESTS); \
	else \
		echo "bats nao instalado; execute os testes Bats manualmente quando estiver disponivel."; \
	fi

validate: lint format-check test

install-runtime-deps:
	sudo ./ubuntu_cleaner.sh --install-deps

install-dev-deps:
	sudo apt-get update
	sudo apt-get install -y shellcheck shfmt bats
