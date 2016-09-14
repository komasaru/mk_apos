require "spec_helper"

describe MkApos::Compute do
  let(:c) { MkApos::Compute }

  context ".utc2tdb" do
    subject { c.utc2tdb(Time.new(2016, 9, 14, 0, 0, 0, "+00:00")) }
    it { expect(subject.strftime("%Y-%m-%d %H:%M:%S.%3N")).to eq "2016-09-14 00:01:08.183" }
  end

  context ".get_jd" do
    subject { c.get_jd(Time.new(2016, 9, 14, 0, 0, 0, "+00:00")) }
    it { expect(subject).to eq 2457645.5 }
  end

  context ".get_icrs" do
    subject do
      c.instance_variable_set(:@bin_path, BIN_PATH)
      c.get_icrs(11, 2457645.5)
    end

    it { expect(subject).to match([
       0.003623210694950384,   0.0029966921407106706, 0.0011238080782776936,
      -1.7211977914374161e-06, 6.328349880636831e-06, 2.779749706139297e-06
    ]) }
  end

  context ".get_r_e" do
    subject do
      c.instance_variable_set(:@icrs_2, {
        :earth=>[
          0.9981270552447827,   -0.13528095997712516, -0.05882746789404572,
          0.0022912124593013673, 0.015549187928962788, 0.006741398808224201
        ],
        :moon=>[
          0.9998963526179615,   -0.13697283858511208, -0.05944179306309665,
          0.0026927883371321254, 0.015978427314606927, 0.0068724380388787846
        ],
        :sun=>[
           0.0036232093403012794,  0.002996697121355158,   0.0011238102660431966,
          -1.7212049801742067e-06, 6.3283479524464985e-06, 2.7797490636283164e-06
        ]
      })
      c.get_r_e
    end

    it { expect(subject).to match({
      :moon=>0.0025239377631452206, :sun=>1.0058592176465242
    }) }
  end

  context ".calc_dist" do
    subject { c.calc_dist(
      [0.9981270552447827, -0.13528095997712516, -0.05882746789404572],
      [0.9998963526179615, -0.13697283858511208, -0.05944179306309665]
    ) }

    it { expect(subject).to eq 0.0025239377631452206 }
  end

  context ".compute_sun" do
    let(:tdb) { c.utc2tdb(Time.new(2016, 9, 14, 0, 0, 0, "+00:00")) }
    subject do
      c.instance_variable_set(:@tdb, tdb)
      c.instance_variable_set(:@icrs_1, {})
      c.instance_variable_set(:@icrs_2, {
        :earth=>[
          0.9981270552447827,   -0.13528095997712516, -0.05882746789404572,
          0.0022912124593013673, 0.015549187928962788, 0.006741398808224201
        ],
        :moon=>[
          0.9998963526179615,   -0.13697283858511208, -0.05944179306309665,
          0.0026927883371321254, 0.015978427314606927, 0.0068724380388787846
        ],
        :sun=>[
           0.0036232093403012794,  0.002996697121355158,   0.0011238102660431966,
          -1.7212049801742067e-06, 6.3283479524464985e-06, 2.7797490636283164e-06
        ]
      })
      c.instance_variable_set(:@r_e, {
        :moon=>0.0025239377631452206, :sun=>1.0058592176465242
      })
      c.compute_sun
    end

    it { expect(subject).to match([
      [3.0070685215959077, 0.058072971946920966, 1.0058095460105199],
      [2.9951384305984847, -2.9122663766601165e-06, 1.0058095460105196]
    ]) }
  end

  context ".compute_moon" do
    let(:tdb) { c.utc2tdb(Time.new(2016, 9, 14, 0, 0, 0, "+00:00")) }
    subject do
      c.instance_variable_set(:@tdb, tdb)
      c.instance_variable_set(:@icrs_1, {})
      c.instance_variable_set(:@icrs_2, {
        :earth=>[
          0.9981270552447827,   -0.13528095997712516, -0.05882746789404572,
          0.0022912124593013673, 0.015549187928962788, 0.006741398808224201
        ],
        :moon=>[
          0.9998963526179615,   -0.13697283858511208, -0.05944179306309665,
          0.0026927883371321254, 0.015978427314606927, 0.0068724380388787846
        ],
        :sun=>[
           0.0036232093403012794,  0.002996697121355158,   0.0011238102660431966,
          -1.7212049801742067e-06, 6.3283479524464985e-06, 2.7797490636283164e-06
        ]
      })
      c.instance_variable_set(:@r_e, {
        :moon=>0.0025239377631452206, :sun=>1.0058592176465242
      })
      c.compute_moon
    end

    it { expect(subject).to match([
      [5.524131039832363, -0.24467435451601738, 0.0025238131175808805],
      [5.494165512286052, 0.0433460111382259, 0.0025238131175808805]
    ]) }
  end

  context ".calc_t1" do
    subject do
      c.instance_variable_set(:@icrs_2, {
        :earth=>[
          0.9981270552447827,   -0.13528095997712516, -0.05882746789404572,
          0.0022912124593013673, 0.015549187928962788, 0.006741398808224201
        ],
        :moon=>[
          0.9998963526179615,   -0.13697283858511208, -0.05944179306309665,
          0.0026927883371321254, 0.015978427314606927, 0.0068724380388787846
        ],
        :sun=>[
           0.0036232093403012794,  0.002996697121355158,   0.0011238102660431966,
          -1.7212049801742067e-06, 6.3283479524464985e-06, 2.7797490636283164e-06
        ]
      })
      c.calc_t1(:sun, Time.new(2016, 9, 14, 0, 0, 0, "+00:00"))
    end
    it { expect(subject).to eq 2457645.494185785 }
  end

  context ".calc_unit_vector" do
    let(:pos_a) { [0.9981270552447827, -0.13528095997712516, -0.05882746789404572] }
    let(:pos_b) { [0.9998963526179615, -0.13697283858511208, -0.05944179306309665] }
    subject { c.calc_unit_vector(pos_a, pos_b) }
    it { expect(subject).to match(
      [0.7010067359877955, -0.6703329347862261, -0.2433994918659907]
    )}
  end

  context ".conv_lorentz" do
    let(:vec) { [0.7010067359877955, -0.6703329347862261, -0.2433994918659907] }
    subject { c.conv_lorentz(vec) }
    it { expect(subject).to match(
      [0.701027689378128, -0.6702505097006427, -0.24336323612908836]
    )}
  end

  context ".inner_prod" do
    let(:vec_a) { [0.123, -0.456, -0.789] }
    let(:vec_b) { [0.987, -0.654, -0.321] }
    subject { c.inner_prod(vec_a, vec_b) }
    it { expect(subject).to be_within(1.0e-5).of(0.672894) }
  end

  context ".calc_velocity" do
    let(:pos) { [0.0026927883371321254, 0.015978427314606927, 0.0068724380388787846] }
    subject { c.calc_velocity(pos) }
    it { expect(subject).to be_within(1.0e-8).of(0.01760089) }
  end

  context ".calc_pos" do
    let(:vec) { [0.7010067359877955, -0.6703329347862261, -0.2433994918659907] }
    subject { c.calc_pos(vec, 0.01760089) }
    it { expect(subject).to match(
      [0.012338342449380231, -0.011798456248549541, -0.004284047682389197]
    ) }
  end
end

