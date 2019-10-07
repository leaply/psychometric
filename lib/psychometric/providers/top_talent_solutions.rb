require 'httparty'
require 'psychometric/provider'

module Psychometric
  module Providers
    class TopTalentSolutions < Psychometric::Provider
      # Configuration
      authenticate_with :username, :password
      assessments_identified_with :project_id, :model_id

      # API Implementation
      include HTTParty
      base_uri 'https://www.tts-assess.com/api'
      # base_uri(ENV['RACK_ENV'] == 'production' ? 'https://www.tts-assess.com/api' : 'https://www.tts-assessments.com/api')

      def authenticate!
        response = self.class.post '/generateToken', headers: { 'Accept' => 'application/json' }, body: { 'username' => @authentication[:username], 'password' => @authentication[:password] }.to_json

        # Response Code - 401 {"result": "error", "errors": "Bad credentials exception!"}
        raise response['errors'].to_json if response['result'] == 'error'

        # Response Code - 200 { "result": "success", "token": "YknYEjMRjVMaIGUTJQ8cWO9xAXSyK0awlQzGpk6_nzhM0n140dUMn-Ja- S9BYKbWc5HIj8LA" }
        @token = response['token'] if response.code == 200 && response['result'] == 'success'
      end

      def authenticated?
        !@token.nil? && !@token.empty?
      end

      # Returns assessments linked to this account once authenticated
      #
      # NOTE: This is not currently possible with the TTS API
      def assessments
        raise Psychometric::Provider::AuthenticationError.new('You need to authenticate first') unless authenticated?
        raise NotImplementedError # API does not expose Model IDs

        response = self.class.get '/getProjectList/en_ZA', headers: { 'Authorization' => "Bearer #{@token}", 'Accept' => 'application/json' }

        # Response Code - 401 {'result': "error", 'errors': {"Not enough permission for this request."}}
        raise response['errors'].to_json if response['result'] == 'error'

        # Response Code - 200 { 'result': "success", 'data': [{ 'id': 5, 'internalName': "Internal Project Name 1", 'completedCandidate': 10, 'status': "In Progress", 'costcode': "free" }]
        if response.code == 200 && response['result'] == 'success'
          response['data'].map do |hash|
            # hash
          end
        else
          raise 'Unknown error'
        end
      end

      # Given an Assessment returns the Results recorded for that Assessment
      def results(assessment)
        raise Psychometric::Provider::AuthenticationError.new('You need to authenticate first') unless authenticated?

        response = self.class.post '/getDataExtract', timeout: 180, headers: { 'Authorization' => "Bearer #{@token}", 'Accept' => 'application/json' }, body: {
          'projectId' => assessment.identity[:project_id],
          'modelId' => assessment.identity[:model_id],
          'locale' => 'en_ZA',
        }.to_json

        # Response Code - 400 { 'result': 'error', 'errors': ['No instrument norm combination found']}
        raise response['errors'].to_json if response['result'] == 'error'

        # Response Code - 200 { 'result': 'success', 'data': [{ 'participantId': 12, 'name': "john", 'surname': "doe", 'testCompleted': "05 July 2016 14:25:00", 'variable1': 2, 'variable2': 4, 'variable3': 5 }, ...] }
        if response['result'] == 'success'
          response['data'].map do |item|
            Psychometric::Result.new.tap do |result|
              result.subject = Psychometric::Subject.new(
                country: case item['participantId']
                         when /^G\d+/
                           'GH'
                         else
                           'ZA'
                         end,
                identity: item['participantId'],
                email: item['email'],
                name: "#{item['name']} #{item['surname']}",
                gender: item['Gender|gender|Raw|Raw score'],
                title: item['Title|title|Raw|Raw score'],
              )

              # NOTE: This may need to be configurable in the future
              result.aggregate = item['OverAll'].try(:to_f)

              values = item.reject do |key, _v|
                [
                  'participantGUID',
                  'participantId',
                  'email',
                  'name',
                  'surname',
                  'Gender|gender|Raw|Raw score',
                  'Title|title|Raw|Raw score',
                  'OverAll',
                  'Highest Qualification',
                  'Cultural Background',
                ].include? key
              end

              result.values = Hash[values.map { |k, v| [k.split('|').first, v] }]
            end
          end
        else
          raise 'Unknown error'
        end
      end
    end
  end
end
