require "test/unit"
require "ua_tokenizer"

class TestUaTokenizer < Test::Unit::TestCase
  def test_tokenize_4part_upper
    tokens = UATokenizer.tokenize("SAMSUNG-GT-S5620-ORANGE")
    expected = ["samsung", "samsung_gt", "gt", "gt_s5620", "s5620",
                "s5620_orange", "orange"]
    assert_equal expected, tokens
  end


  def test_tokenize_3part_camel
    tokens = UATokenizer.tokenize("SonyEricssonCK15i")
    expected = ["sony", "sony_ericsson", "ericsson", "ericsson_ck15i", "ck15i"]
    assert_equal expected, tokens
  end


  def test_tokenize_2part_dash
    tokens = UATokenizer.tokenize("gt-s5230")
    assert_equal ["gt", "gt_s5230", "s5230"], tokens
  end


  def test_tokenize_idevice
    tokens = UATokenizer.tokenize("iPhone")
    assert_equal ["iphone"], tokens

    tokens = UATokenizer.tokenize("Apple iPad")
    assert_equal ["apple", "apple_ipad", "ipad"], tokens

    tokens = UATokenizer.tokenize("CPU iPhone OS 5_1 like Mac OS X")
    expected = ["cpu", "cpu_iphone", "iphone", "iphone_os", "os", "5.1",
                "like", "like_mac", "mac", "mac_os", "os", "os_x", "x"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("FBForIPhone")
    assert_equal ["fb", "fb_iphone", "iphone"], tokens

    tokens = UATokenizer.tokenize("CriOS")
    assert_equal ["crios"], tokens
  end


  def test_tokenize_windows
    tokens = UATokenizer.tokenize("Windows NT 5.1")
    assert_equal ["windows", "windows_nt", "nt", "5.1"], tokens

    tokens = UATokenizer.tokenize("Windows Phone OS 7.5")
    expected = ["windows", "windows_phone", "phone", "phone_os", "os", "7.5"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("IEMobile")
    assert_equal ["ie", "ie_mobile", "mobile"], tokens

    tokens = UATokenizer.tokenize("IEMobile 7.11")
    assert_equal ["ie", "ie_mobile", "mobile", "7.11"], tokens

    tokens = UATokenizer.tokenize("Win98")
    assert_equal ["win98"], tokens

    tokens = UATokenizer.tokenize("MSIE 6.0")
    assert_equal ["msie", "6.0"], tokens
  end


  def test_tokenize_4part_spaces
    tokens = UATokenizer.tokenize("HTC Desire HD A9191")
    expected =
      ["htc", "htc_desire", "desire", "desire_hd", "hd", "hd_a9191", "a9191"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("HTC_Touch_HD_T8282")
    expected =
      ["htc", "htc_touch", "touch", "touch_hd", "hd", "hd_t8282", "t8282"]
    assert_equal expected, tokens
  end


  def test_tokenize_3part_dashed
    tokens = UATokenizer.tokenize("ZTE-Sydney-Orange")
    expected = ["zte", "zte_sydney", "sydney", "sydney_orange", "orange"]
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
    assert_equal ["meego", "meego_nokia", "nokia", "nokia_n9", "n9"], tokens
  end


  def test_tokenize_ambiguous_scrunched_names
    tokens = UATokenizer.tokenize("HPiPAQ910")
    assert_equal ["hp", "hp_ipaq", "ipaq", "ipaq_910", "910"], tokens

    tokens = UATokenizer.tokenize("HuaweiU3100")
    assert_equal ["huawei", "huawei_u3100", "u3100"], tokens

    tokens = UATokenizer.tokenize("EFS-EE-ORG-P107A20V1.0.5")
    expected = ["efs", "efs_ee", "ee", "ee_org", "org", "org_p107", "p107",
                "p107_a20", "a20", "v1.0.5"]
    assert_equal expected, tokens

    tokens = UATokenizer.tokenize("DoCoMo")
    assert_equal ["docomo"], tokens
  end


  def test_tokenize_twitter_android
    tokens = UATokenizer.tokenize("TwitterAndroid")
    assert_equal ["twitter", "twitter_android", "android"], tokens
  end


  def test_tokenize_special_browser
    tokens = UATokenizer.tokenize("UP.Browser")
    assert_equal ["up_browser"], tokens

    tokens = UATokenizer.tokenize("NetFront")
    assert_equal ["netfront"], tokens

    tokens = UATokenizer.tokenize("UC Browser7.7.1.88")
    assert_equal ["uc", "uc_browser", "browser", "7.7.1.88"], tokens

    tokens = UATokenizer.tokenize("WAP-Browser")
    assert_equal ["wap", "wap_browser", "browser"], tokens

    tokens = UATokenizer.tokenize("TelecaBrowser")
    assert_equal ["teleca", "teleca_browser", "browser"], tokens
  end


  def test_tokenize_series_60
    tokens = UATokenizer.tokenize("S60V5")
    assert_equal ["s60", "v5"], tokens

    tokens = UATokenizer.tokenize("S60V5") do |t|
      t == "s60" ? "series_60" : t
    end
    assert_equal ["series_60", "v5"], tokens

    tokens = UATokenizer.tokenize("Series60")
    assert_equal ["series", "series_60", "60"], tokens
  end


  def test_tokenize_lg
    tokens = UATokenizer.tokenize("LG-KU990i")
    assert_equal ["lg", "lg_ku990i", "ku990i"], tokens

    tokens = UATokenizer.tokenize("LGC300")
    assert_equal ["lg", "lg_c300", "c300"], tokens

    tokens = UATokenizer.tokenize("LGPlayer")
    assert_equal ["lg", "lg_player", "player"], tokens
  end


  def tokenize_nintendo
    tokens = UATokenizer.tokenize("Nintendo DSi")
    assert_equal ["nintendo", "dsi"], tokens
  end


  def test_tokenize_webkit
    tokens = UATokenizer.tokenize("WebKit")
    assert_equal ["webkit"], tokens

    tokens = UATokenizer.tokenize("AppleWebKit")
    assert_equal ["apple", "apple_webkit", "webkit"], tokens
  end


  def test_tokenize_blackberry
    tokens = UATokenizer.tokenize("BlackBerry")
    assert_equal ["black", "black_berry", "berry"], tokens

    tokens = UATokenizer.tokenize("BlackBerry9550")
    assert_equal ["black", "black_berry", "berry", "berry_9550", "9550"], tokens

    tokens = UATokenizer.tokenize("BlackBerry9550") do |t|
      t = "blackberry" if t == "black_berry"
      t = nil if t == "berry" || t == "black"
      t
    end
    assert_equal ["blackberry", "blackberry_9550", "9550"], tokens
  end


  def test_tokenize_webos
    tokens = UATokenizer.tokenize("webOS")
    assert_equal ["web", "web_os", "os"], tokens
  end


  def test_tokenize_symbian
    tokens = UATokenizer.tokenize("SymbianOS")
    assert_equal ["symbian", "symbian_os", "os"], tokens

    tokens = UATokenizer.tokenize("SymbOS")
    assert_equal ["symb", "symb_os", "os"], tokens

    tokens = UATokenizer.tokenize("SymbOS") do |t|
      t == "symb" ? "symbian" : t
    end
    assert_equal ["symbian", "symbian_os", "os"], tokens
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
      "ck15i"          =>"r3ac020"
    }
    assert_equal expected, map

    map = UATokenizer.parse_product "Nokia201/11.21"
    expected = {"nokia" => "11.21", "nokia_201" => "11.21"}
    assert_equal expected, map

    map = UATokenizer.parse_product "Treo800w/v0100"
    expected = {"treo" => "v0100", "treo_800w" => "v0100", "800w" => "v0100"}
    assert_equal expected, map

    map = UATokenizer.parse_product "PalmSource/Palm-D061"
    expected =
      {"palm"=>"palm-d061", "source"=>"palm-d061", "palm_source"=>"palm-d061"}
    assert_equal expected, map
  end


  def test_parse_product_3part
    map = UATokenizer.parse_product "POLARIS/6.01/AMB"
    assert_equal({"polaris"=>"6.01"}, map)

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
      "ku990i"    =>"v10c"
    }
    assert_equal(expected, map)
  end


  def test_parse_product_noslash
    map = UATokenizer.parse_product "Windows Phone OS 7.5"
    expected = {"windows"=>"7.5", "windows_phone"=>"7.5", "phone_os"=>"7.5"}
    assert_equal(expected, map)

    map = UATokenizer.parse_product " CPU OS 3_2_1 like Mac OS X"
    expected = {
      "cpu_os"   =>"3.2.1",
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


  #TODO: figure out how to parse this
  def _test_parse_product_nospace
    map = UATokenizer.parse_product "Duo/MTKRelease/2011/07/01Browser/MAUIProfile/MIDP-2.0Configuration/CLDC-1.0"
    assert_equal({}, map)
  end
end
