# SoundIO

## A Ruby gem FFI wrapper for libstdio

---

### TODO

- move module methods to applicable files and remove module requires
- implement record example
- add examples to Rakefile
- check libsoundio version on install and in specs
- extend FFI to DRY up:
  - char * to string
  - array of structs
  - array of enums
- take out `synthezise` gem and implement sine wave inline
- show implementation stats and details by running `rake implementation`
- create docker instances for testing
- automate test running over Docker instances
- implement all tests