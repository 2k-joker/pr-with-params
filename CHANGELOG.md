## [2.0.0] - 2023-06-05
  
To migrate to this version, simply run `gem update pr-with-params`
 
### Added
- Ability to specify a list of validators to run as an option
- Ability to set `ignore_conventional_commits` in config file
- Default path for config file at `~/.pwp/config.yml`

### Changed
- `--conf` is now `--config_path` or `-path` or `-p`
- Make specifying config path optional - was previously a required
- CLI name is now `pr-wip` - was previously `pr-with-params`
- `--validate-conventional-commits` is now `--ignore-conventional-commits` - optionally turn off versus optionally turn on
 
### Fixed
- Occasional failures related to `launchy` not being loaded properly

## [2.0.1] - 2023-06-05

To migrate to this version, simply run `gem update pr-with-params`
 
### Added

### Changed
 
### Fixed
- Typos in messages displayed
- Remove unnecessary print statements
