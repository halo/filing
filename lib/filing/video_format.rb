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

    def avc?
      exif[:compressor_id] == 'avc1'
    end

    def mpeg4?
      exif[:compressor_id] == 'mp4v'
    end

    def h264?
      exif[:compressor_name] == 'H.264'
    end

    def h265?
      exif[:compressor_id] == 'hvc1'
    end

    def to_h
      exif.to_hash
    end

    def portrait?
      width = exif[:image_width].to_i
      height = exif[:image_height].to_i

      if exif[:rotation].abs == 90
        height > width
      else
        width > height
      end
    end

    private

    attr_reader :path

    def exif
      @exif ||= Exiftool.new(path.to_s)
    end
  end
end
