require 'delegate'
class RubygemsStats
  class InMemoryGemsCache < SimpleDelegator
    attr_accessor :expires
    private :expires, :expires=

    attr_reader :gem_data, :clock
    private :gem_data, :clock
    def initialize(clock: DateTime, expires: clock.now.next_month)
      @gem_data = []
      @clock = clock
      @expires = expires
      super(@gem_data)
    end

    def expired?
      clock.now > expires
    end

    def recreate(new_gem_data)
      gem_data.clear
      @expires = clock.now.next_month
      gem_data.push(*new_gem_data)
    end

    def all
      gem_data
    end
  end
end
