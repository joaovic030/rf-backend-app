# frozen_string_literal: true

require 'rails_helper'

describe Types::Subscription::PlayerUserSubscriptionType do
  subject { described_class }

  it { is_expected.to have_field(:player_id).of_type('Int!') }
  it { is_expected.to have_field(:user_subscribed).of_type(Types::User::UserType) }
end
