# frozen_string_literal: true

require 'rails_helper'

describe Types::Player::PlayerType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type('ID!') }
  it { is_expected.to have_field(:name).of_type('String!') }
  it { is_expected.to have_field(:number).of_type('Int') }
  it { is_expected.to have_field(:nationality).of_type('String') }
  it { is_expected.to have_field(:age).of_type('Int') }
  it { is_expected.to have_field(:position).of_type('String!') }
  it { is_expected.to have_field(:team_id).of_type('Int') }
  it { is_expected.to have_field(:team).of_type(Types::Team::TeamType) }
  it { is_expected.to have_field(:created_at).of_type('ISO8601DateTime!') }
  it { is_expected.to have_field(:updated_at).of_type('ISO8601DateTime!') }
end
