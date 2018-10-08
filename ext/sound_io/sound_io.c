#include "sound_io.h"
#include "output_buffer.h"

void Init_sound_io() {
  mSoundIO = rb_define_module(rootName);
  rb_define_const(mSoundIO, "MAX_CHANNELS", UINT2NUM(SOUNDIO_MAX_CHANNELS));
  Init_output_buffer();
}
