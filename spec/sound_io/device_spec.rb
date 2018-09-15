RSpec.describe SoundIO::Device do
  describe '#name=' do
    skip 'sets name from string'
  end

  skip '#=' do
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
end
