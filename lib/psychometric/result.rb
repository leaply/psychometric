module Psychometric
  # # Result
  #
  # A Result respresents a Subject undergoing an Assessment by a Provider and
  # will typically contain one or more Values. If there is a numerical value by
  # which Results can be ranked it will be assigned to `aggregate`.
  class Result
    attr_accessor :values, :subject, :assessment, :aggregate

    def initialize(values = {})
      @values = values
    end

    def to_s
      "\#<Psychometric::Result subject: \"#{@subject}\" values: #{@values}>"
    end
  end
end
