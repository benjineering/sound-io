RSpec.describe SoundIO do
  let(:context) { SoundIO.soundio_create }

  describe '.VERSION' do
    it 'returns a string' do
      expect(SoundIO::VERSION).to be_instance_of String
    end
  end
  
  describe '.soundio_version_string' do
    it 'returns a string' do
      expect(SoundIO.soundio_version_string).to be_instance_of String
    end
  end
  
  describe '.soundio_version_major' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_major).to be_instance_of Fixnum
    end
  end
  
  describe '.soundio_version_minor' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_minor).to be_instance_of Fixnum
    end
  end
  
  describe '.soundio_version_patch' do
    it 'returns a fixnum' do
      expect(SoundIO.soundio_version_patch).to be_instance_of Fixnum
    end
  end

  describe '.soundio_create' do
    it 'returns a context' do
      expect(context).to be_instance_of(SoundIO::Context)
    end
  end

  describe '.soundio_destroy' do
    it 'destroys the passed context' do
      expect { SoundIO.soundio_destroy(context) }.not_to raise_error
    end
  end

  describe '.soundio_connect' do
    let (:connect) { SoundIO.soundio_connect(context) }

    it 'returns :none' do
      expect(connect).to eq :none
    end

    it "sets the context's backend" do
      connect
      expect(context[:current_backend]).not_to eq :none
    end
  end

  describe '.soundio_connect_backend' do
    let (:connect) { SoundIO.soundio_connect_backend(context, :dummy) }

    it 'returns :none' do
      expect(connect).to eq :none
    end

    it "sets the context's backend" do
      connect
      expect(context[:current_backend]).to eq :dummy
    end
  end

  describe '.soundio_disconnect' do
    skip 'calls the on_backend_disconnect callback'
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
