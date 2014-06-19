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
	puts params.inspect
	puts params.to_s
	
	params.each do |k,v|
		@json = k
	end	
	details = JSON.parse @json
	
	if details and details['to'] and details['subject'] and details['body']
		message(details['to'], details['subject'], details['body'])
		return "all good - emailed ya at #{details['to']}"
	else
		return "you might be missings some required fields such as to, subject, and body... here's your body of post #{details.inspect}"
	end


end