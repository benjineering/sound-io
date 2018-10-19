require 'ffi'

module SoundIO
  extend FFI::Library
  
  BACKEND = enum(:backend, [
    :none,
    :jack,
    :pulse_audio,
    :alsa,
    :core_audio,
    :wasapi,
    :dummy
  ])

  AIM = enum(:aim, [
    :input,
    :output
  ])

  FORMAT = enum(:format, [
    :invalid,
    :s8, :u8,
    :s16le, :s16be,
    :u16le, :u16be,
    :s24le, :s24be,
    :u24le, :u24be,
    :s32le, :s32be,
    :u32le, :u32be,
    :float32le, :float32be,
    :float64le, :float64be
  ])

  CHANNEL_ID = enum(:channel_id, [
    :invalid,
    :front_left,
    :front_right,
    :front_center,
    :lfe,
    :back_left,
    :back_right,
    :front_left_center,
    :front_right_center,
    :back_center,
    :side_left,
    :side_right,
    :top_center,
    :top_front_left,
    :top_front_center,
    :top_front_right,
    :top_back_left,
    :top_back_center,
    :top_back_right,
    :back_left_center,
    :back_right_center,
    :front_left_wide,
    :front_right_wide,
    :front_left_high,
    :front_center_high,
    :front_right_high,
    :top_front_left_center,
    :top_front_right_center,
    :top_side_left,
    :top_side_right,
    :left_lfe,
    :right_lfe,
    :lfe_2,
    :bottom_center,
    :bottom_left_center,
    :bottom_right_center,
    :ms_mid,
    :ms_side,
    :ambisonic_w,
    :ambisonic_x,
    :ambisonic_y,
    :ambisonic_z,
    :xy_x,
    :xy_y,
    :headphones_left,
    :headphones_right,
    :click_track,
    :foreign_language,
    :hearing_impaired,
    :narration,
    :haptic,
    :dialog_centric_mix,
    :aux,
    :aux_0,
    :aux_1,
    :aux_2,
    :aux_3,
    :aux_4,
    :aux_5,
    :aux_6,
    :aux_7,
    :aux_8,
    :aux_9,
    :aux_10,
    :aux_11,
    :aux_12,
    :aux_13,
    :aux_14,
    :aux_15   
  ])

  ERROR = enum(:error, [
    :none,
    :no_mem,
    :init_audio_backend,
    :system_resources,
    :opening_device,
    :no_such_device,
    :invalid,
    :backend_unavailable,
    :streaming,
    :incompatible_device,
    :no_such_client,
    :incompatible_backend,
    :backend_disconnected,
    :interrupted,
    :underflow,
    :encoding_string
  ])
end
