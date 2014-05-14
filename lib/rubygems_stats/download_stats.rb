require 'delegate'
class RubygemsStats
  class DownloadStats < SimpleDelegator
    def initialize(gems)
      super(gems.sort_by(&:downloads).reverse)
    end

    def rank_of(gem_name)
      find_index { |gem| gem.name == gem_name } + 1
    end
  end
end
