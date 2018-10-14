require 'ffi'

module SoundIO
  class SampleRateRange < FFI::Struct
    layout(
      min: :int,
      max: :int
    )

    def min
      self[:min]
    end

    def max
      self[:max]
    end

    def to_range
      self[:min]..self[:max]
    end
  end
end
