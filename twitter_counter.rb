#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# vim: noet sts=4:ts=4:sw=4
# author: takano32 <tak at no32.tk>
#

require 'rubygems'
require 'pit'
require 'oauth'
require 'tweetstream'

config = Pit.get("twitter",
				 :require => {
	'consumer_key' => 'client CONSUMER_KEY',
	'consumer_secret' => 'client CONSUMER_SECRET',
	'access_token' => 'oauth ACCESS_TOKEN',
	'access_token_secret' => 'oauth ACCESS_TOKEN_SERCTET',
})

TweetStream.configure do |c|
	c.consumer_key       = config['consumer_key']
	c.consumer_secret    = config['consumer_secret']
	c.oauth_token        = config['access_token']
	c.oauth_token_secret = config['access_token_secret']
	c.auth_method        = :oauth
end


client = TweetStream::Client.new
count = 0

EventMachine.run do
	timer = EventMachine::PeriodicTimer.new(60) do
		$pre_count ||= 0
		diff_count = count - $pre_count
		puts "#{diff_count}: #{Time.now.to_s}"
		$pre_count = count
	end

	mutex = Mutex.new
	client.track '#lldiver' do |status|
		mutex.synchronize do
			count += 1
		end
	end
end

client.userstream

