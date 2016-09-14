require "eph_bpn"
require "eph_jpl"
require "mk_coord"
require "mk_time"
require "mk_apos/version"
require "mk_apos/argument"
require "mk_apos/compute"
require "mk_apos/const"
require "mk_apos/apos"

module MkApos
  def self.new(*args)
    bin_path, utc = MkApos::Argument.new(*args).get_args
    return unless utc
    return MkApos::Apos.new(bin_path, utc)
  end
end
