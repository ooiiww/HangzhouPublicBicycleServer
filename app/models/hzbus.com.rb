# encoding: utf-8
require 'open-uri'
require 'hpricot'

module Hzbus
	def Hzbus.search(latitude, longitude, radius = 1000)
		stations = []
		base_url = "http://www.hzbus.cn/bg.axd?"
		url = "#{base_url}c=1007&w=#{radius}&h=#{radius}&x=#{radius}"
		open(url) { |f|
			Hpricot(f).search("row").each do |row|
				station = Hash.new
				station['name'] = row['fname']
				station['address'] = row['faddress']
				station['latitude'] = row['fshape'].split[0].to_f
				station['longitude'] = row['fshape'].split[1].to_f
				station['space'] = row['fcount'].to_i
				station['idle'] = row['femptycount'].to_i
				station['openTime'] = row['fservicetime'].split('-')[0].split(':')[0].to_i
				station['closeTime'] = row['fservicetime'].split('-')[1].split(':')[0].to_i
				station['localId'] = row['fid']
				station['functioning'] = row['fsummany'].eql?("正常营运中")
				stations << station
				puts station
			end
		}
	end
end
