module MkApos
  module Const
    MSG_ERR_1 = "[ERROR] Binary file path is invalid!"
    MSG_ERR_2 = "[ERROR] Format: YYYYMMDD or YYYYMMDDHHMMSS or YYYYMMDDHHMMSSU..."
    MSG_ERR_3 = "[ERROR] Invalid date-time!"
    MSG_ERR_4 = "[ERROR] Binary file is not found!"
    BODIES    = {earth: 3, moon: 10, sun: 11}  # 天体名と JPL での天体番号
    AU        = 149597870700                   # 1天文単位 (m)
    C         = 299792458                      # 光速 (m/s)
    DAYSEC    = 86400                          # 1日の秒数(s)
  end
end
