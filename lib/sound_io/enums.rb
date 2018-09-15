require 'ffi'

module SoundIO
  extend FFI::Library
  
  # TODO: make sure all enum int values are correct
  
  enum(:backend, [
    :none,
    :jack,
    :pulse_audio,
    :alsa,
    :core_audio,
    :wasapi,
    :dummy
  ])

  enum(:aim, [
    :input,
    :output
  ])

  enum(:format, [
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

  # TODO: snake case
  enum(:channel_id, [
    :Invalid,
    :FrontLeft,
    :FrontRight,
    :FrontCenter,
    :Lfe,
    :BackLeft,
    :BackRight,
    :FrontLeftCenter,
    :FrontRightCenter,
    :BackCenter,
    :SideLeft,
    :SideRight,
    :TopCenter,
    :TopFrontLeft,
    :TopFrontCenter,
    :TopFrontRight,
    :TopBackLeft,
    :TopBackCenter,
    :TopBackRight,
    :BackLeftCenter,
    :BackRightCenter,
    :FrontLeftWide,
    :FrontRightWide,
    :FrontLeftHigh,
    :FrontCenterHigh,
    :FrontRightHigh,
    :TopFrontLeftCenter,
    :TopFrontRightCenter,
    :TopSideLeft,
    :TopSideRight,
    :LeftLfe,
    :RightLfe,
    :Lfe2,
    :BottomCenter,
    :BottomLeftCenter,
    :BottomRightCenter,
    :MsMid,
    :MsSide,
    :AmbisonicW,
    :AmbisonicX,
    :AmbisonicY,
    :AmbisonicZ,
    :XyX,
    :XyY,
    :HeadphonesLeft,
    :HeadphonesRight,
    :ClickTrack,
    :ForeignLanguage,
    :HearingImpaired,
    :Narration,
    :Haptic,
    :DialogCentricMix,
    :Aux,
    :Aux0,
    :Aux1,
    :Aux2,
    :Aux3,
    :Aux4,
    :Aux5,
    :Aux6,
    :Aux7,
    :Aux8,
    :Aux9,
    :Aux10,
    :Aux11,
    :Aux12,
    :Aux13,
    :Aux14,
    :Aux15   
  ])
end
