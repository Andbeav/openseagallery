require 'rack'
require 'uri'
require 'net/http'
require 'singleton'
require 'openssl'
require 'json'
require_relative 'gallery'

# Rather save than sorry. If not set will default to production and disable in-browser error messages
ENV['RACK_ENV'] ||= 'production'

# Minimal wrapper for future api requests
class OpenSeaWrapper
  include Singleton

  # Get assets by owner address
  def request_assets_for_owner(owner_address, limit = 1, offset = 0)
    uri = URI("https://api.opensea.io/api/v1/assets?owner=#{owner_address}&order_direction=desc&offset=#{offset}&limit=#{limit}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    response = http.request(request)
    JSON.parse(response.read_body)
  end
end

app = Rack::Builder.app do
  run lambda { |env|
    # Assume path is owner address if path is not root
    if env['PATH_INFO'] != '/'
      image_urls = []
      OpenSeaWrapper.instance.request_assets_for_owner(env['PATH_INFO'][0]='')['assets'].each { |asset|
        image_urls.append(asset['image_url'])
      }

      # ERB templating
      images = image_urls.select {|i| ![nil, ''].include?(i)}
      gallery = Gallery.new('gallery.html.erb', images)

      return [200, {'Content-Type' => 'text/html'}, [gallery.html]]
    end

    [200, {'Content-Type' => 'text/plain'}, ['Usage: /<owner_address>']]
  }
end

run app
