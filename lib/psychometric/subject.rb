module Psychometric
  # # Subject
  #
  # This represents someone who undergoes the psychometric assessment. Since
  # different providers identify subjects differently this class can be used
  # to map subjects to your users.
  class Subject
    attr_accessor :country, :identity, :email, :name, :gender, :title

    def initialize(args)
      @country = args[:country]
      @identity = args[:identity]
      @email = args[:email]
      @name = args[:name]
      @gender = args[:gender]
      @title = args[:title]
    end

    def to_s
      "\#<Psychometric::Subject name: \"#{@name}\" identity: \"#{@identity}\">"
    end
  end
end
