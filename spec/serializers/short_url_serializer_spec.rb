describe ShortUrlSerializer do
  let!(:short_url) do
    create(
      :short_url,
      redirect_count: 1,
      last_seen_date: Time.current
    )
  end

  let(:expected_result) do
    {
      short_url: {
        startDate: short_url.start_date.iso8601,
        redirectCount: short_url.redirect_count,
        lastSeenDate: short_url.last_seen_date.iso8601
      }
    }
  end

  it 'returns a serialized hash' do
    serializable_hash = ActiveModelSerializers::SerializableResource.new(
      short_url,
      adapter: :json,
      serializer: ShortUrlSerializer
    ).serializable_hash

    expect(serializable_hash).to eq(expected_result)
  end
end
