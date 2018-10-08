#ifndef OUTPUT_RB_H
#define OUTPUT_RB_H

#include <ruby.h>
#include <soundio/soundio.h>

VALUE begin_write(VALUE stream, VALUE buffer);

void Init_output();

#endif
