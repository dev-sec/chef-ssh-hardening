require 'spec_helper'

RSpec.configure do |c|
    c.filter_run_excluding :skipOn => backend(Serverspec::Commands::Base).check_os[:family]
end

describe 'SSH' do

end
