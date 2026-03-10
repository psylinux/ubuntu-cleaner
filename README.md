# Ubuntu-Cleaner

Script de limpeza para Ubuntu com foco em dois problemas diferentes:

1. Limpeza de sistema: `apt`, `journal`, `snap`, caches do `root`, lixeira e thumbnails.
2. Analise e limpeza de caches de ferramentas de desenvolvimento no `home`, com suporte a VSCode, Antigravity e Go.

O script roda em `dry-run` por padrao. Ele mostra o que seria limpo, exibe `df -h` antes e depois e calcula o total liberado. Para executar a limpeza de verdade, use `--apply`.

Ele foi pensado para rodar na sua maquina Ubuntu local e pode instalar as dependencias de runtime necessarias antes da limpeza.

## Principais recursos

- `dry-run` por padrao.
- instalacao de dependencias de runtime com `--install-deps`.
- `df -h` antes e depois da limpeza.
- total real liberado ao final, por filesystem e no total.
- modo `--analyze` com `df -hT`, `df -hi`, maiores diretorios e arquivos grandes.
- aviso quando VSCode ou Antigravity estao abertos.
- limpeza opcional de caches de VSCode, Antigravity e Go.
- deteccao e remocao opcional de versoes antigas duplicadas de extensoes.

## Uso

Analise e simulacao:

```bash
./ubuntu_cleaner.sh
./ubuntu_cleaner.sh --analyze
./ubuntu_cleaner.sh --include-vscode --include-antigravity --include-go
sudo ./ubuntu_cleaner.sh --install-deps
```

Aplicar limpeza:

```bash
sudo ./ubuntu_cleaner.sh --apply
sudo ./ubuntu_cleaner.sh --apply --journal-days 7 --snap-retain 3
sudo ./ubuntu_cleaner.sh --apply --include-vscode --include-antigravity --prune-duplicate-extensions
sudo ./ubuntu_cleaner.sh --apply --include-go
```

Ajuda completa:

```bash
./ubuntu_cleaner.sh --help
```

## O que o script limpa por padrao

Quando voce usa `--apply`, ele executa estes passos por padrao:

- `apt autoremove --purge -y`
- `apt clean`
- `journalctl --vacuum-time=<N>d`
- remocao de revisoes Snap `disabled`
- limpeza de `/var/lib/snapd/cache`
- limpeza de `/root/.cache`, `/root/.npm` e lixeira do `root`
- limpeza de thumbnails e lixeira do usuario principal

## Limpezas opcionais de desenvolvimento

Estas limpezas so entram quando voce pede explicitamente:

- `--include-vscode`
  - `~/.config/Code/CachedExtensionVSIXs`
  - `~/.config/Code/Cache`
  - `~/.config/Code/CachedData`
  - `~/.config/Code/Service Worker/CacheStorage`
  - caches graficos e de perfis
- `--include-antigravity`
  - `~/.config/Antigravity/Cache`
  - `~/.config/Antigravity/CachedData`
  - `~/.config/Antigravity/Service Worker/CacheStorage`
  - `~/.antigravity-server/data/CachedExtensionVSIXs`
  - cache de instalacao do `clangd`
- `--include-go`
  - `go clean -cache -modcache -testcache -fuzzcache`
- `--include-logs`
  - logs e `Crashpad` de VSCode e Antigravity
- `--prune-duplicate-extensions`
  - remove versoes antigas duplicadas em diretorios de extensoes

## Observacoes

- `--apply` requer `sudo`.
- `--install-deps` prepara as dependencias de runtime no Ubuntu local.
- `dry-run` e `--analyze` podem ser usados sem `sudo`.
- Se VSCode ou Antigravity estiverem abertos, o script avisa antes da limpeza.
- O total final liberado e medido por delta real de espaco livre nos filesystems tocados.

## Desenvolvimento

Dependencias locais recomendadas:

- `shellcheck`
- `shfmt`
- `bats`

Comandos:

```bash
make lint
make format-check
make test
make validate
make install-runtime-deps
make install-dev-deps
```

O repositorio inclui CI em GitHub Actions para rodar lint, formatacao e testes automaticamente.
