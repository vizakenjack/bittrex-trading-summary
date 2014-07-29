require 'openssl'
require 'rest_client'
require 'pry'
require 'json'

class Bittrex
  DEFAULT_MARKET = "BTC-"

  def initialize(key, secret)
    @api_key = key
    @api_secret = secret
  end

  def generate_sign
    nonce = Time.now.to_i
    url = "#{url}?apikey=#{@api_key}&nonce=#{nonce}&"+params
    sign = OpenSSL::HMAC.hexdigest(digest = OpenSSL::Digest.new('sha512'), @api_secret, url)
    response = JSON.parse(RestClient.get(url, {'apisign' => sign}))
  end

  def request(url, params = '')
    begin
      nonce = Time.now.to_i
      url = "#{url}?apikey=#{@api_key}&nonce=#{nonce}&"+params
      sign = OpenSSL::HMAC.hexdigest(digest = OpenSSL::Digest.new('sha512'), @api_secret, url)
      response = JSON.parse(RestClient.get(url, {'apisign' => sign}))
      if response['success']
        response['result']
      else
        puts "Request failed: #{response}"
        return response['message']
      end
    rescue
      return false
    end
  end

  def ticker(market)
    request("https://bittrex.com/api/v1.1/public/getticker", "market=#{DEFAULT_MARKET}#{market}")
  end

  def summaries
    request("https://bittrex.com/api/v1.1/public/getmarketsummaries")
  end

  def orderbook(market, type, depth = 50)
    request("https://bittrex.com/api/v1.1/public/getorderbook", "market=#{DEFAULT_MARKET}#{market}&type=#{type}&depth=#{depth}")
  end 

  def market_history(market, count = 10)
    request("https://bittrex.com/api/v1.1/public/getmarkethistory", "market=#{DEFAULT_MARKET}#{market}&count=#{count}")
  end


  def buy(market, quantity, rate = nil)
    if rate
      request("https://bittrex.com/api/v1.1/market/buylimit", "market=#{DEFAULT_MARKET}#{market}&quantity=#{quantity}&rate=#{rate}")
    else
      request("https://bittrex.com/api/v1.1/market/buymarket", "market=#{DEFAULT_MARKET}#{market}&quantity=#{quantity}")
    end
  end

  def sell(market, quantity, rate = nil)
    if rate
      request("https://bittrex.com/api/v1.1/market/selllimit", "market=#{DEFAULT_MARKET}#{market}&quantity=#{quantity}&rate=#{rate}")
    else
      request("https://bittrex.com/api/v1.1/market/sellmarket", "market=#{DEFAULT_MARKET}#{market}&quantity=#{quantity}")
    end
  end

  def cancel(order_id)
    request("https://bittrex.com/api/v1.1/market/cancel", "uuid=#{order_id}")
  end

  def open_orders(market = '')
    request("https://bittrex.com/api/v1.1/market/getopenorders", "market=#{DEFAULT_MARKET}#{market}")
  end

  def balance(currency)
    request("https://bittrex.com/api/v1.1/account/getbalance", "currency=#{currency}")
  end

  def order_history(market = nil, count = 5)
    params = market ? "market=#{DEFAULT_MARKET}#{market}&count=#{count}" : "count=#{count}"
    request("https://bittrex.com/api/v1.1/account/getorderhistory", params)
  end

  def find_order(order_id, market = '')
    if orders = open_orders
      orders.find { |e| e['OrderUuid'] == order_id }
    end
  end

end
