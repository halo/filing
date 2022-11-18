module Filing
  class ImageFormat
    def initialize(path)
      @path = path
      # puts to_h
    end

    def jpeg?
      exif[:mime_type] == 'image/jpeg'
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
