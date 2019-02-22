RSpec.describe Psychometric::Result do
  it 'can be initialized with values' do
    result = Psychometric::Result.new('One' => 1, 'Two' => 2)
    expect(result.values).to eq({ 'One' => 1, 'Two' => 2 })
  end
end
