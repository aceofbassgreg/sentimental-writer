require 'wordsmith-sdk'

class WordsmithSDK::Wrapper

  MY_API_TOKEN = YAML::load(File.open("config/wordsmith_token.yml","r"))

  Wordsmith.configure do |config|
    config.url = 'https://anvil.autoi.co/api/v0.1'
    config.token = MY_API_TOKEN["key"]
  end

end