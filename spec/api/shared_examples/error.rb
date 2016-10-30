shared_examples 'api:error' do
  it 'returns error with correct status' do
    expect(last_response.status).to eq(status)
  end

  it 'returns error with correct message' do
    expect(JSON.parse(last_response.body)['error']).to eq error
  end
end
