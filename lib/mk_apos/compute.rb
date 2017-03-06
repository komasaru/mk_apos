module MkApos
  module Compute
    module_function

    #=========================================================================
    # UTC -> TDB
    #
    # @param:  utc  (Time Object)
    # @return: tdb  (Time Object)
    #=========================================================================
    def utc2tdb(utc)
      return MkTime.new(utc.strftime("%Y%m%d%H%M%S%6N")).tdb
    rescue => e
      raise
    end

    #=========================================================================
    # ユリウス日取得
    #
    # @param:  t   (Time Object)
    # @return: jd  (Julian Day(Numeric))
    #=========================================================================
    def get_jd(t)
      return MkTime.new(t.strftime("%Y%m%d%H%M%S%6N")).jd
    rescue => e
      raise
    end

    #=========================================================================
    # ICRS 座標取得
    #
    # * JPL DE430 データを自作 RubyGems ライブラリ eph_jpl を使用して取得。
    #
    # @param:  target  (対象天体(Symbol))
    # @param:  jd      (ユリウス日(Numeric))
    # @return: [
    #   pos_x, pos_y, pos_z,
    #   vel_x, vel_y, vel_z
    # ]                (位置・速度(Array), 単位: AU, AU/day)
    #=========================================================================
    def get_icrs(target, jd)
      return EphJpl.new(@bin_path, target, 12, jd).calc
    rescue => e
      raise
    end

    #=========================================================================
    # t2(= TDB) における地球と太陽・月の距離
    #
    # @param:  <none>
    # @return: r_e  (地球と太陽・月の距離(Hash))
    #=========================================================================
    def get_r_e
      r_e = Hash.new

      begin
        @icrs_2.each do |k, v|
          next if k == :earth
          r_e[k] = calc_dist(@icrs_2[:earth][0, 3], v[0, 3])
        end
        return r_e
      rescue => e
        raise
      end
    end

    #=========================================================================
    # 天体Aと天体Bの距離計算
    #
    # @param:   pos_a  (位置ベクトル)
    # @param:   pos_a  (位置ベクトル)
    # @return:  r      (距離)
    #=========================================================================
    def calc_dist(pos_a, pos_b)
      r =  (0..2).inject(0.0) { |sum, i| sum + (pos_b[i] -pos_a[i]) ** 2 }
      return Math.sqrt(r)
    rescue => e
      raise
    end

    #=========================================================================
    # 視黄経・視黄緯の計算（太陽）
    #
    # @param:  <none>
    # @return: [[視赤経, 視赤緯, 地心距離], [視黄経, 視黄緯, 地心距離]]
    #=========================================================================
    def compute_sun
      # === 太陽が光を発した時刻 t1(JD) の計算
      t_1_jd = calc_t1(:sun, @tdb)
      # === 時刻 t1(= TDB) におけるの位置・速度（ICRS 座標）の計算 (地球, 月, 太陽)
      Const::BODIES.each { |k, v| @icrs_1[k] = get_icrs(v, t_1_jd) }
      # === 時刻 t2 における地球重心から時刻 t1 における太陽への方向ベクトルの計算
      v_12 = calc_unit_vector(@icrs_2[:earth][0,3], @icrs_1[:sun][0,3])
      # === GCRS 座標系: 光行差の補正（方向ベクトルの Lorentz 変換）
      dd = conv_lorentz(v_12)
      pos_sun = calc_pos(dd, @r_e[:sun])
      # === 瞬時の真座標系: GCRS への bias & precession（歳差） & nutation（章動）の適用
      bpn = EphBpn.new(@tdb.strftime("%Y%m%d%H%M%S"))
      pos_sun_bpn = bpn.apply_bpn(pos_sun)
      # === 座標変換
      eq_pol_s  = MkCoord.rect2pol(pos_sun_bpn)
      ec_rect_s = MkCoord.rect_eq2ec(pos_sun_bpn, bpn.eps)
      ec_pol_s  = MkCoord.rect2pol(ec_rect_s)
      return [eq_pol_s, ec_pol_s]
    rescue => e
      raise
    end

    #=========================================================================
    # 視黄経・視黄緯の計算（月）
    #
    # @param:  <none>
    # @return: [[視赤経, 視赤緯, 地心距離], [視黄経, 視黄緯, 地心距離]]
    #=========================================================================
    def compute_moon
      # === 月が光を発した時刻 t1(jd) の計算
      t_1_jd = calc_t1(:moon, @tdb)
      # === 時刻 t1(= TDB) におけるの位置・速度（ICRS 座標）の計算 (地球, 月, 太陽)
      Const::BODIES.each { |k, v| @icrs_1[k] = get_icrs(v, t_1_jd) }
      # === 時刻 t2 における地球重心から時刻 t1 における月への方向ベクトルの計算
      v_12 = calc_unit_vector(@icrs_2[:earth][0,3], @icrs_1[:moon][0,3])
      # === GCRS 座標系: 光行差の補正（方向ベクトルの Lorentz 変換）
      dd = conv_lorentz(v_12)
      pos_moon = calc_pos(dd, @r_e[:moon])
      # === 瞬時の真座標系: GCRS への bias & precession（歳差） & nutation（章動）の適用
      bpn = EphBpn.new(@tdb.strftime("%Y%m%d%H%M%S"))
      pos_moon_bpn = bpn.apply_bpn(pos_moon)
      # === 座標変換
      eq_pol_m  = MkCoord.rect2pol(pos_moon_bpn)
      ec_rect_m = MkCoord.rect_eq2ec(pos_moon_bpn, bpn.eps)
      ec_pol_m  = MkCoord.rect2pol(ec_rect_m)
      return [eq_pol_m, ec_pol_m]
    rescue => e
      raise
    end

    #=========================================================================
    # 対象天体が光を発した時刻 t1 の計算（太陽・月専用）
    #
    # * 計算式： c * (t2 - t1) = r12  (但し、 c: 光の速度。 Newton 法で近似）
    # * 太陽・月専用なので、太陽・木星・土星・天王星・海王星の重力場による
    #   光の曲がりは非考慮。
    #
    # @param:  target  (対象天体(Symbol))
    # @param:  tdb     (Time Object(観測時刻;TDB))
    # @return: t_1     (Numeric(Julian Day))
    #=========================================================================
    def calc_t1(target, tdb)
      t_1 = MkTime.new(tdb.strftime("%Y%m%d%H%M%S")).jd
      t_2 = t_1
      pv_1 = @icrs_2[target]
      df, m = 1.0, 0
      while df > 1.0e-10
        r_12 = (0..2).map { |i| pv_1[i] - @icrs_2[:earth][i] }
        r_12_d = calc_dist(pv_1, @icrs_2[:earth])
        df = (Const::C * Const::DAYSEC / Const::AU) * (t_2 - t_1) - r_12_d
        df_wk = (0..2).inject(0.0) { |s, i| s + r_12[i] * @icrs_2[target][i + 3] }
        df /= ((Const::C * Const::DAYSEC / Const::AU) + (df_wk) / r_12_d)
        t_1 += df
        m += 1
        raise Const::MSG_ERR_5 if m > 10
        pv_1 = get_icrs(Const::BODIES[target], t_1)
      end
      return t_1
    rescue => e
      raise
    end

    #=========================================================================
    # 天体Aから見た天体Bの方向ベクトル計算（太陽・月専用）
    #
    # * 太陽・月専用なので、太陽・木星・土星・天王星・海王星の重力場による
    #   光の曲がりは非考慮。
    #
    # @param:   pos_a  (位置ベクトル(天体A))
    # @param:   pos_b  (位置ベクトル(天体B))
    # @return:  vec    (方向(単位)ベクトル)
    #=========================================================================
    def calc_unit_vector(pos_a, pos_b)
      vec = [0.0, 0.0, 0.0]

      begin
        w = calc_dist(pos_a, pos_b)
        vec = (0..2).map { |i| pos_b[i] - pos_a[i] }
        return vec.map { |v| v / w } unless w == 0.0
      rescue => e
        raise
      end
    end

    #=========================================================================
    # 光行差の補正（方向ベクトルの Lorentz 変換）
    #
    # * vec_dd = f * vec_d + (1 + g / (1 + f)) * vec_v
    #   但し、 f = vec_v * vec_d  (ベクトル内積)
    #          g = sqrt(1 - v^2)  (v: 速度)
    #
    # @param:  v_d   (方向（単位）ベクトル)
    # @return: v_dd  (補正後ベクトル)
    #=========================================================================
    def conv_lorentz(vec_d)
      vec_v = @icrs_2[:earth][3,3].map { |v| (v / Const::DAYSEC) / (Const::C / Const::AU.to_f) }
      g = inner_prod(vec_v, vec_d)
      f = Math.sqrt(1.0 - calc_velocity(vec_v))
      vec_dd_1 = vec_d.map { |d| d * f }
      vec_dd_2 = vec_v.map { |v| (1.0 + g / (1.0 + f)) * v }
      vec_dd = (0..2).map { |i| vec_dd_1[i] + vec_dd_2[i] }.map { |a| a / (1.0 + g) }
      return vec_dd
    rescue => e
      raise
    end

    #=========================================================================
    # ベクトルの内積
    #
    # @param:  a  (ベクトル)
    # @param:  b  (ベクトル)
    # @return: w  (スカラー(内積の値))
    #=========================================================================
    def inner_prod(a, b)
      return (0..2).inject(0.0) { |s, i| s + a[i] * b[i] }
    rescue => e
      raise
    end

    #=========================================================================
    # 天体の速度ベクトルから実際の速度を計算
    #
    # @param:   vec  (ベクトル)
    # @return:  v    (速度)
    #=========================================================================
    def calc_velocity(vec)
      v = vec.inject(0.0) { |s, i| s + i * i }
      return Math.sqrt(v)
    rescue => e
      raise
    end

    #=========================================================================
    # 単位（方向）ベクトルと距離から位置ベクトルを計算
    #
    # @param:  d    (単位（方向）ベクトル)
    # @param:  r    (距離)
    # @return  pos  (位置ベクトル)
    #=========================================================================
    def calc_pos(d, r)
      return d.map { |a| a * r }
    rescue => e
      raise
    end
  end
end

