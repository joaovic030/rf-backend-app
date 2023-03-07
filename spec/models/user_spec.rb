require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  shared_examples 'user is invalid' do
    it { expect(user).not_to be_valid }
  end

  context 'with valid attributes' do
    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    context 'when email is blank' do
      let(:user) { build(:user, email: nil) }

      it_behaves_like 'user is invalid'
    end

    context 'when email is the same' do
      let!(:user_same_email) { create(:user, email: 'example@email.com') }

      let(:user) { build(:user, email: 'example@email.com') }

      it_behaves_like 'user is invalid'
    end
  end
end
