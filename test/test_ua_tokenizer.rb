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
end
