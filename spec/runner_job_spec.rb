RSpec.describe RunnerJob do
  subject { described_class.new.perform branch }

  context 'with valid branch' do
    let(:branch) { 'master' }

    it { is_expected.to eq "deploy environment -p master\n" }
  end

  context 'with invalid branch' do
    let(:branch) { 'foo' }
    before do
      expect_any_instance_of(Logger).to receive(:info)
        .with("Ignoring hook for non-existent environment: #{branch}")
        .once.and_return false
    end

    it { is_expected.to be false }
  end
end
