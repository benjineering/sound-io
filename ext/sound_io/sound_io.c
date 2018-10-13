#include <ruby.h>
#include <soundio/soundio.h>

VALUE rb_mSoundIO = Qnil;

void Init_sound_io() {
  rb_mSoundIO = rb_define_module("SoundIO");
  rb_define_const(rb_mSoundIO, "MAX_CHANNELS", UINT2NUM(SOUNDIO_MAX_CHANNELS));
}
