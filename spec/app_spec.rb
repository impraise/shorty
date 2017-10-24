require File.expand_path '../spec_helper.rb', __FILE__

describe "Shorty Application" do
  it "should allow accessing the root page" do
    get '/'
    expect(last_response).to be_ok
  end
end
