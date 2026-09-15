# Contributing to FKIT CLI

Thanks for helping improve FKIT CLI.

## Development setup

```bash
git clone https://github.com/hamzaali265/fkit-cli.git
cd fkit-cli
dart pub get
dart test
```

## Workflow

1. Open an issue for larger changes when you can.
2. Keep PRs focused — one feature or fix per PR.
3. Run `dart analyze` and `dart test` before pushing.
4. Prefer conventional commit messages (`feat:`, `fix:`, `docs:`, `test:`, `chore:`).

## Code style

- Follow the repo `analysis_options.yaml` / Dart lints.
- Match existing patterns in `lib/src/` (commands, prompts, templates, generator).

## Questions

Open a GitHub issue — happy to discuss architecture or template design.
