# ATD-S-L Development Environment Setup
# Run: make setup

.PHONY: help setup install lint lint-fix format test test-watch build clean dev

help:
	@echo "ATD-S-L apps-backend Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make setup          - Install dependencies and configure git hooks"
	@echo "  make install        - Install npm dependencies only"
	@echo ""
	@echo "Development:"
	@echo "  make dev            - Start development server (watch mode)"
	@echo "  make lint           - Run ESLint on src/"
	@echo "  make lint-fix       - Fix ESLint issues automatically"
	@echo "  make format         - Format code with Prettier"
	@echo "  make test           - Run tests once"
	@echo "  make test-watch     - Run tests in watch mode"
	@echo "  make build          - Build project for production"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean          - Remove generated files and cache"
	@echo "  make pre-commit     - Run pre-commit checks"
	@echo ""

setup:
	@echo "📦 Installing dependencies..."
	npm install
	@echo "🔧 Configuring git hooks..."
	npx husky install
	npx husky add .husky/pre-commit "npm run pre-commit"
	npx husky add .husky/commit-msg "npm run validate-commit"
	@echo "✅ Setup complete!"

install:
	npm install

dev:
	npm run dev

lint:
	npx eslint src/ --max-warnings 0

lint-fix:
	npx eslint src/ --fix

format:
	npx prettier --write src/ tests/

test:
	npm test -- --coverage

test-watch:
	npm test -- --watch

build:
	npm run build

clean:
	rm -rf node_modules .eslintcache coverage dist

pre-commit:
	npm run lint && npm run format && npm test

.DEFAULT_GOAL := help
