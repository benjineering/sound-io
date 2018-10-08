RSpec.describe SoundIO::Buffer::OutputBuffer, c_api: true do
  skip '.new'

  skip '#frame_count'

  context 'sample is a single float' do
    skip '#write'

    skip '#write_mono'
  end

  context 'sample is an array of floats' do
    skip '#write'

    skip '#write_mono'
  end
end
