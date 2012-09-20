require "test/unit"
require "ua_tokenizer"

class TestUaTokenizer < Test::Unit::TestCase
  def test_tokenize_4part_upper
    tokens = UATokenizer.tokenize("SAMSUNG-GT-S5620-ORANGE")
    expected = ["samsung", "gt", "s5620", "orange"]
    assert_equal expected, tokens
  end


  def test_tokenize_3part_camel
    tokens = UATokenizer.tokenize("SonyEricssonCK15i")
    expected = ["sony", "ericsson", "ck15i"]
    assert_equal expected, tokens
  end


  def test_tokenize_2part_dash
    tokens = UATokenizer.tokenize("gt-s5230")
    assert_equal ["gt", "s5230"], tokens
  end


  def test_tokenize_idevice
    tokens = UATokenizer.tokenize("iPhone")
    assert_equal ["iphone"], tokens

    tokens = UATokenizer.tokenize("Apple iPad")
    assert_equal ["apple", "ipad"], tokens

    tokens = UATokenizer.tokenize("CPU iPhone OS 5_1 like Mac OS X")
    expected = ["cpu", "iphone", "os", "5.1", "like", "mac", "os", "x"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("FBForIPhone")
    assert_equal ["fb", "for", "iphone"], tokens

    tokens = UATokenizer.tokenize("CriOS")
    assert_equal ["crios"], tokens
  end


  def test_tokenize_windows
    tokens = UATokenizer.tokenize("Windows NT 5.1")
    assert_equal ["windows", "nt", "5.1"], tokens

    tokens = UATokenizer.tokenize("Windows Phone OS 7.5")
    expected = ["windows", "phone", "os", "7.5"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("IEMobile")
    assert_equal ["ie", "mobile"], tokens

    tokens = UATokenizer.tokenize("IEMobile 7.11")
    assert_equal ["ie", "mobile", "7.11"], tokens

    tokens = UATokenizer.tokenize("Win98")
    assert_equal ["win98"], tokens

    tokens = UATokenizer.tokenize("MSIE 6.0")
    assert_equal ["msie", "6.0"], tokens
  end


  def test_tokenize_4part_spaces
    tokens = UATokenizer.tokenize("HTC Desire HD A9191")
    expected =
      ["htc", "desire", "hd", "a9191"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("HTC_Touch_HD_T8282")
    expected =
      ["htc", "touch", "hd", "t8282"]
    assert_equal expected, tokens
  end


  def test_tokenize_3part_dashed
    tokens = UATokenizer.tokenize("ZTE-Sydney-Orange")
    expected = ["zte", "sydney", "orange"]
    assert_equal expected, tokens
  end


  def test_tokenize_version
    tokens = UATokenizer.tokenize("WebWatcher1.35")
    assert_equal ["webwatcher", "1.35"], tokens

    tokens = UATokenizer.tokenize("Android2.3.5")
    assert_equal ["android", "2.3.5"], tokens
  end


  def test_tokenize_nokia
    tokens = UATokenizer.tokenize("MeeGo NokiaN9")
    assert_equal ["meego", "nokia", "n9"], tokens
  end


  def test_tokenize_ambiguous_scrunched_names
    tokens = UATokenizer.tokenize("HPiPAQ910")
    assert_equal ["hp", "ipaq", "910"], tokens

    tokens = UATokenizer.tokenize("HuaweiU3100")
    assert_equal ["huawei", "u3100"], tokens

    tokens = UATokenizer.tokenize("EFS-EE-ORG-P107A20V1.0.5")
    expected = ["efs", "ee", "org", "p107", "a20", "v1.0.5"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("DoCoMo")
    assert_equal ["docomo"], tokens
  end


  def test_tokenize_twitter_android
    tokens = UATokenizer.tokenize("TwitterAndroid")
    assert_equal ["twitter", "android"], tokens
  end


  def test_tokenize_special_browser
    tokens = UATokenizer.tokenize("UP.Browser")
    assert_equal ["up_browser"], tokens

    tokens = UATokenizer.tokenize("NetFront")
    assert_equal ["netfront"], tokens

    tokens = UATokenizer.tokenize("UC Browser7.7.1.88")
    assert_equal ["uc", "browser", "7.7.1.88"], tokens

    tokens = UATokenizer.tokenize("WAP-Browser")
    assert_equal ["wap", "browser"], tokens

    tokens = UATokenizer.tokenize("TelecaBrowser")
    assert_equal ["teleca", "browser"], tokens
  end


  def test_tokenize_series_60
    tokens = UATokenizer.tokenize("S60V5")
    assert_equal ["s60", "v5"], tokens

    tokens = UATokenizer.tokenize("Series60")
    assert_equal ["series", "60"], tokens
  end


  def test_tokenize_lg
    tokens = UATokenizer.tokenize("LG-KU990i")
    assert_equal ["lg", "ku990i"], tokens

    tokens = UATokenizer.tokenize("LG-LGC300")
    assert_equal ["lg", "lgc", "300"], tokens

    tokens = UATokenizer.tokenize("LGPlayer")
    assert_equal ["lg", "player"], tokens
  end


  def tokenize_nintendo
    tokens = UATokenizer.tokenize("Nintendo DSi")
    assert_equal ["nintendo", "dsi"], tokens
  end


  def test_tokenize_webkit
    tokens = UATokenizer.tokenize("WebKit")
    assert_equal ["webkit"], tokens

    tokens = UATokenizer.tokenize("AppleWebKit")
    assert_equal ["apple", "webkit"], tokens
  end


  def test_tokenize_blackberry
    tokens = UATokenizer.tokenize("BlackBerry")
    assert_equal ["black", "berry"], tokens

    tokens = UATokenizer.tokenize("BlackBerry9550")
    assert_equal ["black", "berry", "9550"], tokens
  end


  def test_tokenize_webos
    tokens = UATokenizer.tokenize("webOS")
    assert_equal ["web", "os"], tokens
  end


  def test_tokenize_symbian
    tokens = UATokenizer.tokenize("SymbianOS")
    assert_equal ["symbian", "os"], tokens

    tokens = UATokenizer.tokenize("SymbOS")
    assert_equal ["symb", "os"], tokens
  end


  def test_parse_product_typical
    map = UATokenizer.parse_product "Bada/1.0"
    assert_equal({"bada" => "1.0"}, map)

    map = UATokenizer.parse_product "AppleWebKit/533.1"
    expected = {"apple"=>"533.1", "apple_webkit"=>"533.1", "webkit"=>"533.1"}
    assert_equal expected, map

    map = UATokenizer.parse_product "UP.Browser/6.2.3.8"
    assert_equal({"up_browser" => "6.2.3.8"}, map)
  end


  def test_parse_product_2part
    map = UATokenizer.parse_product "SonyEricssonCK15i/R3AC020"
    tokens = ["sony", "sony_ericsson", "ericsson", "ericsson_ck15i", "ck15i"]
    expected = {
      "sony"           =>"r3ac020",
      "sony_ericsson"  =>"r3ac020",
      "ericsson"       =>"r3ac020",
      "ericsson_ck15i" =>"r3ac020",
      "ck15i"          =>"r3ac020",
      "r3"             =>true,
      "r3_ac020"       =>true,
      "ac020"          =>true
    }
    assert_equal expected, map

    map = UATokenizer.parse_product "Nokia201/11.21"
    expected = {"nokia" => "11.21", "nokia_201" => "11.21"}
    assert_equal expected, map

    map = UATokenizer.parse_product "Treo800w/v0100"
    expected = {"treo" => "v0100", "treo_800w" => "v0100", "800w" => "v0100"}
    assert_equal expected, map

    map = UATokenizer.parse_product "PalmSource/Palm-D061"
    expected = {
      "palm"        =>"palm-d061",
      "source"      =>"palm-d061",
      "palm_source" =>"palm-d061",
      "palm_d061"   =>true,
      "d061"        =>true
    }
    assert_equal expected, map
  end


  def test_parse_product_3part
    map = UATokenizer.parse_product "POLARIS/6.01/AMB"
    assert_equal({"polaris"=>"6.01", "amb" => true}, map)

    map = UATokenizer.parse_product "Opera Mini/3.1.9427/1724"
    expected = {
      "opera"      =>"3.1.9427",
      "opera_mini" =>"3.1.9427",
      "mini"       =>"3.1.9427"
    }
    assert_equal(expected, map)

    map = UATokenizer.parse_product "UC Browser7.7.1.88/69/444"
    expected = {
      "uc"=>"7.7.1.88",
      "uc_browser"=>"7.7.1.88"
    }
    assert_equal(expected, map)
  end


  def test_parse_product_3part_common
    map = UATokenizer.parse_product "Browser/NetFront/3.4"
    assert_equal({"netfront" => "3.4"}, map)
  end


  def test_parse_product_4part
    map = UATokenizer.parse_product "Vodafone/1.0/LG-KU990i/V10c"
    expected = {
      "vodafone"  =>"1.0",
      "lg"        =>"v10c",
      "lg_ku990i" =>"v10c",
      "ku990i"    =>"v10c",
      "v10c"      =>true
    }
    assert_equal(expected, map)
  end


  def test_parse_product_blackberry
    map = UATokenizer.parse_product "BlackBerry9550/5.0.0.550"
    expected = {
      "blackberry"      => "5.0.0.550",
      "blackberry_9550" => "5.0.0.550",
    }

    assert_equal expected, map
  end


  def test_parse_product_webos
    map = UATokenizer.parse_product "webOS/1.4.5"
    expected = {
      "web_os" => "1.4.5",
    }

    assert_equal expected, map
  end


  def test_parse_product_noslash
    map = UATokenizer.parse_product "Windows Phone OS 7.5"
    expected = {"windows"=>"7.5", "windows_phone"=>"7.5", "phone_os"=>"7.5"}
    assert_equal(expected, map)

    map = UATokenizer.parse_product " CPU OS 3_2_1 like Mac OS X"
    expected = {
      "cpu_os"   =>"3.2.1",
      "os_like"  =>"3.2.1",
      "like_mac" =>"3.2.1",
      "mac"      =>"3.2.1",
      "mac_os"   =>"3.2.1",
      "os_x"     =>"3.2.1"
    }
    assert_equal(expected, map)

    map = UATokenizer.parse_product "Windows 98"
    assert_equal({"windows" => true, "windows_98" => true}, map)

    map = UATokenizer.parse_product "Series40"
    assert_equal({"series"=>true, "series_40"=>true}, map)

    map = UATokenizer.parse_product "S60V5"
    assert_equal({"series_60"=>"v5"}, map)

    map = UATokenizer.parse_product "Android2.3.5"
    assert_equal({"android" => "2.3.5"}, map)
  end


  def test_parse_product_samsung
    map = UATokenizer.parse_product "sam-r360"
    assert_equal({"samsung"=>true, "samsung_r360"=>true, "r360"=>true}, map)

    map = UATokenizer.parse_product "sam375"
    assert_equal({"samsung"=>true, "samsung_375"=>true}, map)
  end


  def test_parse_product_series40_j2me
    map = UATokenizer.parse_product "S40OviBrowser/2.0.2.68.14"
    expected = {
      "series_40"=>"2.0.2.68.14",
      "series_40_ovi"=>"2.0.2.68.14",
      "ovi"=>"2.0.2.68.14",
      "ovi_browser"=>"2.0.2.68.14"
    }

    assert_equal expected, map
  end


  def test_split
    arr = UATokenizer.split "sam375/1.0[TF268435460214674193000000014783318126]\
 UP.Browser/6.2.3.8 (GUI) MMP/2.0 Profile/MIDP-2.0 Configuration/CLDC-1.1"

    expected = %w{sam375/1.0 TF268435460214674193000000014783318126
      UP.Browser/6.2.3.8 GUI MMP/2.0 Profile/MIDP-2.0 Configuration/CLDC-1.1}

    assert_equal expected, arr
  end


  def test_split_no_spaces
    ua = "T24 WIFI Duo/MTKRelease/2011/07/01Browser/MAUIProfile/MIDP-2.0\
Configuration/CLDC-1.0"
    arr = UATokenizer.split ua

    expected = %w{T24\ WIFI\ Duo/MTK Release/2011/07/01 Browser/MAUI
      Profile/MIDP-2.0 Configuration/CLDC-1.0}

    assert_equal expected, arr
  end


  def test_split_bad_spaces
    ua = "HTC_Touch_HD_T8282 Mozilla/4.0 (compatible; MSIE 4.01; Windows CE;\
 PPC)/UC Browser7.8.0.95/31/352"
    arr = UATokenizer.split ua

    expected = %w{HTC_Touch_HD_T8282\ Mozilla/4.0 compatible MSIE\ 4.01
      Windows\ CE PPC UC\ Browser7.8.0.95/31/352}

    assert_equal expected, arr
  end



  def test_split_JUC
    ua = "JUC(Linux;U;Android2.3.5;Zh_cn;HTC Desire HD A9191;480*800;)\
UCWEB7.8.0.95/139/355"
    arr = UATokenizer.split ua

    expected = %w{JUC Linux U Android2.3.5 Zh_cn HTC\ Desire\ HD\ A9191
      480*800 UCWEB7.8.0.95/139/355}
    assert_equal expected, arr
  end


  def test_split_w_screen
    arr = UATokenizer.split "Opera/9.5 (Microsoft Windows; Windows CE; \
Opera Mobi/9.5; U; en) Samsung-SCHI910 PPC 240x400"

    expected = %w{Opera/9.5 Microsoft\ Windows Windows\ CE Opera\ Mobi/9.5 U en
      Samsung-SCHI910\ PPC 240x400}

    assert_equal expected, arr
  end


  def test_split_opera_mobile
    arr = UATokenizer.split \
            "Opera/8.01 (J2ME/MIDP; Opera Mini/3.1.9427/1724; es; U; ssr)"

    expected = %w{Opera/8.01 J2ME/MIDP Opera\ Mini/3.1.9427/1724 es U ssr}

    assert_equal expected, arr
  end


  def test_split_twitter_android
    arr = UATokenizer.split "TwitterAndroid/3.3.1 (169) HTC Sensation Z710e/15\
 (HTC;pyramid;vodafone_uk;htc_pyramid;1)"

    expected = %w{TwitterAndroid/3.3.1 169 HTC\ Sensation\ Z710e/15 HTC pyramid
      vodafone_uk htc_pyramid 1}

    assert_equal expected, arr
  end


  def test_split_nosplit
    arr = UATokenizer.split "WebWatcher1.35"
    assert_equal ["WebWatcher1.35"], arr

    arr = UATokenizer.split "T58 WAP Browser"
    assert_equal ["T58", "WAP Browser"], arr
  end


  def test_parse_samsung_dolfin
    ua = "Mozilla/5.0 (SAMSUNG; SAMSUNG-GT-S7250D/S7250DXXKK1; U; Bada/2.0; ru-ru) \
AppleWebKit/534.20 (KHTML, like Gecko) Dolfin/3.0 Mobile HVGA SMM-MMS/1.2.0 OPN-B"

    tokens = UATokenizer.parse ua

    assert_equal "U",     tokens.security
    assert_equal "ru-ru", tokens.localization
    assert_nil   tokens.screen

    assert_equal "5.0",         tokens[:mozilla]
    assert_equal "2.0",         tokens["bada"]
    assert_equal "2.0",         tokens[:bada]

    assert_equal "534.20",      tokens[:apple]
    assert_equal "534.20",      tokens[:webkit]
    assert_equal "534.20",      tokens[:apple_webkit]

    assert_equal true,          tokens[:khtml]
    assert_equal true,          tokens[:like_gecko]
    assert_equal true,          tokens[:gecko]

    assert_equal "s7250dxxkk1", tokens[:samsung]
    assert_equal "s7250dxxkk1", tokens[:GT_S7250D]
  end


  def test_parse_samsung_opera_w_screen
    ua = "Opera/9.5 (Microsoft Windows; Windows CE; Opera Mobi/9.5; U; en) \
480x800 SAMSUNG SCH-i920 PPC"

    tokens = UATokenizer.parse ua

    assert_equal "U",        tokens.security
    assert_equal "en",       tokens.localization
    assert_equal [480, 800], tokens.screen
  end


  def test_parse_htc_desire_juc
    ua = "JUC(Linux;U;Android2.3.5;Zh_cn;HTC Desire HD A9191;480*800;)\
UCWEB7.8.0.95/139/355"

    tokens = UATokenizer.parse ua

    assert_equal "U",        tokens.security
    assert_equal "zh-cn",    tokens.localization
    assert_equal [480, 800], tokens.screen

    assert_equal "2.3.5", tokens[:android]
    assert tokens.has?(:android, ">=2.3.5")

    assert tokens.has?(:ucweb, "7.8.0.95")

    assert_equal true, tokens[:htc]
    assert_equal true, tokens[:htc_desire]
    assert_equal true, tokens[:desire]
    assert_equal true, tokens[:hd_a9191]
    assert_equal true, tokens[:linux]
  end


  def test_parse_series60_uc
    ua = "Mozilla/5.0 (S60V5; U; Pt-br; Nokia5233)/UC Browser8.2.0.132/50/355/\
UCWEB Mobile"

    tokens = UATokenizer.parse ua

    assert_equal "5.0",       tokens[:mozilla]
    assert_equal "v5",        tokens[:series_60]
    assert_equal "8.2.0.132", tokens[:uc_browser]
    assert_equal true,        tokens[:nokia]
    assert_equal true,        tokens[:nokia_5233]
  end


  def test_parse_series40_j2me
    ua = "Mozilla/5.0 (Series40; NokiaC3-00/03.35; Profile/MIDP-2.1 \
Configuration/CLDC-1.1) Gecko/20100401 S40OviBrowser/2.0.2.68.14"

    tokens = UATokenizer.parse ua
    assert_equal "cldc-1.1", tokens[:configuration]
    assert_equal "03.35",    tokens[:nokia]
    assert_equal "03.35",    tokens[:nokia_c3]

    assert_equal "2.0.2.68.14", tokens[:series_40]
    assert_equal "2.0.2.68.14", tokens[:ovi_browser]

    assert_equal "2010.04.01", tokens[:gecko]
  end


  def test_parse_lg
    ua = "Mozilla/5.0 (X11; Linux i686; U; en-US) Gecko/20081217 \
 Vision-Browser/8.1 301x200 LG VN530"

    tokens = UATokenizer.parse ua

    assert_equal [301, 200],   tokens.screen
    assert_equal "en-us",      tokens.localization
    assert_equal "U",          tokens.security

    assert_equal true,         tokens[:lg]
    assert_equal true,         tokens[:lg_vn530]
    assert_equal "2008.12.17", tokens[:gecko]
  end


  def test_parse_webos
    ua = "Mozilla/5.0 (webOS/1.4.5; U; en-US) AppleWebKit/532.2 \
(KHTML, like Gecko) Version/1.0 Safari/532.2 Pre/1.0"

    tokens = UATokenizer.parse ua

    assert_equal "en-us", tokens.localization
    assert_equal "U",     tokens.security

    assert_equal "1.4.5", tokens[:web_os]
    assert_equal "532.2", tokens[:Safari]
    assert_equal "1.0",   tokens[:pre]
    assert_equal "532.2", tokens[:apple]
    assert_equal "532.2", tokens[:apple_webkit]
    assert_equal "532.2", tokens[:webkit]
  end


  def test_parse_blackberry
    ua = "BlackBerry9550/5.0.0.550 Profile/MIDP-2.1 \
Configuration/CLDC-1.1 VendorID/303"

    tokens = UATokenizer.parse ua

    assert_equal "5.0.0.550", tokens[:blackberry]
    assert_equal "5.0.0.550", tokens[:blackberry_9550]
    assert_equal "303",       tokens[:vendor_id]
  end


  def test_parse_cricket
    ua = "Cricket-A310/1.0 UP.Browser/6.3.0.7 (GUI) MMP/2.0"
    tokens = UATokenizer.parse ua

    assert_equal "1.0", tokens[:cricket]
    assert_equal "1.0", tokens[:cricket_a310]
    assert_equal "1.0", tokens[:a310]
    assert_equal "6.3.0.7", tokens[:up_browser]
  end


  def test_parse_infopath2
    ua = "Nokia5300/2.0 (07.20) Profile/MIDP-2.0 Configuration/CLDC-1.1 \
Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2;.NET \
CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; \
InfoPath.2) UCBrowser8.4.0.159/69/352 UNTRUSTED/1.0"

    tokens = UATokenizer.parse ua

    expected = {
      "nokia"=>"2.0",
      "nokia_5300"=>"2.0",
      "profile"=>"midp-2.0",
      "midp"=>"2.0",
      "configuration"=>"cldc-1.1",
      "mozilla"=>"4.0",
      "compatible"=>true,
      "cldc"=>"1.1",
      "msie"=>"8.0",
      "windows"=>"6.1",
      "windows_nt"=>"6.1",
      "nt"=>"6.1",
      "trident"=>"4.0",
      "slcc2"=>true,
      ".net"=>"3.5.30729",
      ".net_clr"=>"3.5.30729",
      "clr"=>"3.5.30729",
      "media"=>"6.0",
      "media_center"=>"6.0",
      "center"=>"6.0",
      "center_pc"=>"6.0",
      "pc"=>"6.0",
      "infopath"=>"2",
      "uc"=>"8.4.0.159",
      "uc_browser"=>"8.4.0.159",
      "untrusted"=>"1.0"
    }

    assert_equal expected, tokens.instance_variable_get("@tokens")
  end


  def test_astro36_opera
    ua = "ASTRO36_TD/v3 MAUI/10A1032MP_ASTRO_W1052 Release/31.12.2010 \
Browser/Opera Profile/MIDP-2.0 Configuration/CLDC-1.1 Sync/SyncClient1.1 \
Opera/9.80 (MTK; Nucleus; Opera Mobi/4000; U; en-US) Presto/2.5.28 \
Version/10.10"

    tokens = UATokenizer.parse ua

    assert_equal "v3", tokens[:astro_36]
    assert_equal "v3", tokens[:td]

    assert_equal "10a1032mp_astro_w1052", tokens[:MAUI]

    assert_equal "9.80",   tokens[:opera]
    assert_equal "4000",   tokens[:opera_mobi]
    assert_equal "2.5.28", tokens[:presto]
  end


  def test_hd_mini_msie
    ua = "HD_mini_T5555 Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; \
IEMobile 8.12; MSIEMobile 6.5)"

    tokens = UATokenizer.parse ua

    assert_equal true,   tokens[:hd_mini]
    assert_equal true,   tokens[:t5555]
    assert_equal "8.12", tokens[:ie]
    assert_equal "8.12", tokens[:ie_mobile]
    assert_equal "6.5",  tokens[:msie]
    assert_equal "6.5",  tokens[:msie_mobile]
  end


  def test_parse_hp_ipaq
    ua = "HPiPAQrw6815/1.0 Mozilla/4.0 (compatible; MSIE 4.01; Windows CE; PPC;
240x320)"

    tokens = UATokenizer.parse ua

    expected = {
      "hp"=>"1.0",
      "hp_ipaq"=>"1.0",
      "ipaq"=>"1.0",
      "ipaq_rw6815"=>"1.0",
      "rw6815"=>"1.0",
      "mozilla"=>"4.0",
      "compatible"=>true,
      "msie"=>"4.01",
      "windows"=>true,
      "windows_ce"=>true,
      "ce"=>true,
      "ppc"=>true
    }

    assert_equal expected, tokens.instance_variable_get("@tokens")
  end


  def test_parse_dot_separated_words
    ua = "MOT-A953/Blur_Version.3.18.3.A953.AmericaMovil.en.MX Mozilla/5.0 \
(Linux; U; Android 2.2.1; es-us; A953 Build/MILA2_U6_3.18.3) AppleWebKit/533.1 \
(KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"

    tokens = UATokenizer.parse ua

    assert_equal "3.18.3", tokens[:blur_version]
    assert_equal "3.18.3", tokens[:America_Movil]
    assert_equal "3.18.3", tokens[:A953]
    assert_equal "3.18.3", tokens[:mila2]
    assert_equal "3.18.3", tokens[:mila2_u6]
    assert_equal "3.18.3", tokens[:u6]

    assert_equal "U",     tokens.security
    assert_equal "es-us", tokens.localization
  end


  def test_parse_blackberry_mozilla
    ua = "Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en-GB) \
AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.0.0.503 Mobile Safari/534.11+"

    tokens = UATokenizer.parse ua

    assert_equal "en-gb", tokens.localization
    assert_equal "U",     tokens.security

    assert_equal true,     tokens[:blackberry]
    assert_equal true,     tokens[:blackberry_9900]
    assert_equal "534.11", tokens[:WebKit]
  end


  def test_parse_wt19i
    ua = "Mozilla/5.0 (Linux; U; Android 2.3.4; en-in; \
SonyEricssonWT19i Build/4.0.2.A.0.58) AppleWebKit/533.1 (KHTML, like Gecko) \
Version/4.0 Mobile Safari/533.1"

    tokens = UATokenizer.parse ua

    assert_equal "en-in", tokens.localization
    assert_equal "4.0.2.a.0.58", tokens[:wt19i]
    assert_equal "4.0.2.a.0.58", tokens[:sony_ericsson]
  end


  def test_token_has_true
    ua = "Mozilla/5.0 (S60V5; U; Pt-br; Nokia5233)/UC Browser8.2.0.132/50/355/\
UCWEB Mobile"

    tokens = UATokenizer.parse ua

    assert_equal true, tokens.has?(:mozilla)
    assert_equal true, tokens.has?(:mozilla, "5.0")
    assert_equal true, tokens.has?(:mozilla, "= 5.0")
    assert_equal true, tokens.has?(:mozilla, "==5.0")
    assert_equal true, tokens.has?(:mozilla, ">=5.0")
    assert_equal true, tokens.has?(:mozilla, "<=5.0")
    assert_equal true, tokens.has?(:mozilla, "<=6.0")
    assert_equal true, tokens.has?(:mozilla, "<6.0")
    assert_equal true, tokens.has?(:mozilla, ">4.9")
    assert_equal true, tokens.has?(:uc_browser, ">8.2.0")
    assert_equal true, tokens.has?(:uc_browser, "~>8.1")
    assert_equal true, tokens.has?(:uc_browser, "~>7")
    assert_equal true, tokens.has?(:uc_browser, "~>8.2.0.100")
  end


  def test_token_has_false
    ua = "Mozilla/5.0 (S60V5; U; Pt-br; Nokia5233)/UC Browser8.2.0.132/50/355/\
UCWEB Mobile"

    tokens = UATokenizer.parse ua

    assert_equal false, tokens.has?(:safari)
    assert_equal false, tokens.has?(:mozilla, "4.0")
    assert_equal false, tokens.has?(:mozilla, "= 4.0")
    assert_equal false, tokens.has?(:mozilla, "==4.0")
    assert_equal false, tokens.has?(:mozilla, "<=4.0")
    assert_equal false, tokens.has?(:mozilla, ">5.9")
    assert_equal false, tokens.has?(:uc_browser, "~>8.2.0.133")
    assert_equal false, tokens.has?(:uc_browser, "~>7.1")
    assert_equal false, tokens.has?(:uc_browser, "~>9")
  end


  def test_token_has_no_version
    ua = "Mozilla/5.0 (S60V5; U; Pt-br; Nokia5233)/UC Browser8.2.0.132/50/355/\
UCWEB Mobile"

    tokens = UATokenizer.parse ua
    assert_equal true,  tokens.has?(:nokia)
    assert_equal false, tokens.has?(:nokia, ">=0")
  end
end
