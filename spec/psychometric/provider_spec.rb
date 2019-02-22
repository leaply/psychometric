require 'psychometric/providers/top_talent_solutions'

RSpec.describe Psychometric::Provider do
  context 'authenticated instance' do
    it 'enforces the authentication methods' do
      expect(
        Psychometric::Providers::TopTalentSolutions.new username: 'user', password: 'pass'
      ).to be_a Psychometric::Providers::TopTalentSolutions
    end

    it 'errors without the required authentication' do
      expect {
        Psychometric::Providers::TopTalentSolutions.new token: '12345'
      }.to raise_error Psychometric::Provider::AuthenticationError
    end
  end

  context 'generating assessments' do
    it 'errors without the correct identifiers' do
      expect {
        Psychometric::Providers::TopTalentSolutions.assessment nonsense: 1
      }.to raise_error Psychometric::Assessment::IdentityError
    end

    it 'succeeds with the correct identifiers' do
      expect(
        Psychometric::Providers::TopTalentSolutions.assessment project_id: 1, model_id: 1
      ).to be_a Psychometric::Assessment
    end
  end
end
