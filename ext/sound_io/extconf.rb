require 'mkmf'

LIB_NAME = 'soundio'
HEADER_FILE = "#{LIB_NAME}/#{LIB_NAME}.h"
LIB_FUNCTION = 'soundio_version_string'

HEADER_DIRS = [
  '/usr/local/include',           # homebrew / from source
  RbConfig::CONFIG['includedir'], # ruby install locations
  '/usr/include'                  # fallback
]

LIB_DIRS = [
  '/usr/local/lib',               # homebrew / from source
  RbConfig::CONFIG['libdir'],     # ruby install locations
  '/usr/lib'                      # fallback
]

dir_config(LIB_NAME, HEADER_DIRS, LIB_DIRS)

abort "#{HEADER_FILE} not found" unless find_header(HEADER_FILE)
abort "lib#{LIB_NAME} not found" unless find_library(LIB_NAME, LIB_FUNCTION)

create_makefile('sound_io/sound_io')
