# Changelog

All notable changes to the Claude Code Image Paste (WSL) extension will be documented in this file.

## [1.2.0] - 2025-01-04

### Fixed
- **Critical** Fixed "Save directory could not be accessed" error when using Windows Cursor with WSL projects
- **Critical** Fixed Unicode path issues for users with non-ASCII (Chinese, etc.) Windows usernames
- Added support for WSL UNC paths (`\\wsl$\` and `\\wsl.localhost\`)
- Improved platform detection for Windows Cursor + WSL workspace scenarios
- `~` (home directory) now correctly expands to WSL home when workspace is in WSL
- Absolute WSL paths (like `/home/user/images`) now work correctly in Windows Cursor

### Added
- New helper functions for UNC path handling: `isWslUncPath()`, `uncPathToWslPath()`, `wslPathToUncPath()`
- Better detection of WSL distro name from workspace path

### Changed
- PowerShell script now uses `C:\Windows\Temp` instead of user temp directory to avoid Unicode encoding issues
- `handleCustomSaveDirectory()` now returns additional context about WSL workspace
- Improved terminal path generation for cross-environment compatibility

## [1.1.6] - 2025-01-03

### Changed
- New custom icon (image + clipboard + terminal) with dark gray background
- Improved marketplace packaging with .vscodeignore

## [1.1.1] - 2025-01-03

### Security
- **Fixed** Command injection vulnerability - now uses `execFile` with array arguments instead of string interpolation
- **Fixed** Path traversal protection - validates `saveDirectory` and `filenamePrefix` settings
- **Fixed** Filename injection - comprehensive validation blocks reserved names, path separators, and invalid characters
- **Added** File overwrite confirmation dialog when renaming to existing filename
- **Added** Random PowerShell script filenames to prevent race conditions
- **Improved** Error messages sanitized to avoid exposing internal details

### Added
- Auto-cleanup feature (`maxImages` setting) - automatically deletes oldest images
- Configurable filename prefix (`filenamePrefix` setting)
- Auto-gitignore - automatically adds save directory to `.gitignore`
- Workspace validation for relative save directories
- Multiple WSL detection methods for improved reliability

### Changed
- Enhanced WSL path handling for better cross-filesystem compatibility
- Improved error handling throughout - no more uncaught exceptions
- Better user-friendly error messages
- Keyboard shortcut changed to `Ctrl+Alt+V` to avoid conflicts

### Fixed
- Path conversion issues between Windows and WSL
- File operations now handle errors gracefully per-file

## [1.0.0] - 2025-01-03

### Added
- Initial release - forked from [agg4code/claude-image-paste](https://github.com/aggroot/claude-image-paste)
- Clipboard image pasting with PowerShell
- File drop support for copied image files
- Custom save directory support
- Optional rename prompt
- `@` prefix for Claude Code file imports
- WSL path conversion

### Credits
- Original extension by [agg](https://github.com/aggroot)
