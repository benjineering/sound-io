# SoundIO

## A Ruby gem FFI wrapper for libstdio

Under construction...

### ROADMAP

- implement CI
  - just dummy backend for now
  - add status to readme
- implement buffer in c
- implement all specs
  - use fixtures or factories
- figure out why errors aren't raised inside callbacks
- write docs
- cross-platformatisation (real word)
  - check Windows locations in ext.rb
  - create docker instances for testing
  - automate test running over Docker instances
- release
  - take out `synthezise` gem and implement sine wave inline
- optimise
  - check callback proc & blocks
- make buffer rotation a module setting?
  - look at core audio buffer shape
- maybe install lib
  - look at what NokoGiri does
