# SoundIO

## A Ruby gem FFI wrapper for libstdio

Under construction...

### Roadmap

- implement buffer in c
- implement all specs
  - use fixtures or factories
- figure out why errors aren't raised inside callbacks
  - maybe build lib without thread support
  - otherwise experiment with threads
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
