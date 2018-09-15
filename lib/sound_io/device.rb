require 'sound_io'
require 'sound_io/instance'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'sound_io/sample_rate_range'
require 'ffi'

module SoundIO
	class Device < FFI::Struct
		layout(
			soundio: Instance.ptr,
			id: :pointer,
			name: :pointer,
			aim: :aim,
			layouts: ChannelLayout.ptr,
			layout_count: :int,
			current_layout: ChannelLayout,
			formats: :pointer, # enum SoundIoFormat *
			format_count: :int,
			current_format: :format,
			sample_rates: :pointer, # struct SoundIoSampleRateRange *
			sample_rate_count: :int,
			sample_rate_current: :int,
			software_latency_min: :double,
			software_latency_max: :double,
			software_latency_current: :double,
			is_raw: :bool,
			ref_count: :int,
			probe_error: :int
		)

		def name=(str)
			self[:name] = FFI::MemoryPointer.from_string(str)
		end

		def ==(other)
			SoundIO.soundio_device_equal(self, other)
		end
	end
end
