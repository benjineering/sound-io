#include <ruby.h>
#include <soundio/soundio.h>

struct OutputBuffer {
  int frame_count;
  struct SoundIoChannelArea **areas;
};

VALUE mBuffer = Qnil;
VALUE cOutputBuffer = Qnil;

VALUE allocate_output_buffer(VALUE self);

VALUE initialize_output_buffer(VALUE self, VALUE frame_count);

void free_output_buffer(void *buffer);

void Init_output_buffer();
