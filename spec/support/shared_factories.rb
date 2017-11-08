shared_context "shared factories" do
  let(:short_link) { create(:short_link) }
  let(:stat) { create(:stat) }
  let(:short_link_id) { short_link.stat }
  let(:shortcode) { short_link.shortcode }
end
