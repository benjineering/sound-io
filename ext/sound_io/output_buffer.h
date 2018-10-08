#ifndef OUTPUT_BUFFER_RB_H
#define OUTPUT_BUFFER_RB_H

#include <ruby.h>
#include <soundio/soundio.h>

struct OutputBuffer {
  int frames_requested;
  int frames_given;
  struct SoundIoChannelArea *areas;
};

VALUE allocate_output_buffer(VALUE self);

VALUE initialize_output_buffer(VALUE self, VALUE frame_count);

void free_output_buffer(void *buffer);

void Init_output_buffer();

#endif
