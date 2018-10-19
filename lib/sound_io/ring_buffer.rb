require 'ffi'
require 'sound_io'

module SoundIO
  class RingBuffer < FFI::ManagedStruct
    layout(dummy: :pointer) # opaque struct

    def self.release(ptr)
      SoundIO.ring_buffer_destroy(ptr)
    end

    def capacity
      SoundIO.ring_buffer_capacity(self)
    end

    def ptr
      SoundIO.ring_buffer_write_ptr(self)
    end

    def advance_write_ptr(n)
      SoundIO.ring_buffer_advance_write_ptr(self, n)
    end

    def read_ptr
      SoundIO.ring_buffer_read_ptr(self)
    end

    def advance_read_ptr(n)
      SoundIO.ring_buffer_advance_read_ptr(self, n)
    end

    def fill_count
      SoundIO.ring_buffer_fill_count(self)
    end

    def free_count
      SoundIO.ring_buffer_free_count(self)
    end

    def clear
      SoundIO.ring_buffer_clear(self)
    end
  end
end
