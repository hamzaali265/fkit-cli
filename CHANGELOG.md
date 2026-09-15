# Changelog

All notable changes to **FKIT CLI** are documented here.

## [1.0.3] - 2026-09-15

### Fixed
- Remove UI blink by painting menus before clearing leftover lines

## [1.0.2] - 2026-09-15

### Fixed
- Folder browser no longer blinks or blanks out while navigating
- Wizard choosers clear stale rows on ↑/↓ redraw

## [1.0.1] - 2026-09-15

### Fixed
- Home menu no longer stacks duplicate rows when moving with ↑/↓

## [1.0.0] - 2026-09-15

### Added
- Interactive home screen with FKIT ASCII wordmark and arrow-key menu
- Full create wizard: architecture, state, routing, networking, storage, utilities
- Non-interactive flags for CI / scripted scaffolding
- `fkit list` catalog of stacks and packages
- Project generator with templates for screens, themes, assets, l10n, flavors
- Image/file picker services, permissions wiring, and shared extensions
- Directory picker for choosing the output parent folder
- Unit and end-to-end generation tests

### Docs
- Open-source README, MIT license, and contributing guide
