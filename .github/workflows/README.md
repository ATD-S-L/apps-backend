# GitHub Actions Workflows

Este directorio contiene los workflows de CI/CD para ATD-S-L.

## Archivos

- `test.yml` - Linting, unit tests, coverage
- `build.yml` - Build y quality analysis
- `deploy.yml` - Deployment a producción
- `lint.yml` - Code quality checks (firmware)
- `binary.yml` - Build binaries for release (firmware)
- `publish.yml` - Publish to npm (libraries)

## Customización

Cada workflow es una template base. Personalizar según tu proyecto:

### Por Repositorio

#### apps-backend
- Cambiar Node versions en matriz
- Configurar SonarQube si es necesario
- Ajustar pasos de deploy

#### apps-frontend
- Cambiar Node versions
- Configurar Lighthouse CI
- Ajustar E2E testing framework
- Configurar CDN deployment

#### firmware-esp32
- Cambiar boards en matriz
- Ajustar PlatformIO settings
- Configurar deployment

#### core-libraries
- Mantener test comprehensive
- Configurar NPM_TOKEN
- Ajustar scope de publicación

## Variables de Entorno

Configurar en GitHub Settings > Secrets:

```
NPM_TOKEN          - Para npm publish
SONAR_TOKEN        - Para SonarQube
GITHUB_TOKEN       - Auto-provisioned
```

## Artifact Retention

- Coverage reports: 30 días
- Build artifacts: 30 días
- E2E results: 30 días
- Firmware binaries: 90 días

## Triggering Workflows Manualmente

```bash
# Desde la línea de comando con GitHub CLI
gh workflow run test.yml -f ref=main
gh workflow run build.yml --ref main
```

## Debugging

1. Ve a Actions tab en GitHub
2. Selecciona el workflow
3. Click en el run específico
4. Expande cualquier step para ver logs detallados

---

Para más información, ver [CICD_SETUP_GUIDE.md](../CICD_SETUP_GUIDE.md)
