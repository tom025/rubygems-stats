require 'forwardable'
class RubygemsStats
  class RubygemsRepo
    extend Forwardable
    def_delegators :cache, :all

    attr_reader :rubygems_client, :cache
    private :rubygems_client, :cache
    def initialize(
      rubygems_client: RubygemsStats.rubygems_client,
      cache: RubygemsStats.gems_cache
    )
      @rubygems_client = rubygems_client
      @cache = cache
      if @cache.empty? || @cache.expired?
        @cache.recreate(@rubygems_client.retrieve_all)
      end
    end

    def <<(gem)
      cache << gem
      self
    end
  end
end
