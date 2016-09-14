module MkApos
  class Apos
    attr_reader :utc, :tdb, :jd_tdb
    include MkApos::Compute

    def initialize(bin_path, utc)
      @bin_path, @utc = bin_path, utc
      # === t1(= TDB), t2(= TDB) における位置・速度（ICRS 座標）用Hash
      @icrs_1, @icrs_2 = Hash.new, Hash.new
      # === 時刻 t2 の変換（UTC（協定世界時） -> TDB（太陽系力学時））
      @tdb = utc2tdb(@utc)
      # === 時刻 t2 のユリウス日
      @jd_tdb = get_jd(@tdb)
      # === 時刻 t2(= TDB) におけるの位置・速度（ICRS 座標）の計算 (地球, 月, 太陽)
      Const::BODIES.each { |k, v| @icrs_2[k] = get_icrs(v, @jd_tdb) }
      # === 時刻 t2(= TDB) における地球と太陽・月の距離
      @r_e = get_r_e
    end

    #=========================================================================
    # SUN
    #
    # @param:  <none>
    # @return: [lambda, beta, d]  (太陽視黄経、視黄緯、地心距離)
    #=========================================================================
    def sun
      return compute_sun
    end

    #=========================================================================
    # MOON
    #
    # @param:  <none>
    # @return: [alpha, delta]  (月視黄経、視黄緯、地心距離)
    #=========================================================================
    def moon
      return compute_moon
    end
  end
end

