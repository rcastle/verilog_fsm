
source :rubygems
#If this is a gem 
#Normal gems go in verilog_fsm.gemspec
gemspec

#development and test not install on heroku deployment
group :development do
end

group :test do
  gem "rspec", :require => "spec"
  gem "activerecord", :require => "active_record"
  gem "sqlite3", "~>1"
  gem "shoulda", "~> 3.0.1"
end
