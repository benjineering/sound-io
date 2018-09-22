RSpec.describe SoundIO::Device do
  skip '.release'

  skip '#name'

  describe '#name=' do
    skip 'sets name from string'
  end

  skip '#id'

  skip '#probe_error'

  skip '#probe_error_str'

  skip '#=' do
    # TODO: get from instance
    let(:a) do
      d = SoundIO::Device.new
      d.name = 'a'
      d
    end

    context 'devices are the same' do
      let(:b) do
        d = SoundIO::Device.new
        d.name = 'a'
        d
      end

      it 'returns true' do
        expect(a == b).to be_true
      end
    end

    context 'device names differ' do
      let(:b) do
        d = SoundIO::Device.new
        d.name = 'b'
        d
      end

      it 'returns false' do
        expect(a == b).to be_false
      end
    end
  end

  skip '#create_stream'

  skip '#raw?'

  skip '#layout_count'

  skip '#layouts'

  skip '#current_layout'

  skip '#sample_rate_count'

  skip '#sample_rates'

  skip '#sample_rate_current'

  skip '#current_sample_rate'

  skip '#format_count'

  skip '#formats'

  skip '#current_format'

  skip '#software_latency_min'

  skip '#min_software_latency'

  skip '#software_latency_max'

  skip '#max_software_latency'

  skip '#software_latency_current'

  skip '#current_software_latency'
end
