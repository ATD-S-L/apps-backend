# ATD-S-L CI/CD Setup Guide

Este documento proporciona una guía completa para el setup de CI/CD profesional para la organización ATD-S-L.

## 📋 Contenido

1. [Overview](#overview)
2. [Estructura de Workflows](#estructura-de-workflows)
3. [Configuración por Repositorio](#configuración-por-repositorio)
4. [Pre-commit Hooks](#pre-commit-hooks)
5. [Branch Protection](#branch-protection)
6. [Cómo Usar](#cómo-usar)
7. [Troubleshooting](#troubleshooting)

## Overview

El setup de CI/CD incluye:

- **GitHub Actions**: Workflows automáticos para testing, building y deployment
- **Pre-commit Hooks**: Validación local antes de commits
- **Branch Protection**: Reglas en la rama `main` para garantizar calidad
- **Reutilización de Templates**: Templates base que se adaptan a cada repositorio

### Repositorios Incluidos

1. **apps-backend**: Node.js backend con linting y tests
2. **apps-frontend**: React/Vue frontend con E2E y Lighthouse
3. **firmware-esp32**: Firmware ESP32 con PlatformIO
4. **core-libraries**: Librerías reutilizables publicadas en npm

## Estructura de Workflows

### Triggers Comunes

Todos los workflows están configurados para:

- **push a main**: Ejecución automática en cambios a main
- **pull_request a main**: Validación en PRs
- **workflow_dispatch**: Ejecución manual desde GitHub UI

### Workflows Estándar

#### `test.yml` - Testing y Linting

```yaml
Triggers: push main, PR, manual
Checks:
- Linting (ESLint, pylint, etc)
- Unit tests
- Coverage reports
- E2E tests (frontend)
```

#### `build.yml` - Build y Quality

```yaml
Triggers: push main, PR, manual
Checks:
- Build application
- SonarQube analysis (backend)
- Lighthouse performance (frontend)
- Upload artifacts
```

#### `deploy.yml` - Deployment

```yaml
Triggers: push main, workflow_run:Build
Actions:
- Deploy to production
- Notifications en Issues
```

#### `lint.yml` - Code Quality (firmware)

```yaml
PlatformIO analysis
Code quality checks
```

#### `binary.yml` - Binary Release (firmware)

```yaml
Build para múltiples boards
Create GitHub Release
```

#### `publish.yml` - npm Publishing (libraries)

```yaml
Publish a npm registry
GitHub Packages
Create Release
```

## Configuración por Repositorio

### apps-backend

**Workflows:** `test.yml`, `build.yml`, `deploy.yml`

**Node versions:** 18.x, 20.x

**Scripts requeridos en package.json:**
```json
{
  "scripts": {
    "lint": "eslint . --ext .js,.ts",
    "test:unit": "jest",
    "test:coverage": "jest --coverage",
    "build": "tsc && webpack"
  }
}
```

**Personalización:**
- Cambiar Node versions en la matriz
- Configurar SonarQube token en GitHub Secrets
- Ajustar pasos de deploy según infraestructura

### apps-frontend

**Workflows:** `test.yml`, `build.yml`, `deploy.yml`

**Node versions:** 18.x, 20.x

**Scripts requeridos:**
```json
{
  "scripts": {
    "lint": "eslint .",
    "test:unit": "jest",
    "test:e2e": "playwright test",
    "build": "vite build"
  }
}
```

**Personalización:**
- Configurar Lighthouse CI con `.lighthouseci/lighthouserc.json`
- Ajustar E2E testing tool según framework
- Configurar deployment a CDN (Netlify, Vercel, S3)

### firmware-esp32

**Workflows:** `test.yml`, `lint.yml`, `binary.yml`

**Requisitos:**
- `platformio.ini` configurado
- Python 3.11+

**Personalización:**
- Cambiar boards en la matriz de `binary.yml`
- Agregar targets adicionales en `platformio.ini`
- Configurar deployment de binarios

### core-libraries

**Workflows:** `test.yml`, `publish.yml`

**Node versions:** 18.x, 20.x

**Scripts requeridos:**
```json
{
  "scripts": {
    "lint": "eslint .",
    "test": "jest",
    "test:integration": "jest --testPathPattern=integration",
    "test:coverage": "jest --coverage",
    "build": "tsc"
  }
}
```

**Personalización:**
- Configurar NPM_TOKEN en GitHub Secrets
- Ajustar scope de publicación en `package.json`

## Pre-commit Hooks

### Instalación

```bash
# Instalar dependencias
npm install

# Husky se inicializa automáticamente con "npm install"
# Si no funciona, ejecutar:
npx husky install
```

### Hooks Configurados

1. **pre-commit**: Lint y format de archivos staged
2. **commit-msg**: Validación de mensaje de commit

### Configuración Personalizada

Editar `.lintstagedrc.json` para cambiar qué archivos se validan:

```json
{
  "*.js": ["eslint --fix", "prettier --write"],
  "*.ts": ["eslint --fix", "prettier --write"]
}
```

### Reglas de Commit Message

Usar [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Tipos válidos:** feat, fix, docs, style, refactor, perf, test, chore, ci, revert

**Ejemplos:**
```
feat(api): add user authentication endpoint
fix(frontend): resolve styling issue in button component
docs: update README with setup instructions
chore(deps): upgrade dependencies
```

## Branch Protection

### Configuración Automática

Ejecutar el script de configuración:

**Bash/Linux:**
```bash
./scripts/configure-branch-protection.sh ATD-S-L apps-backend $GITHUB_TOKEN
```

**PowerShell/Windows:**
```powershell
./scripts/configure-branch-protection.ps1 -Owner "ATD-S-L" -Repo "apps-backend" -Token $env:GITHUB_TOKEN
```

### Reglas Aplicadas

- ✅ Require PR reviews (1 aprobación)
- ✅ Dismiss stale PR reviews
- ✅ Require status checks to pass
- ✅ Require branches to be up to date
- ✅ Enforce admins
- ✅ Allow auto merge
- ❌ No force push
- ❌ No deletions

## Cómo Usar

### 1. Clonar Repositorio

```bash
git clone https://github.com/ATD-S-L/apps-backend.git
cd apps-backend
```

### 2. Instalar Dependencias

```bash
npm install
```

Esto configura automáticamente los husky hooks.

### 3. Trabajar Localmente

```bash
# Crear rama feature
git checkout -b feature/nueva-funcionalidad

# Hacer cambios
# Husky pre-commit hooks se ejecutarán automáticamente
git add .
git commit -m "feat: add nueva funcionalidad"

# Los cambios se validan automáticamente
```

### 4. Push y PR

```bash
git push origin feature/nueva-funcionalidad
```

Luego abrir PR en GitHub. Los workflows se ejecutarán automáticamente.

### 5. Revisar Status de Workflows

En la PR, bajo "Checks", verás el status de:
- ✅ Test (Lint + Unit Tests + Coverage)
- ✅ Build (Build + SonarQube/Lighthouse)
- ✅ Deploy (después de merge a main)

### 6. Merge a Main

- Requiere 1 aprobación
- Todos los checks deben pasar
- Rama debe estar actualizada

## Troubleshooting

### Pre-commit hooks no se ejecutan

```bash
# Reinstalar husky
npx husky install

# Verificar permisos
chmod +x .husky/pre-commit
chmod +x .husky/commit-msg
```

### Workflow falla pero no sé por qué

1. Ir a **Actions** tab en GitHub
2. Click en el workflow que falló
3. Ver logs detallados en cada step
4. Buscar errores específicos

### SonarQube/Lighthouse no configurados

Son placeholders. Para usar realmente:

**SonarQube:**
1. Crear cuenta en sonarcloud.io
2. Añadir `SONAR_TOKEN` a GitHub Secrets
3. Descomentar steps en `build.yml`

**Lighthouse:**
1. Crear `.lighthouseci/lighthouserc.json`
2. Configurar servidor de test
3. Descomentar steps en `build.yml`

### Commit mensaje rejected

Ver si cumple con [Conventional Commits](https://www.conventionalcommits.org/):

❌ `git commit -m "arreglar bug"`
✅ `git commit -m "fix: resolver bug en autenticación"`

### Branch protection no funciona

```bash
# Verificar token tiene permisos
# Debe tener scopes: repo, workflow

# Ejecutar script de nuevo
./scripts/configure-branch-protection.sh ATD-S-L apps-backend $GITHUB_TOKEN
```

## Secrets Requeridos

Configurar en GitHub Settings > Secrets:

- `NPM_TOKEN`: Para publicar en npm (core-libraries)
- `SONAR_TOKEN`: Para SonarQube (apps-backend)
- `GITHUB_TOKEN`: Auto-provisioned por GitHub

## Recursos

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Husky](https://typicode.github.io/husky/)
- [Commitlint](https://commitlint.js.org/)
- [Pre-commit Framework](https://pre-commit.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

**Última actualización:** 2026-11-12
**Rama:** setup-cicd
**Versión:** 1.0.0
