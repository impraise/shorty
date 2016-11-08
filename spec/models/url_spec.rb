require 'rails_helper'

RSpec.describe Url, type: :model do
	subject { Url.new url: 'http://www.impraise.com/'}
	it "is valid with ony an url" do 
		expect(subject).to be_valid
	end
	it "is not valid without an url" do 
		subject.url = nil
		expect(subject).to_not be_valid
	end
	it "generates a valid shotcode" do 
		expect(subject.generate_random_shortcode).to match(/\A[0-9a-zA-Z_]{4,}\z/)
	end
	it "is valid with valid shotcodes" do 
		valid_shortcodes = ["valid", "Ad6_43b", "LOOOOOOOOOOG", "1234", "_zV45dor_"]
		valid_shortcodes.each do |valid_shotcode|
			subject.shortcode = valid_shotcode
			expect(subject).to be_valid
		end
	end
	it "is not valid with not valid shotcodes" do 
		not_valid_shortcodes = ["shr", "not valid", "abcd*", "abcd?", "abcd&", "adcdé"]
		not_valid_shortcodes.each do |not_valid_shotcode|
			subject.shortcode = not_valid_shotcode
			expect(subject).to_not be_valid
		end
	end
	it "is saving valid url" do
	  expect{ subject.save }.to change(Url, :count).by(1)
	end
	it "is rejecting duplicate shotcode" do
		subject.save!
		duplicate = subject.dup
		expect(duplicate).to_not be_valid
	end
	it "is incrementing redirect counts when url is visited" do 
		expect{ subject.visit! }.to change{ subject.redirect_count }.from(0).to(1)
	end
	it "is setting up last seen at time when url is visited" do 
		subject.visit!
		expect(subject.last_seen_at).to be_kind_of(DateTime)
	end
end
