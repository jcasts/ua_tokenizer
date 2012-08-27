class UATokenizer
  VERSION = '1.0.0'

  TOKEN_MAPS = {
    'black_berry' => 'blackberry',
    'lge'         => 'lg',
    's60'         => 'series_60',
    'sam'         => 'samsung',
    'symb'        => 'symbian',
  }

  COMMON_TOKENS = %w{
    version profile configuration mobile untrusted browser os
    cpu x like web phone like
  }

  VERSION_MATCH = /^(v?(\d+\.)+\d+|v\d+)$/

  TOKEN_MATCHERS = {
    :camel1  => /([a-z]{3,})([\dA-Z])/,
    :camel2  => /([A-Z]{2,})([a-z]{1,2}[^a-z]|[A-Z][a-z]{2,})/,
    :suffix  => /(\d)([a-zA-Z]+\d)/,
    :nprefix => /([A-Z]{3,})(\d)/
  }

  DEVICE_MATCHER = /(?:[a-z]([A-Z]{0,3})|[-_ ]([a-zA-Z]{0,3}))(\d+[a-z]{0,2})/


  ##
  # Parse the User-Agent String and return a UATokenizer instance.

  def self.parse ua
    
  end


  ##
  # Extracts a Product/Version pair from a given ProductToken.
  # Removes common tokens.
  #   UATokenizer.parse_product "Treo800w/v0100"
  #   #=> {["treo", "treo_800w", "800w"] => "v0100"}
  #
  #   UATokenizer.parse_product "Vodafone/1.0/LG-KU990i/V10c"
  #   #=> {["vodafone"] => "1.0", ["lg", "lg_ku990i", "ku990i"] => "v10c"}
  #
  #   UATokenizer.parse_product "Browser/Obigo-Q05A/3.6"
  #   #=> {["obigo", "obigo_q05a", "q05a"] => "3.6"}

  def self.parse_product str
    parts = str.split("/")
    
  end


  ##
  # Normalizes and splits the String in potentially meaningful ways
  # and returns a hash map of :token => str.
  #   UATokenizer.tokenize("SAMSUNG-GT-S5620-ORANGE")
  #   #=> ["samsung", "samsung_gt", "gt", "gt_s5620", "s5620", "s5620_orange", "orange"]
  #
  #   UATokenizer.tokenize("SonyEricssonCK15i")
  #   #=> ["sony", "sony_ericsson", "ericsson", "ericsson_ck15i", "ck15i"]
  #
  #   UATokenizer.tokenize("Nokia2700c")
  #   #=> ["nokia", "nokia_2700c", "2700c"]
  #
  #   UATokenizer.tokenize("iPhone")
  #   #=> ["iphone"]
  #
  #   UATokenizer.tokenize("HTC Desire HD A9191")
  #   #=> ["htc", "htc_desire", "desire", "desire_hd", "hd", "hd_a9191", "a9191"]
  #
  #   UATokenizer.tokenize("ZTE-Sydney-Orange")
  #   #=> ["zte", "zte_sydney", "sydney", "sydney_orange", "orange"]

  def self.tokenize str
    str = str.dup

    2.times{ str.gsub!(/(\d)_(\d)/, '\1.\2') } # serialize version
    TOKEN_MATCHERS.each{|k, regex| str.gsub!(regex, '\1_\2') }

    parts = str.downcase.split(/[_\s\-\/]/)
    tokens = []

    last = nil
    parts.each do |t|
      t.gsub!(/([a-z])\W([a-z])/, '\1_\2')
      t1 = block_given? ? yield(t) : t

      if last && last !~ VERSION_MATCH && t !~ VERSION_MATCH
        nt = "#{last}_#{t1 || t}"
        nt = yield nt if block_given?
        tokens << nt if nt
      end

      last = t1 || nt || t
      tokens << t1 if t1
    end

    tokens
  end


  ##
  # Create a new UATokenizer instance from parsed User-Agent data.

  def initialize data
    @tokens = data
  end


  ##
  # Returns true-ish if the given key matches a User-Agent token.

  def [] key
    @tokens[key]
  end


  ##
  # Returns true if all given keys match a token.

  def all?(*keys)
    !keys.any?{|k| !@tokens[k] }
  end


  ##
  # Returns true if any given key matches a token.

  def any?(*keys)
    keys.any?{|k| @tokens[k] }
  end
end
