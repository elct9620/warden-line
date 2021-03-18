# frozen_string_literal: true

require 'rack'

RSpec.describe Warden::Strategies::Line do
  subject(:strategy) { described_class.new(env.merge('warden' => warden)) }

  let(:response) { instance_double(Net::HTTPSuccess, code: 200, body: '{}') }
  let(:params) { {} }
  let(:env) { Rack::MockRequest.env_for('/', method: 'POST', params: params) }
  let(:warden) { Warden::Proxy.new(env, Warden::Manager.new(nil)) }

  before { allow(Net::HTTP).to receive(:post_form).and_return(response) }

  describe '#valid?' do
    it { is_expected.not_to be_valid }

    context 'when id_token given' do
      let(:params) { { id_token: 'dummy' } }

      it { is_expected.to be_valid }
    end
  end

  describe '#success?' do
    it { is_expected.to be_success }

    context 'when unauthorized' do
      let(:response) { instance_double(Net::HTTPUnauthorized, code: 401) }

      it { is_expected.not_to be_success }
    end
  end

  describe '#result' do
    subject { strategy.result }

    it { is_expected.to eq({}) }

    context 'when receive invalid JSON' do
      let(:response) { instance_double(Net::HTTPSuccess, code: 200, body: nil) }

      it { is_expected.to eq({}) }
    end
  end

  describe '#authenticate!' do
    subject(:authenticate!) { strategy.authenticate! }

    it 'is expected to call success!' do
      allow(strategy).to receive(:success!)
      authenticate!
      expect(strategy).to have_received(:success!).with({})
    end

    context 'when authenticate failed' do
      let(:response) do
        instance_double(Net::HTTPUnauthorized, code: 401, body: '{"error_description": "error description"}')
      end

      it 'is expected to call fail!' do
        allow(strategy).to receive(:fail!)
        authenticate!
        expect(strategy).to have_received(:fail!).with('error description')
      end
    end
  end
end
