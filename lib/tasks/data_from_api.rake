# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'json'

namespace :data_from_api do
  desc 'Load players and teams'

  task load: :environment do
    uri  = File.join(Rails.root, 'db', 'seeds', 'players.json')
    file = File.read(uri)
    data = JSON.parse(file).deep_symbolize_keys

    teams = data.dig(:data, :teams)

    teams.each do |team|
      ActiveRecord::Base.transaction do
        team_persisted = Team.create!(name: team[:name], acronym: team[:acronym])

        team[:players].each do |player|
          age = ((Date.today - player[:birthdate].to_date).to_i / 365).to_i

          team_persisted.players << Player.create!(
            name: player[:name],
            number: player[:number] == 'nil' ? nil : player[:number],
            nationality: player[:nationality],
            age: age,
            position: player[:position]
          )
        end

        team_persisted.save
      end
    end

    teams
  end
end
