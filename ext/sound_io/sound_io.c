#include <ruby.h>
#include <soundio/soundio.h>

#define MAX_SAMPLES 512 // TODO: make this build configurable

VALUE rb_mSoundIO = Qnil;
VALUE rb_cBuffer = Qnil;

struct Buffer {
  int channel_count;
  int sample_count;
  struct SoundIoChannelArea **data;
  bool channels_created;
};

void buffer_free(void *ptr) {
  struct Buffer *buffer = (struct Buffer *)ptr;

  if (buffer->channels_created)
    free(buffer->data);

  free(ptr);
}

VALUE buffer_alloc(VALUE self) {
  struct Buffer *buffer = malloc(sizeof(struct Buffer));
  return Data_Wrap_Struct(self, NULL, buffer_free, buffer);
}

VALUE buffer_init(VALUE self, VALUE channel_count, VALUE sample_count) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  buffer->channel_count = NUM2INT(channel_count);
  buffer->sample_count = NUM2INT(sample_count);
  buffer->channels_created = false;
  return self;
}

VALUE buffer_get_sample_count(VALUE self) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  return INT2NUM(buffer->sample_count);
}

VALUE buffer_get_channel_count(VALUE self) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  return INT2NUM(buffer->channel_count);
}

VALUE buffer_allocate_data(VALUE self) {
  struct Buffer *buffer;
  Data_Get_Struct(self, struct Buffer, buffer);
  buffer->channels_created = true;
  size_t struct_size = sizeof(struct SoundIoChannelArea);
  buffer->data = malloc(struct_size * SOUNDIO_MAX_CHANNELS * MAX_SAMPLES);

  if (!buffer->data)
    rb_raise(rb_eNoMemError, "Not enough memory to allocate buffer data");

  return Qnil;
}

void Init_sound_io() {
  rb_mSoundIO = rb_define_module("SoundIO");
  rb_define_const(rb_mSoundIO, "MAX_CHANNELS", UINT2NUM(SOUNDIO_MAX_CHANNELS));
  rb_define_const(rb_mSoundIO, "MAX_SAMPLES", UINT2NUM(MAX_SAMPLES));

  rb_cBuffer = rb_define_class_under(rb_mSoundIO, "Buffer", rb_cObject);
  rb_define_alloc_func(rb_cBuffer, buffer_alloc);
  rb_define_method(rb_cBuffer, "initialize", buffer_init, 2);
  rb_define_method(rb_cBuffer, "sample_count", buffer_get_sample_count, 0);
  rb_define_method(rb_cBuffer, "channel_count", buffer_get_channel_count, 0);
  rb_define_method(rb_cBuffer, "allocate_data", buffer_allocate_data, 0);
}
