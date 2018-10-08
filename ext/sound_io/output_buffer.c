#include "sound_io.h"
#include "output_buffer.h"

VALUE allocate_output_buffer(VALUE self) {
	void *buffer = malloc(sizeof(struct OutputBuffer));
	return Data_Wrap_Struct(cBuffer, NULL, free_output_buffer, buffer);
}

VALUE initialize_output_buffer(VALUE self, VALUE frame_count) {
  struct OutputBuffer *buffer;
  Data_Get_Struct(self, struct OutputBuffer, buffer);
  buffer->frames_requested = NUM2INT(frame_count);
  return self;
}

void free_output_buffer(void *buffer) {
  free(buffer);
}

VALUE get_frames_requested(VALUE self) {
  struct OutputBuffer *buffer;
  Data_Get_Struct(self, struct OutputBuffer, buffer);
  return INT2NUM(buffer->frames_requested);
}

VALUE get_frames_given(VALUE self) {
  struct OutputBuffer *buffer;
  Data_Get_Struct(self, struct OutputBuffer, buffer);
  return INT2NUM(buffer->frames_given);
}

void Init_output_buffer() {
  mOutput = rb_define_module_under(mSoundIO, "Output");
  cBuffer = rb_define_class_under(mOutput, "Buffer", rb_cObject);
	rb_define_alloc_func(cBuffer, allocate_output_buffer);

	rb_define_method(cBuffer, "initialize", initialize_output_buffer, 1);
	rb_define_method(cBuffer, "frames_requested", get_frames_requested, 0);
	rb_define_method(cBuffer, "frames_given", get_frames_given, 0);
}
