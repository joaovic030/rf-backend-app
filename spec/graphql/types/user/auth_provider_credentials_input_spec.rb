# frozen_string_literal: true

require 'rails_helper'

describe Types::User::AuthProviderCredentialsInput do
  subject { described_class }

  it { is_expected.to accept_argument(:email).of_type("String!") }
  it { is_expected.to accept_argument(:password).of_type("String!") }
end
