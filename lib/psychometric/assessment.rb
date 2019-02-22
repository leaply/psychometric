module Psychometric
  # # Assessment
  #
  # This represents the various assessments a Subject can undertake with a
  # Provider. Since different providers have different ways of identifying and
  # organizing their assessments, we give them a dynamic identity.
  class Assessment
    class IdentityError < StandardError
      def message
        'Incorrect or missing identity, check the Provider configuration'
      end
    end
    class ProviderError < StandardError
      def message
        'Assessment needs a subclass of Provider as the first argument for identity checking'
      end
    end

    attr_reader :identity

    def initialize(provider, identity = {})
      raise IdentityError if identity.empty?
      raise ProviderError unless provider.ancestors.include? Psychometric::Provider
      @identity = identity
    end
  end
end
