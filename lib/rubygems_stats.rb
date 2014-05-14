class RubygemsStats
  def self.gem_repo=(gem_repo)
    @gem_repo = gem_repo
  end

  require 'rubygems_stats/rubygems_repo'
  def self.gem_repo
    @gem_repo ||= RubygemsRepo.new
  end

  require 'logger'
  def self.logger
    @logger ||= Logger.new(STDOUT).tap do |logger|
      logger.level = Logger::WARN
    end
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.rubygems_client
    @rubygems_client ||= RubygemsClient.new
  end

  def self.rubygems_client=(client)
    @rubygems_client = client
  end

  require 'rubygems_stats/in_memory_gems_cache'
  def self.gems_cache
    @gems_cache ||= InMemoryGemsCache.new
  end

  def self.gems_cache=(cache)
    @gems_cache = cache
  end

  attr_reader :gem_repo
  def initialize(
    gem_repo: RubygemsStats.gem_repo
  )
    @gem_repo = gem_repo
  end

  require 'rubygems_stats/download_stats'
  def download_stats
    DownloadStats.new(gem_repo.all)
  end

end
