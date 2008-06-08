class User < ActiveRecord::Base
  validates_uniqueness_of :username
	validates_presence_of :username, :password, :name
	
	require 'md5'
	
	def self.authenticate(username, password)
		user = User.find(:first, :conditions => ["username = ? and password = ?", username, MD5.md5(password).hexdigest])
		if user.blank?
			raise "Username and/or password invalid."
		end
		user #returns user
	end
end
