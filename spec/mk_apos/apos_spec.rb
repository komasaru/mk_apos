require "spec_helper"

describe MkApos::Apos do
  let(:a) { MkApos::Apos.new(BIN_PATH, Time.new(2016, 9, 14)) }

  context %Q{.new(BIN_PATH, "20160914")} do
    context "object" do
      it { expect(a).to be_an_instance_of(MkApos::Apos) }
    end

    context "@bin_path" do
      it { expect(a.instance_variable_get(:@bin_path)).to eq BIN_PATH }
    end

    context "@utc" do
      it { expect(a.instance_variable_get(:@utc).strftime("%Y-%m-%d %H:%M:%S")).to eq "2016-09-14 00:00:00" }
    end

    context "@tdb" do
      it { expect(a.instance_variable_get(:@tdb).strftime("%Y-%m-%d %H:%M:%S.%3N")).to eq "2016-09-14 00:01:08.183" }
    end

    context "@jd_tdb" do
      it { expect(a.instance_variable_get(:@jd_tdb)).to eq 2457645.500787037 }
    end

    context "@icrs_1" do
      it { expect(a.instance_variable_get(:@icrs_1)).to match({}) }
    end

    context "@icrs_2" do
      it { expect(a.instance_variable_get(:@icrs_2)).to match({
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
      }) }
    end

    context "@r_e" do
      it { expect(a.instance_variable_get(:@r_e)).to match({
        :moon=>0.0025239377631452206, :sun=>1.0058592176465242
      }) }
    end

    context ".sun" do
      it { expect(a.sun).to match([
        [3.0070685215959077,  0.058072971946920966,   1.0058095460105199],
        [2.9951384305984847, -2.9122663766601165e-06, 1.0058095460105196]
      ]) }
    end

    context ".moon" do
      it { expect(a.moon).to match([
        [5.524131039832363, -0.24467435451601738, 0.0025238131175808805],
        [5.494165512286052,  0.0433460111382259,  0.0025238131175808805]
      ]) }
    end
  end
end

