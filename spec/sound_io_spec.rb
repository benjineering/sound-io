RSpec.describe SoundIO do
  describe '.VERSION' do
    it 'returns a string' do
      expect(SoundIO::VERSION).to be_instance_of(String)
    end
  end
  
  describe '#soundio_version_string' do
    it 'returns a string' do
      expect(SoundIO.soundio_version_string).to be_instance_of(String)
    end
  end
  
  describe '#soundio_version_major' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_major).to be_instance_of(Fixnum)
    end
  end
  
  describe '#soundio_version_minor' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_minor).to be_instance_of(Fixnum)
    end
  end
  
  describe '#soundio_version_patch' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_patch).to be_instance_of(Fixnum)
    end
  end
end
