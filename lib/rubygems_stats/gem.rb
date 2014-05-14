require 'virtus'
class RubygemsStats
  class Gem
    include Virtus.model

    attribute :name, String
    attribute :downloads, Integer
  end
end
