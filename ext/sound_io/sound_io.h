#include <ruby.h>
#include <soundio/soundio.h>

const char *rootName = "SoundIO";

VALUE mSoundIO = Qnil;

void Init_sound_io();
