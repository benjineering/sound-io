RSpec.describe SoundIO do
  describe '.VERSION' do
    it 'returns a string' do
      expect(SoundIO::VERSION).to be_instance_of(String)
    end
  end
  
  describe '.soundio_version_string' do
    it 'returns a string' do
      expect(SoundIO.soundio_version_string).to be_instance_of(String)
    end
  end
  
  describe '.soundio_version_major' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_major).to be_instance_of(Fixnum)
    end
  end
  
  describe '.soundio_version_minor' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_minor).to be_instance_of(Fixnum)
    end
  end
  
  describe '.soundio_version_patch' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_patch).to be_instance_of(Fixnum)
    end
  end

  describe '.soundio_create' do
    it 'returns a SoundIO instance' do
      expect(SoundIO.soundio_create).to be_instance_of(SoundIO::Instance)
    end
  end

  describe '.soundio_destroy' do
    it 'destroys the passed instance' do
      instance = SoundIO.soundio_create
      expect { SoundIO.soundio_destroy(instance) }.not_to raise_error
    end
  end

  describe '.soundio_device_equal' do
    context 'device #id, #is_raw and #aim are equal' do
      skip 'returns false'
    end

    context 'device #aim is differs' do
      skip 'returns true'
    end
  end
end
