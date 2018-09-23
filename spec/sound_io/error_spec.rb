RSpec.describe SoundIO::Error do
  let(:error) { SoundIO::Error.new('Message', :invalid) }

  describe '#symbol' do
    it 'returns the supplied symbol' do
      expect(error.symbol).to eq :invalid
    end
  end

  describe '#string' do
    it 'returns the result of #soundio_strerror' do
      expect(error.string).to eq 'invalid value'
    end
  end

  describe '#to_s' do
    it 'returns a formatted string' do
      expect(error.to_s).to eq 'Message - invalid value'
    end
  end

  describe '#none?'

  describe '#to_sym'

  describe '#=='
end
