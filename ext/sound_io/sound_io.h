#ifndef SOUNDIO_RB_H
#define SOUNDIO_RB_H

#include <ruby.h>
#include <soundio/soundio.h>

extern const char *rootName;

extern VALUE mSoundIO;
extern VALUE mBuffer;
extern VALUE cOutputBuffer;

void Init_sound_io();

#endif
