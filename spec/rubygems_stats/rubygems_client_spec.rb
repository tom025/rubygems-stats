require_relative '../../lib/rubygems_stats/rubygems_client'
require 'vcr_spec_helper'
require 'unindent'
require 'logger'
describe RubygemsStats::RubygemsClient do
  describe '#retrieve_all' do
    let(:real_logger) {
      Logger.new(STDOUT).tap do |logger|
        logger.level = Logger::INFO
      end
    }
    let(:logger) { double(:logger).as_null_object }
    let(:client) { described_class.new(logger: logger) }

    vcr_options = {
      :cassette_name => "rubygems.org-full-search",
      :record => :new_episodes
    }

    it 'fetches all gem data from rubygems', :vcr => vcr_options, :slow => true do
      expect(client.retrieve_all.count).to be >= 75_000 #The number of gems on rubygems on 9th May 2014
    end

    context 'when the 1st page has data and the second page has no data' do
      let(:rails) {
        RubygemsStats::Gem.new(
          :name => 'rails',
          :downloads => 6
        )
      }

      let(:sinatra) {
        RubygemsStats::Gem.new(
          :name => 'sinatra',
          :downloads => 4
        )
      }

      before do
        json_body = <<-BODY
          [
            {
              "name": "rails",
              "downloads": 6
            },
            {
              "name": "sinatra",
              "downloads": 4
            }
          ]
        BODY

        stub_request(:get, 'https://rubygems.org/api/v1/search.json?page=1&query=').
          to_return(:body => json_body.unindent)

        stub_request(:get, 'https://rubygems.org/api/v1/search.json?page=2&query=').
          to_return(:body => '[]')
      end

      it 'returns the gems from response' do
        expect(client.retrieve_all.map(&:attributes)).to match_array [rails, sinatra].map(&:attributes)
      end

      context 'when the response is something that cannot be parsed' do
        before do
          html = <<-HTML
            <html>
              Can't parse this. I requested json.
            </html>
          HTML
          stub_request(:get, 'https://rubygems.org/api/v1/search.json?page=2&query=').
            to_return(:body => html)

          stub_request(:get, 'https://rubygems.org/api/v1/search.json?page=3&query=').
            to_return(:body => '[]')
        end

        it 'skips to the next page' do
          expect(client.retrieve_all.map(&:attributes)).to match_array [rails, sinatra].map(&:attributes)
        end

        it 'logs the error' do
          expect(logger).to receive(:error) do |error_message|
            expect(error_message).to match(/Failed to get gem data from page 2/)
          end
          client.retrieve_all
        end
      end
    end
  end
end
