RSpec.describe SoundIO::Buffer do
  let(:buffer) { SoundIO::Buffer.new(8, 90) }

  describe '.new' do
    it 'sets the frame and channel counts' do
      expect(buffer.frame_count).to eq 8
      expect(buffer.channel_count).to eq 90
    end
  end

  describe '#frame_count' do
    it 'sets and gets the frame count' do
      expect { buffer.frame_count = 513 }.to change { buffer.frame_count }.to 513
    end
  end

  describe '#channel_count' do
    it 'sets and gets the channel count' do
      expect { buffer.channel_count = 3 }.to change { buffer.channel_count }.to 3
    end
  end
end
