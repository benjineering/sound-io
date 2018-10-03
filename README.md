# SoundIO

## A Ruby gem FFI wrapper for libstdio

---

### TODO

- rename `ChannelAreas` to `OutputBuffer`
- add more outstream methods:
  - implement other callbacks
  - simplify begin and end with block
  - simplify write
  - add mono write 
- move module methods to applicable files and remove module requires
- add examples to Rakefile
- check libsoundio version on install and in specs
- extend FFI to DRY up:
  - char * to string
  - array of structs
  - array of enums
- implement all examples
- show implementation stats and details by running `rake implementation`
- create docker instances for testing
- automate test running over Docker instances
