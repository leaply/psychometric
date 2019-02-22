RSpec.describe Psychometric::Assessment do
  it 'must be initialized with an identity' do
    assessment = Psychometric::Assessment.new(Psychometric::Provider, id: 12345)
    expect(assessment.identity).to eq(id: 12345)
  end

  it 'raises an error when identity is missing' do
    expect {
      Psychometric::Assessment.new Psychometric::Provider
    }.to raise_error Psychometric::Assessment::IdentityError
  end
end
