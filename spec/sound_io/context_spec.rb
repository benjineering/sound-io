RSpec.describe SoundIO::Context do
  describe '.new' do
    it 'creates a SoundIO context' do
      expect(SoundIO::Context.new).to be_instance_of(SoundIO::Context)
    end
  end

  skip '.release'
end
