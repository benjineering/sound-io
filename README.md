# SoundIO

## A Ruby gem FFI wrapper for libstdio

Under construction...

### ROADMAP

- implement buffer in c
- implement all specs
  - use fixtures or factories
- figure out why errors aren't raised inside callbacks
- cross-platformatisation
  - create docker instances for testing
  - check Windows locations in ext.rb
  - automate test running over Docker instances
- write docs
- release
  - take out `synthezise` gem and implement sine wave inline
- optimises
  - check callback proc & blocks
- make buffer rotation a module setting?
  - look at core audio buffer shape
- maybe install lib
  - look at what NokoGiri does
