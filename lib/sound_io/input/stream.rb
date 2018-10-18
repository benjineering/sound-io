require 'sound_io/stream'

module SoundIO
  module Input
    class Stream < SoundIO::Stream
      ACTION = 'read'
      TYPE = 'in'

      alias_method :read_callback, :action_callback
      alias_method :overflow_callback, :flow_callback
      alias_method :read, :begin_action

      layout(STRUCT_LAYOUT)
    end
  end
end
