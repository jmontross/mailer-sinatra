require 'sinatra'
require 'pony'
require 'json'

def message(to, subject, message)

	Pony.mail({
      :to => to,
      :from => "no-reply@example.com",
      :body => message,
      :via => :smtp,
      :via_options => {
        :address        => 'smtp.sendgrid.net',
        :port           => '587',
        :user_name      => ENV['SENDGRID_USER'],
        :password       => ENV['SENDGRID_PASSWORD'],
        :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
      }
    })
end

post "/" do 
	details = []
	
	params.each do |k,v|
		details = JSON.parse k
	end	
	
	if details and details['to'] and details['subject'] and details['body']
		begin 
			message(details['to'], details['subject'], details['body'])
		rescue Exception => e
			puts e.inspect
		end
		return "all good - emailed ya at #{details['to']}"
	else
		return "you might be missings some required fields such as to, subject, and body... here's your body of post #{details.inspect}"
	end


end