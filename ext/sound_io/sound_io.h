#ifndef SOUNDIO_RB_H
#define SOUNDIO_RB_H

#include <ruby.h>
#include <soundio/soundio.h>

extern const char *rootName;

extern VALUE mSoundIO;
extern VALUE mOutput;
extern VALUE cBuffer;

void Init_sound_io();

#endif
