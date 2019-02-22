module Psychometric
  # # Result
  #
  # A Result respresents a Subject undergoing an Assessment by a Provider and
  # will typically contain one or more Values.
  class Result
    attr_accessor :values, :subject, :assessment

    def initialize(values = {})
      @values = values
    end

    def to_s
      "\#<Psychometric::Result subject: \"#{@subject}\" values: #{@values}>"
    end
  end
end
