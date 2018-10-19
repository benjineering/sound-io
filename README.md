# SoundIO

## A Ruby gem FFI wrapper for libstdio

Under construction...

### ROADMAP

- implement channel class
- implement buffer in c
- implement all specs
  - use fixtures or factories
- figure out why errors aren't raised inside callbacks
- write docs
- release
  - take out `synthezise` gem and implement sine wave inline
  - create docker instances for testing
  - automate test running over Docker instances
- optimise
  - check callback proc & blocks
- make buffer rotation a module setting?
  - look at core audio buffer shape
