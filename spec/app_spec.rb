RSpec.describe App do
  include Rack::Test::Methods
  subject { last_response }
  let(:app) { described_class }
  let(:secret) { nil }
  let(:parameters) { Hash.new }

  before do
    app.configure { |c| c.set(:r10k_bin, 'echo') }
    header 'X-Gitlab-Token', secret
    post '/', parameters
  end

  context 'with valid request' do
    let(:parameters) { fixture :gitlab_hook }
    let(:secret)     { 'secrettoken' }

    it { is_expected.to be_successful }
  end

  context 'with invalid parameters' do
    let(:secret)     { 'secrettoken' }

    it { is_expected.to be_bad_request }
  end

  context 'with invalid secret' do
    it { is_expected.to be_unauthorized }
  end
end
