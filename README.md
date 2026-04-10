# mcp-server-wp-engine

WordPress site managed via GitHub Actions + WP Engine.

## Getting Started

1. Clone the repo: `git clone https://github.com/aatifwaza-tru/mcp-server-wp-engine.git`
2. Check out the `dev` branch: `git checkout dev`
3. Add the required GitHub Secrets (see below)
4. Push to `dev` to trigger a deployment to the development environment

## Branches

| Branch | Environment |
|--------|-------------|
| `main` | Production |
| `stg`  | Staging |
| `qa`   | QA / Staging (parallel) |
| `dev`  | Development |

## Merge Order

Changes must flow through environments in this order:

```
dev → stg → main
qa  → stg → main
```

Direct merges to `main` or `stg` from unrecognised branches are blocked by the `branch-check.yml` workflow.

## CI/CD Pipeline

Every push to a deployment branch triggers the following:

1. **PHP Lint** — scans all `.php` files for syntax errors
2. **Deploy** — pushes to the corresponding WP Engine environment via SSH

## Local Development

- Use a local WordPress environment (e.g. [LocalWP](https://localwp.com/) or [Lando](https://lando.dev/))
- Install dependencies with `composer install` if a `composer.json` is present
- Run PHP lint locally: `find . -name "*.php" -not -path "./vendor/*" | xargs php -l`

## Required GitHub Secrets

Add these under **Repo → Settings → Secrets → Actions**:

| Secret | Description |
|--------|-------------|
| `WPE_SSHG_KEY_PRIVATE` | Base64-encoded SSH private key |
| `WPE_PROD_ENV_NAME` | WP Engine production install name |
| `WPE_STAGING_ENV_NAME` | WP Engine staging install name |
| `WPE_DEV_ENV_NAME` | WP Engine development install name |

## WP Engine Setup

1. Create `production`, `staging`, and `development` environments in the WP Engine portal
2. Add your SSH public key under **Settings → SSH Keys**

## Workflows

- `.github/workflows/deploy.yml` — PHP lint + WP Engine SSH deploy
- `.github/workflows/branch-check.yml` — enforces merge order on PRs
