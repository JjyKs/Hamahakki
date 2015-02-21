require 'mechanize'
require 'timeout'
require 'json'
require_relative 'httpagent'
require_relative 'widget_finder'
require 'net/http'


@agent = Mechanize.new


def time_diff_milli(start, finish)
  (finish - start) * 1000.0
end

def threadedLinkFollower (link , page)
  source = ''
  threadAgent = Mechanize.new


  subPage = @agent.click(link)
  if page.uri.host.equal? subPage.uri.host

    source = subPage.body

    @agent.back
    Thread.current[:output] = source
  else
    Thread.current[:output] = ' '
  end
end

def timeOutPart (timeout, url, site)


  Timeout::timeout(timeout) {
    address = 'http://' + url.gsub("\n",'')
    t1 = Time.now
    page = @agent.get(address)
    source = page.body
    t2 = Time.now
    responseTime = time_diff_milli t1, t2

    begin
      t1 = Time.now
      threadit = []
      page.links.each do |link|
        break if t1 + 0.10 < Time.now
        threadit.push(Thread.new{threadedLinkFollower(link, page)})
      end

      threadit.each do |t|
        t.join(timeout - 3)
        source = source + t[:output]
      end

    rescue Mechanize::UnsupportedSchemeError
    rescue Net::HTTP::Persistent::Error
    rescue URI::InvalidComponentError
    rescue

    end

    begin
      page = @agent.head address
      server_version = page.header['server']
      if page.header.key? 'x-powered-by'
        framework_version = page.header['x-powered-by']
      end
    rescue Exception
    end

    wf = WidgetFinder.new(source)
    arr = wf.has_widgets


    site["datapoint"]["domain"] = address
    site["datapoint"]["responsetime"] = responseTime
    site["datapoint"]["server"] = server_version
    site["datapoint"]["framework"] = framework_version
    site["datapoint"]["widgets"] = arr
  }

end



@lock = true
def scrapeSites (fileName)
  File.open( "./data/" + fileName ).each do |line|

    site = Hash.new
    site["datapoint"] = Hash.new
    begin
      timeOutPart(13, line, site)
      hasKey = site["datapoint"].has_key?("framework")
      unless site["datapoint"]["widgets"].nil? && !hasKey
          puts 'write'
          browser = Mechanize.new
          browser.post 'https://kaivaja32.herokuapp.com/datapoints', site.to_json, {'Content-Type' => 'application/json'}
      end

    rescue SocketError => se
    rescue  Mechanize::ResponseCodeError
    rescue Timeout::Error => se
    rescue
    end

  end
end

threads = []
Dir.foreach('./data') do |item|
  next if item == '.' or item == '..'
  threads.push Thread.new{scrapeSites(item)}

end


threads.each do |t|
  t.join()

end
