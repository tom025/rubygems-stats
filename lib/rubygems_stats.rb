class RubygemsStats
  def self.gem_repo=(gem_repo)
    @gem_repo = gem_repo
  end

  def self.gem_repo
    @gem_repo ||= RubyGemsRepo.new
  end

  attr_reader :gem_repo
  def initialize(
    gem_repo: RubygemsStats.gem_repo
  )
    @gem_repo = gem_repo
  end

  def download_stats
    DownloadStats.new(gem_repo.all)
  end

  require 'delegate'
  class DownloadStats < SimpleDelegator
    def initialize(gems)
      super(gems.sort_by(&:downloads).reverse)
    end

    def rank_of(gem_name)
      find { |gem| gem.name == gem_name }.downloads
    end
  end

  require 'virtus'
  class Gem
    include Virtus.model

    attribute :name, String
    attribute :downloads, Integer
  end
end
