RSpec.describe SoundIO::Instance do
  describe '.new' do
    it 'creates a SoundIO context' do
      expect(SoundIO::Instance.new).to be_instance_of(SoundIO::Instance)
    end
  end

  skip '.release'
end
