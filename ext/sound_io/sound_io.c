#include <ruby.h>
#include <soundio/soundio.h>

VALUE rb_mSoundIO = Qnil;

VALUE max_channels() {
  return UINT2NUM(SOUNDIO_MAX_CHANNELS);
}

void Init_sound_io() {
  rb_mSoundIO = rb_define_module("SoundIO");
  rb_define_singleton_method(rb_mSoundIO, "MAX_CHANNELS", max_channels, 0);
}
