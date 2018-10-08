#include "sound_io.h"
#include "output_buffer.h"

VALUE allocate_output_buffer(VALUE self) {
	void *buffer = malloc(sizeof(struct OutputBuffer));
	return Data_Wrap_Struct(cOutputBuffer, NULL, free_output_buffer, buffer);
}

VALUE initialize_output_buffer(VALUE self, VALUE frame_count) {
  struct OutputBuffer *buffer;
  Data_Get_Struct(self, struct OutputBuffer, buffer);
  buffer->frame_count = NUM2INT(frame_count);
  return self;
}

void free_output_buffer(void *buffer) {
  free(buffer);
}

void Init_output_buffer() {
  mBuffer = rb_define_module_under(mSoundIO, "Buffer");
  cOutputBuffer = rb_define_class_under(mBuffer, "OutputBuffer", rb_cObject);
	rb_define_alloc_func(cOutputBuffer, allocate_output_buffer);
	rb_define_method(cOutputBuffer, "initialize", initialize_output_buffer, 1);
}
