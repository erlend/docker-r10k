RSpec.describe RunnerJob do
  before { App.configure { |c| c.set :r10k_bin, 'echo' } }
  subject { described_class.new.perform branch }

  context 'with valid branch' do
    let(:branch) { :master }

    it { is_expected.to eq "deploy environment -p master\n" }
  end

  context 'with invalid branch' do
    let(:branch) { nil }

    it { is_expected.to be false }
  end
end
