require 'sound_io/version'
require 'sound_io/device'
require 'sound_io/context'
require 'sound_io/enums'
require 'sound_io/error'
require 'sound_io/channel_layout'
require 'sound_io/channel_area'
require 'sound_io/format'
require 'sound_io/ring_buffer'

require 'sound_io/buffer'
require 'sound_io/stream'
require 'sound_io/output/stream'
require 'sound_io/input/stream'

# ext
require 'sound_io/sound_io'

require 'ffi'

module SoundIO
	extend FFI::Library
	ffi_lib 'soundio'

	# kneel before the FFI monolith
	
	# module
	attach_function :soundio_version_string, [], :string
	attach_function :soundio_version_major, [], :int
	attach_function :soundio_version_minor, [], :int
	attach_function :soundio_version_patch, [], :int
	attach_function :soundio_have_backend, [:backend], :bool
	attach_function :soundio_backend_name, [:backend], :string

	# TODO: Channel should probably be a separate class
	def self.get_channel_name(channel_id)
		SoundIO.soundio_get_channel_name(channel_id)
	end

	def self.get_channel_id(channel_name)
		SoundIO.parse_channel_id(channel_name, channel_name.length)
	end

	# error
	attach_function :soundio_strerror, [:error], :string

	# context
	attach_function :soundio_create, [], Context.ptr
	attach_function :soundio_destroy, [Context.ptr], :void
	attach_function :soundio_connect, [Context.ptr], :error
	attach_function :soundio_connect_backend, [Context.ptr, :backend], :error
	attach_function :soundio_disconnect, [Context.ptr], :void
	attach_function :soundio_backend_count, [Context.ptr], :int
	attach_function :soundio_get_backend, [Context.ptr, :int], :backend
	attach_function :soundio_flush_events, [Context.ptr], :void
	attach_function :soundio_wait_events, [Context.ptr], :void, blocking: true
	attach_function :soundio_wakeup, [Context.ptr], :void
	attach_function :soundio_force_device_scan, [Context.ptr], :void	
	attach_function :soundio_input_device_count, [Context.ptr], :int
	attach_function :soundio_output_device_count, [Context.ptr], :int
	attach_function :soundio_get_input_device, [Context.ptr, :int], Device.ptr
	attach_function :soundio_get_output_device, [Context.ptr, :int], Device.ptr
	attach_function :soundio_default_input_device_index, [Context.ptr], :int
	attach_function :soundio_default_output_device_index, [Context.ptr], :int
	attach_function :soundio_ring_buffer_create, [Context.ptr, :int], SoundIO::RingBuffer.ptr

	# device
	attach_function :soundio_device_equal, [Device.ptr, Device.ptr], :bool
	attach_function :soundio_device_ref, [Device.ptr], :void
	attach_function :soundio_device_unref, [Device.ptr], :void	
	attach_function :soundio_device_sort_channel_layouts, [Device.ptr], :void
	attach_function :soundio_device_nearest_sample_rate, [Device.ptr, :int], :int
	attach_function :soundio_device_supports_format, [Device.ptr, :format], :bool
	attach_function :soundio_device_supports_layout, [Device.ptr, ChannelLayout.ptr], :bool
	attach_function :soundio_device_supports_sample_rate, [Device.ptr, :int], :bool	
	attach_function :soundio_outstream_create, [Device.ptr], Output::Stream.ptr
	attach_function :soundio_instream_create, [Device.ptr], Input::Stream.ptr

	# channel layout
	attach_function :soundio_channel_layout_equal, [ChannelLayout.ptr, ChannelLayout.ptr], :bool
	attach_function :soundio_get_channel_name, [:channel_id], :string
	attach_function :soundio_parse_channel_id, [:string, :int], :channel_id
	attach_function :soundio_channel_layout_builtin_count, [:void], :int
	attach_function :soundio_channel_layout_get_builtin, [:int], ChannelLayout.ptr
	attach_function :soundio_channel_layout_get_default, [:int], ChannelLayout.ptr
	attach_function :soundio_channel_layout_find_channel, [ChannelLayout.ptr, :channel_id], :int
	attach_function :soundio_channel_layout_detect_builtin, [ChannelLayout.ptr], :bool
	attach_function :soundio_best_matching_channel_layout, [ChannelLayout.ptr, :int, ChannelLayout.ptr, :int], ChannelLayout.ptr
	attach_function :soundio_sort_channel_layouts, [ChannelLayout.ptr, :int], :void

	# format
	attach_function :soundio_get_bytes_per_sample, [:format], :int
	attach_function :soundio_format_string, [:format], :string

  # outstream
	attach_function :soundio_outstream_destroy, [Output::Stream.ptr], :void
	attach_function :soundio_outstream_open, [Output::Stream.ptr], :error
	attach_function :soundio_outstream_start, [Output::Stream.ptr], :error
	attach_function :soundio_outstream_begin_write, [Output::Stream.ptr, :pointer, :pointer], :error
	attach_function :soundio_outstream_end_write, [Output::Stream.ptr], :error
	attach_function :soundio_outstream_clear_buffer, [Output::Stream.ptr], :int
	attach_function :soundio_outstream_pause, [Output::Stream.ptr, :bool], :int
	attach_function :soundio_outstream_get_latency, [Output::Stream.ptr, :pointer], :int

  # instream
	attach_function :soundio_instream_destroy, [Input::Stream.ptr], :void
	attach_function :soundio_instream_open, [Input::Stream.ptr], :error
	attach_function :soundio_instream_start, [Input::Stream.ptr], :error
	attach_function :soundio_instream_begin_read, [Input::Stream.ptr, :pointer, :pointer], :error
	attach_function :soundio_instream_end_read, [Input::Stream.ptr], :error
	attach_function :soundio_instream_pause, [Input::Stream.ptr, :bool], :int
	attach_function :soundio_instream_get_latency, [Input::Stream.ptr, :pointer], :int

	# ringbuffer
	attach_function :soundio_ring_buffer_destroy, [SoundIO::RingBuffer.ptr], :void
	attach_function :soundio_ring_buffer_capacity, [SoundIO::RingBuffer.ptr], :int
	attach_function :soundio_ring_buffer_write_ptr, [SoundIO::RingBuffer.ptr], :pointer
	attach_function :soundio_ring_buffer_advance_write_ptr, [SoundIO::RingBuffer.ptr, :int], :void
	attach_function :soundio_ring_buffer_read_ptr, [SoundIO::RingBuffer.ptr], :pointer
	attach_function :soundio_ring_buffer_advance_read_ptr, [SoundIO::RingBuffer.ptr, :int], :void
	attach_function :soundio_ring_buffer_fill_count, [SoundIO::RingBuffer.ptr], :int
	attach_function :soundio_ring_buffer_free_count, [SoundIO::RingBuffer.ptr], :int
	attach_function :soundio_ring_buffer_clear, [SoundIO::RingBuffer.ptr], :void

	# alias soundio_ methods
	class << self
		prefix_rex = /^soundio_/

		self.instance_methods.each do |sym|
			if sym == :soundio_have_backend
				alias_method :has_backend?, sym
			else
				str = sym.to_s

				unless str.match(prefix_rex).nil?
					short_sym = str.gsub(prefix_rex, '').to_sym
					alias_method short_sym, sym
				end
			end
		end
	end
end
