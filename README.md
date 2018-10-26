# SoundIO

## A Ruby gem FFI wrapper for libstdio

Under construction...

### Roadmap

- get specs passing in Debian Docker container
- create helper to find library and headers
- implement buffer in c
- get specs passing in Windows Docker container
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
- optimisations
  - check callback proc & blocks
- make buffer rotation a module setting?
  - look at core audio buffer shape
- maybe install lib
  - look at what NokoGiri does
- save libpath when compiling extension
