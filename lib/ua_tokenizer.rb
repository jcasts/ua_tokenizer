class UATokenizer
  VERSION = '1.0.0'

  TOKEN_MAPS = {
    'black_berry' => 'blackberry',
    'crios'       => 'chrome',
    'fb'          => 'facebook',
    'lge'         => 'lg',
    'mot'         => 'motorolla',
    's40'         => 'series_40',
    's60'         => 'series_60',
    'sam'         => 'samsung',
    'symb'        => 'symbian',
  }

  COMMON_TOKENS = %w{
    mobile browser os cpu x like web phone like for
  }

  MAX_TOKEN_LENGTH = 25

  VERSION_MATCH = /^(v?(\d+\.)+\d+|v\d+)$/i

  TOKEN_MATCHERS = {
    :camel0  => /([A-Z\d])[Ff]or([A-Z]+[a-z]+)/,
    :camel1  => /([A-Z]\d+)([A-Z][a-z])/,
    :camel2  => /(_[A-Z][a-z]+)([A-Z][a-z])/,
    :camel3  => /([a-z]{3,})([\dA-Z])/,
    :camel4  => /([A-Z]{2,})([a-z]{1,2}[^a-z]|[A-Z][a-z]{2,}|[A-Z][0-9]{2,})/,
    :suffix  => /(\d)([a-zA-Z]+\d)/,
    :nprefix => /([A-Z]{3,})(\d)/
  }

  SEC_MATCHER = /^([NUI])$/
  LAN_MATCHER = /^([a-z]{2})(?:[\-_]([a-z]{2,3}))?$/i
  SCR_MATCHER = /(\d{2,4}[xX*]\d{2,4})/

  DATE_MATCHER          = %r{(^|\D)(\d{4})/(\d{2})/(\d{2})(\D|$)}
  NOSPACE_MATCHER       = %r{\)/[a-zA-Z]|([^\s]+/){4,}}
  NOSPACE_DELIM_MATCHER = %r{([0-9A-Z])([A-Z][a-z])|\)/}
  UA_DELIM_MATCHER      = %r{(/(?:[^\s;])+|[\)\]])[\s;]+(\w)}
  UA_SPLIT_MATCHER      = /\s*[;()\[\],]+\s*/

  DEVICE_MATCHER = /(?:[a-z]([A-Z]{0,3})|[-_ ]([a-zA-Z]{0,3}))(\d+[a-z]{0,2})/


  ##
  # Parse the User-Agent String and return a UATokenizer instance.

  def self.parse ua
    data = {}
    meta = {}

    split(ua).each do |part|
      part.strip!

      case part
      when SCR_MATCHER
        meta[:screen] = part.split(/[\*xX]/, 2)
        next

      when LAN_MATCHER
        if !meta[:localization] || meta[:localization] && ($2 || $1.length < meta[:localization].length)
          meta[:localization] = ($2 ? "#{$1}-#{$2}" : $1).downcase
          next
        end

      when SEC_MATCHER
        meta[:security] = part
        next
      end

      data.merge! parse_product(part)
    end

    new data, meta
  end


  ##
  # Splits the User-Agent String into meaningful pieces.

  def self.split ua
    ua = ua.dup

    # Make YYYY/MM/DD into YYYY.MM.DD for easier parsing
    ua.gsub!(DATE_MATCHER, '\1\2.\3.\4\5')

    if ua =~ NOSPACE_MATCHER
      # Handle UAs without spaces. Split on 0|A HP|Compaq.
      ua.gsub!(NOSPACE_DELIM_MATCHER, '\1;\2')
    else
      # Add split markers to avoid needing to split on spaces.
      ua.gsub!(UA_DELIM_MATCHER, '\1;\2')
    end

    ua.sub!(SCR_MATCHER, ';\1;')

    ua.split(UA_SPLIT_MATCHER)
  end


  ##
  # Extracts a Product/Version pair from a given ProductToken.
  # Removes common tokens.
  #   UATokenizer.parse_product "Treo800w/v0100"
  #   #=> {"treo" => "v0100", "treo_800w" => "v0100", "800w" => "v0100"}
  #
  #   UATokenizer.parse_product "Vodafone/1.0/LG-KU990i/V10c"
  #   #=> {"vodafone" => "1.0", "lg" => "v10c", "lg_ku990i" => "v10c", "ku990i" => "v10c"}
  #
  #   UATokenizer.parse_product "Browser/Obigo-Q05A/3.6"
  #   #=> {"obigo" => "3.6", "obigo_q05a" => "3.6", "q05a" => "3.6"}

  def self.parse_product str
    parts = str.split("/")

    version     = nil
    tmp_version = nil

    out    = {}
    tokens = []

    parts.each_with_index do |part, i|
      last_of_many = parts.length > 1 && i+1 == parts.length

      if version && !last_of_many
        version &&= version.downcase
        tokens.each{|t| out[t] = version || out[t] || true }
        tokens  = []
        version = nil
      end

      tokenize(part) do |t|
        next if COMMON_TOKENS.include?(t)   ||
                t.length > MAX_TOKEN_LENGTH ||
                t =~ /^\d+$/

        t = TOKEN_MAPS[t] || t

        version = t and next if !version && t =~ VERSION_MATCH
        tokens << t

        t
      end unless last_of_many

      version = part and next if
        (!version && last_of_many) || part =~ VERSION_MATCH
    end

    version &&= version.downcase
    tokens.each{|t| out[t] = version || out[t] || true }

    out
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

    parts = str.downcase.split(/[_\s\-\/:;]/)
    tokens = []

    last = nil
    parts.each do |t|
      next unless t && !t.empty?
      t.gsub!(/([a-z])\W([a-z])/, '\1_\2')
      t1 = block_given? ? yield(t) : t

      if last && t !~ VERSION_MATCH && last !~ VERSION_MATCH
        last = last.split("_", 2).last
        nt = "#{last}_#{t1 || t}"
        nt = yield nt if block_given?
        tokens << nt if nt
      end

      last = t1 || nt || t
      tokens << t1 if t1
    end

    tokens
  end


  attr_accessor :localization, :security, :screen

  ##
  # Create a new UATokenizer instance from parsed User-Agent data.

  def initialize data, meta=nil
    meta        ||= {}
    @screen       = meta[:screen]
    @localization = meta[:localization]
    @security     = meta[:security]
    @tokens       = data
  end


  ##
  # Returns true-ish if the given key matches a User-Agent token.

  def [] key
    @tokens[key.to_s.downcase]
  end


  ##
  # Check if a given token is available with an optional version string.
  #   tokens.has?('mozilla', '>=5.0')

  def has? name, version=nil
    token_version = self[name]
    return !!token_version unless version
    return false           unless String === token_version

    op = '=='
    version = version.strip

    if version =~ /^([><=]=?)/
      op = $1
      version = version[op.length..-1].strip
    end

    op = '==' if op == '='

    token_version.send(op, version)
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
