module Filing
  class CreationTime
    include Calls

    param :path

    def call
      # Filing.debug exif.to_hash

      if raw_time
        Filing.debug "  Detected creation timestamp in metadata: #{raw_time}"
        return(Time.parse(raw_time) rescue nil)
      end

      unless Filing::Params.year
        Filing.debug '  Not evaluating file creation time without reference --year'
        return
      end

      if possible_original_content_date.year  == Filing::Params.year.to_i
        Filing.debug '  Reference --year warrants metadata file modification date'
        return possible_original_content_date
      end

      if path.birthtime.year == Filing::Params.year.to_i
        Filing.debug '  Reference --year warrants file birth timestamp'
        return path.birthtime
      end

      Filing.debug "  No creation time detectable. Creation time was #{path.birthtime} but --year is #{Filing::Params.year.to_i}"

      return nil
    end

    private

    def possible_original_content_date
      modify_date = read(:file_modify_date)
      return unless modify_date

      Time.parse modify_date
    end

    def raw_time
      read(:media_create_date) ||
        read(:track_create_date) ||
        read(:create_date) ||
        read(:creation_date) ||
        read(:modify_date)
    end

    def read(tag)
      return unless exif[tag]
      return if exif[tag] == '0000:00:00 00:00:00'
      return exif[tag].to_s if exif[tag].is_a?(Time)

      exif[tag].sub(':', "-").sub(':', "-")
    end

    def exif
      @exif ||= Exiftool.new(path.to_s)
    end
  end
end
