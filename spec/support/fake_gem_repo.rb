module Testing
  class FakeGemRepo
    attr_reader :gems
    private :gems
    def initialize
      @gems = []
    end

    def all
      gems
    end

    def <<(gem)
      gems << gem
      self
    end
  end
end
