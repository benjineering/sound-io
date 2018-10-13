RSpec.describe SoundIO do
  let(:context) { SoundIO.create }

  # static

  describe '.VERSION' do
    it 'returns a string' do
      expect(SoundIO::VERSION).to be_instance_of String
    end
  end

  describe '.MAX_CHANNELS' do
    it 'returns a number' do
      expect(SoundIO::MAX_CHANNELS).to be_instance_of Fixnum
    end
  end
  
  describe '.version_string' do
    it 'returns a string' do
      expect(SoundIO.version_string).to be_instance_of String
    end
  end
  
  describe '.soundio_version_major' do
    it 'returns a fixnum' do
      expect(SoundIO.version_major).to be_instance_of Fixnum
    end
  end
  
  describe '.soundio_version_minor' do
    it 'returns a fixnum' do
      expect(SoundIO.version_minor).to be_instance_of Fixnum
    end
  end
  
  describe '.soundio_version_patch' do
    it 'returns a fixnum' do
      expect(SoundIO.version_patch).to be_instance_of Fixnum
    end
  end

  skip '.soundio_backend_name'

  skip '.soundio_have_backend'

  skip '.have_backend?'

  # context

  describe '.soundio_create' do
    it 'returns a context' do
      expect(context).to be_instance_of(SoundIO::Context)
    end
  end

  describe '.soundio_destroy' do
    it 'destroys the passed context' do
      expect { SoundIO.destroy(context) }.not_to raise_error
    end
  end

  describe '.soundio_connect' do
    let (:connect) { SoundIO.connect(context) }

    it 'returns :none' do
      expect(connect).to eq :none
    end

    it "sets the context's backend" do
      connect
      expect(context[:current_backend]).not_to eq :none
    end
  end

  describe '.soundio_connect_backend' do
    let (:connect) { SoundIO.connect_backend(context, :dummy) }

    it 'returns :none' do
      expect(connect).to eq :none
    end

    it "sets the context's backend" do
      connect
      expect(context[:current_backend]).to eq :dummy
    end
  end

  describe '.soundio_disconnect' do
    skip 'calls the on_backend_disconnect callback'
  end

  skip '.soundio_backend_count'

  skip '.soundio_get_backend'

  skip '.soundio_flush_events'

  skip '.soundio_wait_events'

  skip '.soundio_wakeup'

  skip '.soundio_force_device_scan'

  skip '.soundio_input_device_count'

  skip '.soundio_output_device_count'

  skip '.soundio_get_input_device'

  skip '.soundio_get_output_device'

  skip '.soundio_default_input_device_index'

  skip '.soundio_default_output_device_index'

  skip '.soundio_ring_buffer_create'

  # device

  describe '.soundio_device_equal' do
    context 'device #id, #is_raw and #aim are equal' do
      skip 'returns false'
    end

    context 'device #aim is differs' do
      skip 'returns true'
    end
  end

  skip '.soundio_device_ref'

  skip '.soundio_device_unref'

  skip '.soundio_device_sort_channel_layouts'

  skip '.soundio_device_nearest_sample_rate'

  skip '.soundio_device_supports_format'

  skip '.soundio_device_supports_layout'

  skip '.soundio_device_supports_sample_rate'

  skip '.soundio_outstream_create'

  skip '.soundio_instream_create'

  # channel layout

  skip '.soundio_channel_layout_equal'

  skip '.soundio_get_channel_name'

  skip '.soundio_parse_channel_id'

  skip '.soundio_channel_layout_builtin_count'

  skip '.soundio_channel_layout_get_builtin'

  skip '.soundio_channel_layout_get_default'

  skip '.soundio_channel_layout_find_channel'

  skip '.soundio_channel_layout_detect_builtin'

  skip '.soundio_best_matching_channel_layout'

  skip '.soundio_sort_channel_layouts'


  # format

  skip '.soundio_get_bytes_per_sample'

  skip '.soundio_get_bytes_per_frame'

  skip '.soundio_get_bytes_per_second'

  skip '.soundio_format_string'

  # outstream

  skip '.soundio_outstream_destroy'

  skip '.soundio_outstream_open'

  skip '.soundio_outstream_start'

  skip '.soundio_outstream_begin_write'

  skip '.soundio_outstream_end_write'

  skip '.soundio_outstream_clear_buffer'

  skip '.soundio_outstream_pause'

  skip '.soundio_outstream_get_latency'

  # instream

  skip '.soundio_instream_destroy'

  skip '.soundio_instream_open'

  skip '.soundio_instream_start'

  skip '.soundio_instream_begin_read'

  skip '.soundio_instream_end_read'

  skip '.soundio_instream_pause'

  skip '.soundio_instream_get_latency'

  # ringbuffer

  skip '.soundio_ring_buffer_destroy'

  skip '.soundio_ring_buffer_capacity'

  skip '.soundio_ring_buffer_write_ptr'

  skip '.soundio_ring_buffer_advance_write_ptr'

  skip '.soundio_ring_buffer_read_ptr'

  skip '.soundio_ring_buffer_advance_read_ptr'

  skip '.soundio_ring_buffer_fill_count'

  skip '.soundio_ring_buffer_free_count'

  skip '.soundio_ring_buffer_clear'
end
