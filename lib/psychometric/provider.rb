require 'psychometric/assessment'

module Psychometric
  # # Provider
  #
  # This is the standardized API that individual provider implementations
  # must conform to. It abstracts the constructs from the provider into those
  # used by Psychometric.
  class Provider
    class AuthenticationError < StandardError; end
    # raise NotImplementedError, 'Subclasses must define `resolved?`.'

    def initialize(authentication)
      raise AuthenticationError unless authentication.keys.to_set == @@authentication_keys.to_set
      @authentication = authentication
    end

    def self.assessment(identity)
      raise Assessment::IdentityError unless identity.keys.to_set == @@assessment_identifiers.to_set
      Assessment.new self, identity
    end

    protected

    def self.authenticate_with(*args)
      @@authentication_keys = args
    end

    def self.assessments_identified_with(*args)
      @@assessment_identifiers = args
    end
  end
end
