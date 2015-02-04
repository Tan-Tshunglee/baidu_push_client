require 'virtus'
require 'faraday'
require 'json'
module BaiduPushClient
  DEVICE_TYPE = {
    browser: 1,
    pc: 2,
    android: 3,
    ios: 4,
    window_phone: 5
  }
  PUSH_TYPE = {
    user: 1,
    group: 2,
    all: 3
  }
  MESSAGE_TYPE ={
    message: 0,
    notification: 1

  }

  DEFAULT_IOS_MSG = {
    description: "hello world",
    notification_basic_style: 7,
    open_type: 0,
    net_support: 1,
    user_confirm: 0,
    url: "http://developer.baidu.com",
    pkg_content: "",
    pkg_name: "com.baidu.bccsclient",
    pkg_version: "0.1",
    aps: {
      alert:"Message From Baidu Push",
      # 'content-available': true,
      sound:"",
      badge:0
      },
    key1: "value1",
    key2: "value2"
  }.to_json

  DEFAULT_IOS_MSG = {
    aps: {
      alert:"Message From Baidu Push"
      }
  }.to_json
  DEPLOY_STATUS = {
    development: 1,
    production: 2
  }
  class Client
    include Virtus.model
    attribute :server_host, String
    attribute :common_path, String
    attribute :channel_id, String
    attribute :user_id, String
    attribute :ak, String
    attribute :sk, String
    attribute :device_type, Integer, default: DEVICE_TYPE[:ios]
    attribute :push_type, Integer, default: PUSH_TYPE[:user]
    attribute :messages, String, default: DEFAULT_IOS_MSG
    attribute :message_type, Integer, default: MESSAGE_TYPE[:notification]
    attribute :api_method, String, default: 'push_msg'
    attribute :deploy_status, Integer, default: DEPLOY_STATUS[:development]

    def initialize(options)
      super
    end

    def query_bindlist(target_hash)
      self.api_method = 'query_bindlist'
      self.attributes = self.attributes.merge target_hash

      self.push_type = nil
      self.message_type = nil
      resp = rest_client.post url_path_with_query_string do |req|
        req.headers = headers
      end
      resp
    end

    def push_all(options={})
      self.attributes = self.attributes.merge options
      self.api_method = 'push_msg'
      self.push_type = PUSH_TYPE[:all]
      self.message_type = MESSAGE_TYPE[:notification]
      self.device_type = nil

      resp = rest_client.post url_path_with_query_string do |req|
        req.headers = headers
      end
      resp
    end

    def push(target_hash)
      self.attributes = self.attributes.merge target_hash
      self.api_method = 'push_msg'
      resp = rest_client.post url_path_with_query_string do |req|
        req.headers = headers
      end
      resp
    end

    def sign_request(query_hash)
      # bodyArgs.sign = getSign('POST', PROTOCOL_SCHEMA + host + path, bodyArgs, sk);

      method = 'POST'

      url = 'https://' + server_host + url_path
      str = query_hash.sort { |a, b| a[0]<=>b[0] }.map { |x| "#{x[0]}=#{x[1]}" }.join
      urlencoded_str = CGI.escape(method.to_s.upcase + url + str + sk)
      Digest::MD5.hexdigest(urlencoded_str)
    end


    def payload
      optional_payload = {
        'channel_id'=> channel_id,
        'user_id' => user_id,
        'device_type' => device_type,
        'message_type' => message_type,
        'msg_keys' => Time.now.to_i
      }
      optional_payload.delete_if {|k,v|v.nil?}

      must_payload = {
        'deploy_status' => deploy_status,
        'method' =>  api_method,
        'apikey' => ak,
        'push_type' => push_type,
        'timestamp' => Time.now.to_i,
        'expires' => Time.now.to_i+3600
      }
      must_payload.merge(optional_payload).merge({'messages' => messages})
    end

    private

    def headers

      {
        #'Content-Length': bodyStr.length,
        #'Content-Type':'application/x-www-form-urlencoded'
      }
    end

    def url_path
      common_path + "/channel"
    end

    def url_path_with_query_string
      hash = payload.merge({sign: sign_request(payload)})
      query_string = (hash.map{|k,v| "#{k}=#{v}"}.join("&"))
      url_path + '?' + query_string
    end

    def rest_client
      Faraday.new(url: "https://"+server_host) do |faraday|
        #faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
