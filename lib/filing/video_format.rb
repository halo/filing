module Filing
  class VideoFormat
    def initialize(path)
      @path = path
      # puts to_h
    end

    def mpeg1?
      exif[:compressor_id] == 'mp1v' ||
        exif[:mpeg_audio_version] == 1
    end

    def mpeg4?
      exif[:compressor_id] == 'mp4v'
    end

    def h264?
      exif[:compressor_name] == 'H.264'
    end

    def to_h
      exif.to_hash
    end

    private

    attr_reader :path

    def exif
      @exif ||= Exiftool.new(path.to_s)
    end
  end
end
