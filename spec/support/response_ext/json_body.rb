module JsonBody
  extend ActiveSupport::Concern
  extend Memoist

  def json_body
    ActiveSupport::JSON.decode(self.body)
  end
  memoize :json_body
end

ActionDispatch::TestResponse.send(:include, JsonBody)