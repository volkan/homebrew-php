require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Memcached < AbstractPhp54Extension
  init
  homepage 'http://pecl.php.net/package/memcached'
  url 'http://pecl.php.net/get/memcached-2.0.1.tgz'
  sha1 '5442250bf4a9754534bce9a3033dc5363d8238f7'
  head 'https://github.com/php-memcached-dev/php-memcached.git'

  depends_on 'libmemcached'

  if ARGV.include? '--with-igbinary'
      depends_on 'php54-igbinary'
      puts "if get any error, you should run 'pecl install igbinary'"
  end

  def options
   [
     ['--with-igbinary', 'Include igbinary support'],     
   ]
  end

  def configure_args
    args = [
      "--prefix=#{prefix}",        
      phpconfig,
      "--with-libmemcached-dir=#{Formula.factory('libmemcached').prefix}"    
    ]

    # Enable igbinary
    if ARGV.include? '--with-igbinary'
      args.push "--enable-memcached-igbinary"
    end

    return args
  end    

  def install
    Dir.chdir "memcached-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", *configure_args
    system "make"
    prefix.install "modules/memcached.so"
    write_config_file unless build.include? "without-config-file"
  end
end