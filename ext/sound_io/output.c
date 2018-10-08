#include "sound_io.h"
#include "output.h"

void Init_output() {
  mOutput = rb_define_module_under(mSoundIO, "Output");
}
