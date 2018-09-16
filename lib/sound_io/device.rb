require 'sound_io'
require 'sound_io/context'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'sound_io/sample_rate_range'
require 'sound_io/error'
require 'ffi'

module SoundIO

	# This class shouldn't be created by calling #new
	# Only create by calling Context methods
	class Device < FFI::ManagedStruct
		layout(
			soundio: Context.ptr,
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

		def self.release(ptr)
			# soundio_device_ref is called upon creation in Context
      soundio_device_unref(ptr)
    end

		def name=(str)
			self[:name] = FFI::MemoryPointer.from_string(str)
		end

		def ==(other)
			SoundIO.soundio_device_equal(self, other)
		end

		def create_stream(opts = {})
			stm = SoundIO.soundio_outstream_create(self)
			raise Error.no_memory if stm.nil?

			unless opts.empty?
				opts.each { |k, v| stm[k.to_sym] = v }
			end

			stm
		end
	end
end
