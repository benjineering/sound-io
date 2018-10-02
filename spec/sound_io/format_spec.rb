RSpec.describe SoundIO::Format do

  skip 'other format contexts - set up programmatically'

  context 'format is invalid' do
    let (:format) { SoundIO::Format.new(:invalid) }

    describe '#bytes_per_sample' do
      it 'should return nil' do
        expect(format.bytes_per_sample).to be_nil
      end
    end

    describe '#to_s' do
      it 'should return "(invalid sample format)"' do
        expect(format.to_s).to eq '(invalid sample format)'
      end
    end

    describe '#to_sym' do
      it 'should return :invalid' do
        expect(format.to_sym).to eq :invalid
      end
    end

    describe '#invalid?' do
      it 'should return true' do
        expect(format.invalid?).to be true
      end
    end
  end
end
