# encoding: utf-8
require 'open-uri'
require 'hpricot'

class Station < ActiveRecord::Base

	def self.search(latitude, longitude, radius = 1000)
		arr = self.fetch(latitude, longitude, radius)
		arr.each do |s|
			station = Station.find_by_localId(s['localId'])
			if (station.nil?)
				station = Station.new(s)
				station.save
			else
				station.attributes = s
				station.save
			end
		end
		arr.length
	end

private
	def self.fetch(latitude, longitude, radius = 1000)
		stations = []
		base_url = "http://www.hzbus.cn/bg.axd?"
		url = "#{base_url}c=1007&w=#{radius}&h=#{radius}&x=#{latitude}&y=#{longitude}"
		open(url) { |f|
			Hpricot(f).search("row").each do |row|
				station = Hash.new
				station['name'] = row['fname'].to_s
				station['address'] = row['faddress'].to_s
				station['latitude'] = row['fshape'].split[0].to_f
				station['longitude'] = row['fshape'].split[1].to_f
				station['space'] = row['fcount'].to_i
				station['idle'] = row['femptycount'].to_i
				station['openTime'] = row['fservicetime'].split('-')[0].split(':')[0].to_i
				station['closeTime'] = row['fservicetime'].split('-')[1].split(':')[0].to_i
				station['localId'] = row['fid'].to_s
				station['functioning'] = row['fsummary'].to_s.eql?("正常营运中")
				stations << station
			end
		}
		stations
	end
end
