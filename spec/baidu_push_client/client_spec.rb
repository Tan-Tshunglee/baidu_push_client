require 'spec_helper'
require 'vcr_helper'
require 'timecop'
describe BaiduPushClient::Client do
  before do

    Timecop.freeze(Time.utc(2015,2,4,6,40))
  end
  after do
    Timecop.return
  end
  options = {
    server_host:  'channel.api.duapp.com',
    common_path:  '/rest/2.0/channel',
    ak:           '9k14jrtoe3HjUnOBcapGIlN8',
    sk:           'F3iDv4MMm2ZZsXVDvlMVxdueiBikjU3p'
  }
  subject {BaiduPushClient::Client.new(options)}
  it "accept parameters" do
    expect {subject}.to_not raise_error
  end
  it "can access the initialized parameters" do
    expect(subject.server_host).to eq options[:server_host]
  end
  it "push msg to device by userid and channelid" do

    VCR.use_cassette('push_to_device') do
      expect(subject.push(user_id: 1139768951174354557, channel_id: 5329701810242571197).status).to be 200
    end
  end
  it "query bindlist by userid and channelid" do
    VCR.use_cassette('query_bindlist') do
      expect(subject.query_bindlist(user_id: 1139768951174354557, channel_id: 5329701810242571197).status).to be 200
    end
  end
  it 'push msg to all devices' do
    VCR.use_cassette('push_all') do
      expect(subject.push_all.status).to be 200
    end
  end
end
