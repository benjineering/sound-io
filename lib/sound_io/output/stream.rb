require 'sound_io/stream'

module SoundIO
  module Output
    class Stream < SoundIO::Stream
      ACTION = 'write'
      TYPE = 'out'
      
      alias_method :write_callback, :action_callback
      alias_method :underflow_callback, :flow_callback
      alias_method :write, :begin_action

      layout(STRUCT_LAYOUT)
    end
  end
end
