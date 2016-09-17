require "spec_helper"

describe MkApos::Const do
  context "MSG_ERR_1" do
    it { expect(MkApos::Const::MSG_ERR_1).to eq "[ERROR] Binary file path is invalid!" }
  end

  context "MSG_ERR_2" do
    it { expect(MkApos::Const::MSG_ERR_2).to eq "[ERROR] Format: YYYYMMDD or YYYYMMDDHHMMSS or YYYYMMDDHHMMSSU..." }
  end

  context "MSG_ERR_3" do
    it { expect(MkApos::Const::MSG_ERR_3).to eq "[ERROR] Invalid date-time!" }
  end

  context "MSG_ERR_4" do
    it { expect(MkApos::Const::MSG_ERR_4).to eq "[ERROR] Binary file is not found!" }
  end

  context "MSG_ERR_5" do
    it { expect(MkApos::Const::MSG_ERR_5).to eq "[ERROR] Newton method error!" }
  end

  context "BODIES" do
    it { expect(MkApos::Const::BODIES).to match({earth: 3, moon: 10, sun: 11}) }
  end

  context "AU" do
    it { expect(MkApos::Const::AU).to eq 149597870700 }
  end

  context "C" do
    it { expect(MkApos::Const::C).to eq 299792458 }
  end

  context "DAYSEC" do
    it { expect(MkApos::Const::DAYSEC).to eq 86400 }
  end
end

