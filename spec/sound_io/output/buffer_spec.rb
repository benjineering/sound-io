RSpec.describe SoundIO::Output::Buffer, c_api: true do
  let(:buffer) do 
    buffer = SoundIO::Output::Buffer.new(256)
    # TODO: alter with soundio_begin_write
  end

  describe '#frames_requested' do
    it 'returns the number of frames requested as passed at initialization' do
      expect(buffer.frames_requested).to eq 256
    end
  end

  describe '#frames_given' do
    it 'returns the number of frames given as set by soundio_begin_write' do
      expect(buffer.frames_requested).to be <= 256
    end
  end

  context 'sample is a single float' do
    skip '#write'

    skip '#write_mono'
  end

  context 'sample is an array of floats' do
    skip '#write'

    skip '#write_mono'
  end
end
