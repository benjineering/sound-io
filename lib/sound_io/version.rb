module SoundIO
  VERSION = '0.1.0'
  LIB_SOUNDIO_MAJOR_VERSION = 3

  def self.check_lib_version
    if LIB_SOUNDIO_MAJOR_VERSION != soundio_version_major

      # TODO: use cmd line table gem
      STDERR.puts %Q{
--------------------------------------------------------------------------------
|                                WARNING!                                      |
================================================================================
|                 Incompatible libsoundio version detected.                    |
|             Expected #{LIB_SOUNDIO_MAJOR_VERSION} but \
soundio_version_major returned #{soundio_version_major}.                 |
--------------------------------------------------------------------------------
}

    end
  end
end
