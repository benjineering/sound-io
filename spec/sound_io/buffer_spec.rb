RSpec.describe SoundIO::Buffer do
  let(:buffer) { SoundIO::Buffer.new(8, 90) }

  describe '.new' do
    it 'sets the sample and channel counts' do
      expect(buffer.channel_count).to eq 8
      expect(buffer.sample_count).to eq 90
    end
  end

  describe '#allocate_data' do
    it "doesn't raise an error" do
      expect { buffer.allocate_data }.to_not raise_error
    end
  end
end
