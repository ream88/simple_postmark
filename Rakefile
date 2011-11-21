require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = %w[spec/delivery_method_spec.rb spec/railtie_spec.rb spec/mail_ext/message_spec.rb spec/mail_ext/part_spec.rb]
end

task(default: :test)