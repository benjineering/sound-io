# SoundIO

## A Ruby gem FFI wrapper for libstdio

Under construction...

### ROADMAP

- raise on buffer read and write out of bounds
- show implementation stats and details by running `rake implementation`
- add examples to Rakefile
- implement ring buffer
- extend FFI to DRY up:
  - char * to string
  - array of structs
  - array of enums
- figure out why errors aren't raised inside callbacks
- implement all specs
- generate docs
- check libsoundio version on install and in specs
- take out `synthezise` gem and implement sine wave inline
- create docker instances for testing
- automate test running over Docker instances
- optimise
  - implement buffer in c
  - check callback proc & blocks
- make buffer rotation a module setting?
  - look at core audio buffer shape
