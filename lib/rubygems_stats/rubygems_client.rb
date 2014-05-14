require 'json'
require 'gems'
require 'rubygems_stats/gem'
class RubygemsStats
  class RubygemsClient
    attr_reader :logger
    private :logger
    def initialize(logger: RubygemsStats.logger)
      @logger = logger
    end

    def retrieve_all
      logger.warn(
        [
          '',
          '*' * 80,
          '',
          'Downloading all gem data from rubygems takes approximately 3 hours.',
          'Please consider updating your cache from another source.',
          '',
          '*' * 80
        ].join("\n")
      )

      (1..Float::INFINITY).reduce([]) { |gemdata, page|
        begin
          response_data = JSON.parse(
            Gems.get('/api/v1/search.json', :query => '', :page => page.to_s)
          )
          logger.info("Gems from page #{page} retrieved successfully.")
        rescue JSON::ParserError => e
          logger.error(
            [
              '',
              "Failed to get gem data from page #{page}",
              "#{e.class}: #{e.message}"
            ].join("\n")
          )
          next(gemdata)
        end
        break(gemdata) if response_data.empty?
        gemdata.push(*response_data)
      }.map { |gemdata| RubygemsStats::Gem.new(gemdata) }
    end
  end
end
