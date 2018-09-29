require 'open3'

RSpec.describe 'list_devices' do
  let(:c_example) do 
    stdout, stderr, status = Open3.capture3('examples/c/bin/list_devices')
    { out: stdout, err: stderr, status: status }
  end

  describe 'the libsoundio C example' do
    skip 'should build' do
       # TODO: use mkmf
    end

    it 'should return 0' do
      expect(c_example[:status]).to eq 0
    end
  end

  describe 'the SoundIO Ruby example' do
    let(:ruby_example) do
      ruby = File.join(ENV['MY_RUBY_HOME'], 'bin', 'ruby')
      stdout, stderr, status = Open3.capture3("#{ruby} examples/list_devices.rb")
      { out: stdout, err: stderr, status: status }
    end

    it "should produce the same output as the libsoundio example's stderr" do
      expect(ruby_example[:out]).to eq c_example[:err]
    end
  end
end
