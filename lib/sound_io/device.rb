require 'sound_io'
require 'sound_io/context'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'sound_io/sample_rate_range'
require 'sound_io/error'
require 'ffi'

module SoundIO
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
			# soundio_device_ref is called on creation in SoundIO::Context
      device_unref(ptr)
    end

		def id
			self[:id].read_string
		end

		def name
			self[:name].read_string
		end

		def aim
			self[:aim]
		end

    def layouts
      # TODO: DRY arrays
			layout_size = ChannelLayout.size

			(0...self[:layout_count]).collect do |i|
				increment = i * layout_size
				ChannelLayout.new(self[:layouts] + increment)
      end
		end

		def layout_count
			self[:layout_count]
		end

		def current_layout
			self[:current_layout] == :invalid ? nil : self[:current_layout]
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

    def format_count
      self[:format_count]
		end

		def current_format
			format = Format.new(self[:current_format])
			format.invalid? ? nil : format
    end
    
		def sample_rates
			# TODO: DRY arrays
			rate_size = SampleRateRange.size

			(0...self[:sample_rate_count]).collect do |i|
				increment = i * rate_size
				SampleRateRange.new(self[:sample_rates] + increment)
			end
    end

    def sample_rate_count
      self[:sample_rate_count]
    end

    def current_sample_rate
      self[:sample_rate_current] == 0 ? nil : self[:sample_rate_current]
		end

    def min_software_latency
      self[:software_latency_min]
    end

    def max_software_latency
      self[:software_latency_max]
    end

    def current_software_latency
      self[:software_latency_current]
    end

		def raw?
			self[:is_raw]
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
		
		def sort_channel_layouts
			SoundIO.device_sort_channel_layouts(self)
		end

		def nearest_sample_rate(rate)
			SoundIO.nearest_sample_rate(self, rate)
		end

		def supports_format(fmt)
			SoundIO.device_supports_format(self, fmt)
		end

		def supports_layout(layout)
			SoundIO.device_supports_layout(self, layout)
		end
		
		def supports_sample_rate(rate)
			SoundIO.device_supports_sample_rate(self, rate)
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

		def create_in_stream(options = {})
			stream = SoundIO.instream_create(self)
			raise Error.no_memory if stream.nil?
			options.each { |k, v| stream[k.to_sym] = v }

			if options[:format].nil?
				raise Error.new('Device has no available layouts') if format_count < 1
				stream.format = formats.first
			end

			stream
		end
	end
end
