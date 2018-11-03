#include <ruby.h>
#include <soundio/soundio.h>

VALUE rb_mSoundIO = Qnil;
VALUE rb_cBuffer = Qnil;

struct Buffer {
  int frame_count;
  int channel_count;
  struct SoundIoChannelArea *channel_areas;
};

void buffer_free(void *buffer) {
  free(buffer);
}

VALUE buffer_alloc(VALUE self) {
  struct Buffer *buffer = malloc(sizeof(struct Buffer));
  return Data_Wrap_Struct(self, NULL, buffer_free, buffer);
}

VALUE buffer_init(VALUE self, VALUE frame_count, VALUE channel_count) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  buffer->frame_count = NUM2INT(frame_count);
  buffer->channel_count = NUM2INT(channel_count);
  return self;
}

VALUE buffer_set_frame_count(VALUE self, VALUE frame_count) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  buffer->frame_count = NUM2INT(frame_count);
  return frame_count;
}

VALUE buffer_get_frame_count(VALUE self) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  return INT2NUM(buffer->frame_count);
}

VALUE buffer_set_channel_count(VALUE self, VALUE channel_count) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  buffer->channel_count = NUM2INT(channel_count);
  return channel_count;
}

VALUE buffer_get_channel_count(VALUE self) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  return INT2NUM(buffer->channel_count);
}

void Init_sound_io() {
  rb_mSoundIO = rb_define_module("SoundIO");
  rb_define_const(rb_mSoundIO, "MAX_CHANNELS", UINT2NUM(SOUNDIO_MAX_CHANNELS));

  rb_cBuffer = rb_define_class_under(rb_mSoundIO, "Buffer", rb_cObject);
  rb_define_alloc_func(rb_cBuffer, buffer_alloc);
  rb_define_method(rb_cBuffer, "initialize", buffer_init, 2);

  rb_define_method(rb_cBuffer, "frame_count=", buffer_set_frame_count, 1);
  rb_define_method(rb_cBuffer, "frame_count", buffer_get_frame_count, 0);

  rb_define_method(rb_cBuffer, "channel_count=", buffer_set_channel_count, 1);
  rb_define_method(rb_cBuffer, "channel_count", buffer_get_channel_count, 0);
}
