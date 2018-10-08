#include "sound_io.h"
#include "output.h"
#include "output_buffer.h"

const char *rootName = "SoundIO";

VALUE mSoundIO = Qnil;
VALUE mOutput = Qnil;
VALUE cBuffer = Qnil;

void Init_sound_io() {
  mSoundIO = rb_define_module(rootName);
  rb_define_const(mSoundIO, "MAX_CHANNELS", UINT2NUM(SOUNDIO_MAX_CHANNELS));

  Init_output();
  Init_output_buffer();
}
