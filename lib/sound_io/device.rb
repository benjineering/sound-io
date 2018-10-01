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
			:soundio, Context.ptr,
			:id, :pointer,
			:name, :pointer,
			:aim, :aim,
			:layouts, :pointer,
			:layout_count, :int,
			:current_layout, ChannelLayout,
			:formats, :pointer,
			:format_count, :int,
			:current_format, :format,
			:sample_rates, :pointer,
			:sample_rate_count, :int,
			:sample_rate_current, :int,
			:software_latency_min, :double,
			:software_latency_max, :double,
			:software_latency_current, :double,
			:is_raw, :bool,
			:ref_count, :int,
			:probe_error, :error
    )

		def self.release(ptr)
			# soundio_device_ref is called upon creation in SoundIO::Context
      device_unref(ptr)
    end

		def name=(str)
			@name = str
			self[:name] = FFI::MemoryPointer.from_string(str)
		end

		def name
			@name = self[:name].read_string if @name.nil?
			@name
		end

		def id
			@id = self[:id].read_string if @id.nil?
			@id
		end

		def probe_error
			Error.new('Probe error', self[:probe_error])
		end

		def probe_error_str
			return nil if self[:probe_error] == :none
			SoundIO.strerror(self[:probe_error])
		end

		def ==(other)
			SoundIO.device_equal(self, other)
		end

		def create_out_stream(options = {})
			stream = SoundIO.outstream_create(self)
			raise Error.no_memory if stream.nil?
			options.each { |k, v| stream[k.to_sym] = v }

			if options[:format].nil?
				raise Error.new('Device has no available layouts') if format_count < 1
				stream.format = formats.first
			end

			stream
		end

		def raw?
			self[:is_raw]
		end

		def layout_count
			self[:layout_count]
		end

    def layouts
      # TODO: DRY arrays
			layout_size = ChannelLayout.size

			(0...self[:layout_count]).collect do |i|
				increment = i * layout_size
				ChannelLayout.new(self[:layouts] + increment)
      end
		end

		def current_layout
			self[:current_layout] == :invalid ? nil : self[:current_layout]
    end

    def sample_rate_count
      self[:sample_rate_count]
    end
    
		def sample_rates
			# TODO: DRY arrays
			rate_size = SampleRateRange.size

			(0...self[:sample_rate_count]).collect do |i|
				increment = i * rate_size
				SampleRateRange.new(self[:sample_rates] + increment)
			end
    end

    def sample_rate_current
      self[:sample_rate_current] == 0 ? nil : self[:sample_rate_current]
    end

    def format_count
      self[:format_count]
    end

		def formats
			# TODO: DRY arrays
			format_size = FORMAT.native_type.size

			(0...self[:format_count]).collect do |i|
				num = (self[:formats] + i).read(FORMAT.native_type)
				sym = FORMAT[num]
				Format.new(sym)
			end
    end

		def current_format
			format = Format.new(self[:current_format])
			format.invalid? ? nil : format
    end

    def software_latency_min
      self[:software_latency_min]
    end

    def software_latency_max
      self[:software_latency_max]
    end

    def software_latency_current
      self[:software_latency_current]
    end
    
    alias_method :current_sample_rate, :sample_rate_current
    alias_method :min_software_latency, :software_latency_min
    alias_method :max_software_latency, :software_latency_max
    alias_method :current_software_latency, :software_latency_current
	end
end
