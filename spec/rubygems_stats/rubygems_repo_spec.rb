require_relative '../../lib/rubygems_stats/rubygems_repo'
require_relative '../../lib/rubygems_stats/gem'
require_relative '../../lib/rubygems_stats/in_memory_gems_cache'
describe RubygemsStats::RubygemsRepo do

  describe 'initialization' do
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

    let(:cucumber) {
      RubygemsStats::Gem.new(
        :name => 'cucumber',
        :downloads => 2
      )
    }

    let!(:repo) {
      described_class.new(
        rubygems_client: rubygems_client,
        cache: cache
      )
    }

    context 'when the cache is empty' do
      let(:rubygems_client) {
        double(:rubygems_client, :retrieve_all => [rails, sinatra])
      }

      let(:cache) { RubygemsStats::InMemoryGemsCache.new }

      it 'updates the itself from the client' do
        expect(repo.all).to have(2).gems
        expect(repo.all).to match_array [sinatra, rails]
      end

      it 'updates the cache' do
        expect(cache).to_not be_empty
        expect(cache.all).to match_array [rails, sinatra]
      end
    end

    context 'when the cache has expired' do
      let(:clock) { double(:clock, :now => DateTime.parse('20140513T040506+0000')) }
      let(:rubygems_client) {
        double(:rubygems_client, :retrieve_all => [rails, sinatra, cucumber])
      }
      let(:cache) {
        RubygemsStats::InMemoryGemsCache.new(
          clock: clock,
          expires: DateTime.parse('20140402T040506+0000')
        ).tap do |cache|
          cache << rails
          cache << sinatra
        end
      }

      it 'updates the itself from the client' do
        expect(repo.all).to have(3).gems
        expect(repo.all).to match_array [sinatra, rails, cucumber]
      end

      it 'updates the cache' do
        expect(cache).to_not be_empty
        expect(cache.all).to match_array [rails, sinatra, cucumber]
      end
    end
  end
end

