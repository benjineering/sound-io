#include "sound_io.h"
#include "output.h"
#include "output_buffer.h"

VALUE begin_write(VALUE rb_stream, VALUE rb_buffer) {
  struct SoundIoOutStream *stream;
  struct OutputBuffer *buffer;

  Data_Get_Struct(rb_stream, struct SoundIoOutStream, stream);
  Data_Get_Struct(rb_buffer, struct OutputBuffer, buffer);

  int error = soundio_outstream_begin_write(
    stream, 
    &buffer->areas, 
    &buffer->frames_requested
  );

  return INT2NUM(error);
}

void Init_output() {
  mOutput = rb_define_module_under(mSoundIO, "Output");
  rb_define_singleton_method(mSoundIO, "begin_write", begin_write, 2);
}
