require 'rubygems_stats'
require 'support/fake_gem_repo'

describe RubygemsStats do
  let(:gem_repo) { Testing::FakeGemRepo.new }

  let(:rails) {
    RubygemsStats::Gem.new(
      :name => 'rails',
      :downloads => 3
    )
  }

  let(:sinatra) {
    RubygemsStats::Gem.new(
      :name => 'sinatra',
      :downloads => 2
    )
  }

  let(:cucumber) {
    RubygemsStats::Gem.new(
      :name => 'cucumber',
      :downloads => 1
    )
  }

  let(:stats) { described_class.new }
  let(:download_stats) { stats.download_stats }

  before do
    gem_repo << rails
    gem_repo << cucumber
    gem_repo << sinatra

    described_class.gem_repo = gem_repo
  end


  it 'lists the most downloaded gems in order of rank' do
    expect(download_stats.count).to eq 3

    expect(download_stats.first).to eq rails
    expect(download_stats.last).to eq cucumber
    expect(download_stats[1]).to eq sinatra

    expect(download_stats.rank_of('rails')).to eq 3
    expect(download_stats.rank_of('cucumber')).to eq 1
  end

end
