require 'rubygems_stats'
require 'rubygems_stats/gem'

describe RubygemsStats do

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

  let(:stats) { described_class.new }
  let(:download_stats) { stats.download_stats }
  let(:gems_cache) {
    RubygemsStats::InMemoryGemsCache.new.tap do |gems_cache|
      gems_cache << rails
      gems_cache << cucumber
      gems_cache << sinatra
    end
  }

  before do
    described_class.gems_cache = gems_cache
  end


  it 'lists the most downloaded gems in order of rank' do
    expect(download_stats.count).to eq 3

    expect(download_stats.first).to eq rails
    expect(download_stats.last).to eq cucumber
    expect(download_stats[1]).to eq sinatra

    expect(download_stats.rank_of('rails')).to eq 1
    expect(download_stats.rank_of('cucumber')).to eq 3
  end

end


