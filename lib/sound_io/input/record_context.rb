require 'sound_io/ring_buffer'
require 'ffi'

module SoundIO
  module Input
    class RecordContext < FFI::Struct
      layout(ring_buffer: SoundIO::RingBuffer.ptr)
    end
  end
end
