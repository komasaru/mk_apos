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
      # === 太陽／月／地球の半径取得
      e = EphJpl.new(@bin_path, 11, 3, @jd_tdb)
      @asun = e.bin[:cvals][e.bin[:cnams].index("ASUN")]
      @am   = e.bin[:cvals][e.bin[:cnams].index("AM")]
      @re   = e.bin[:cvals][e.bin[:cnams].index("RE")]
    end

    #=========================================================================
    # SUN
    #
    # @param:  <none>
    # @return: [[lambda, beta, d], [alpha, delta, d], [apparent_radius, parallax]]
    #          (太陽視黄経、視黄緯、地心距離、視赤経、視赤緯、地心距離、視半径、視差))
    #=========================================================================
    def sun
      return compute_sun
    end

    #=========================================================================
    # MOON
    #
    # @param:  <none>
    # @return: [[lambda, beta, d], [alpha, delta, d], [apparent_radius, parallax]]
    #          (月視黄経、視黄緯、地心距離、視赤経、視赤緯、地心距離、視半径、視差))
    #=========================================================================
    def moon
      return compute_moon
    end
  end
end

