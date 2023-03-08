# frozen_string_literal: true

require 'rails_helper'

describe Types::Player::Enums::OrderBy do
  subject { described_class }

  let(:enum_keys) do
    %w[name_asc
    name_desc
    position_asc
    position_desc
    nationality_asc
    nationality_desc
    age_asc
    age_desc]
  end

  it { expect(described_class.values.keys).to match_array(enum_keys) }
end
