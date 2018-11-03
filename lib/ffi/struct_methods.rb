require 'ffi'

FFI::Struct.class_eval do

  def read_array_of_type(type, field, length_field)
    self[length_field].times.collect do |i|

      if type.is_a?(FFI::Enum)
        num = (self[field] + i * type.native_type.size).read(type.native_type)
        type[num]       
        
      elsif type < FFI::Struct
        type.new(self[field] + i * type.size)
      end
    end
  end
end
