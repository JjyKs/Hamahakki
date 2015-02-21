require 'mechanize'
require 'timeout'
require 'logger'
require 'net/http'



agent = Mechanize.new
File.open( 'us.txt' ).each do |line|
  begin
    t1 = Time.now
    Timeout::timeout(7) {

    page = agent.get('http://' + line.gsub("\n",''))
    source = page.body
    if (source.include? "turbolinks")
      p 'Widget: Turbolinks'
    end
    t2 = Time.now
    msecs = time_diff_milli t1, t2
    puts 'Response time ' + msecs.to_s


    page = agent.head 'http://' + line.gsub("\n",'')
    server_version = page.header['server']
    puts "Server: #{server_version}"
    if page.header.key? 'x-powered-by'
      php_version = page.header['x-powered-by']
      puts "Powered by: #{php_version}"
    end
    if page.header.key? 'content-language'
      puts "Language: " + page.header["content-language"]
    end

  # redirection urls:
    agent.redirect_ok = false
    page = agent.get 'http://' + line.gsub("\n",'')
    p line
    puts page.header['location']
    }
    puts '------------------------'
  rescue SocketError => se
    puts ' '
  rescue  Mechanize::ResponseCodeError

    puts ' '
  rescue Timeout::Error => se
    puts 'Timeout'
    puts ' '
  end

  end


