RSpec.describe SoundIO::Context do
  let(:context) { SoundIO::Context.new }

  describe '.new' do
    it 'creates a SoundIO context' do
      expect(context).to be_instance_of(SoundIO::Context)
    end
  end

  skip '.release'

  skip '#backend'

  describe '#connect' do
    it 'sets the backend' do
      context.connect(:dummy)
      expect(context.backend).to eq :dummy
    end
  end

  skip '#disconnect'

  skip '#flush_events'
end
