module MkApos
  class Argument
    def initialize(*args)
      @args = *args
    end

    #=========================================================================
    # 引数取得
    #
    # @return: [BIN_PATH, TARGET, CENTER, JD, KM]
    #=========================================================================
    def get_args
      bin_path = get_binpath
      utc      = get_utc
      check_bin_path(bin_path)
      return [bin_path, utc]
    rescue => e
      raise
    end

    def get_binpath
      raise unless bin_path = @args.shift
      return bin_path
    rescue => e
      raise Const::MSG_ERR_1
    end

    def get_utc
      utc = @args.shift
      return Time.now unless utc
      (raise Const::MSG_ERR_2) unless utc =~ /^\d{8}$|^\d{14,}$/
      year, month, day = utc[ 0, 4].to_i, utc[ 4, 2].to_i, utc[ 6, 2].to_i
      hour, min,   sec = utc[ 8, 2].to_i, utc[10, 2].to_i, utc[12, 2].to_i
      usec = utc.split(//).size > 14 ? utc[14..-1].to_s : "0"
      (raise Const::MSG_ERR_3) unless Date.valid_date?(year, month, day)
      (raise Const::MSG_ERR_3) if hour > 23 || min > 59 || sec > 60
      d = usec.split(//).size
      return Time.new(year, month, day, hour, min, sec + Rational(usec.to_i, 10 ** d), "+00:00")
    end

    def check_bin_path(bin_path)
      raise Const::MSG_ERR_4 unless File.exist?(bin_path)
    end
  end
end
