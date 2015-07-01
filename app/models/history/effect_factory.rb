# History::EffectFactory is a simple helper factory, used to construct the
# skeleton of a History::Effect that will then be filled out by the actual
# import job code.
#
# TODO: find a better word than factory, as this doesn't really construct a
# finished History::Effect, it just ensures the application order is consistent
class History::EffectFactory

  attr_reader :results

  def initialize(history_operation)
    @current_index = 0
    @history_operation = history_operation
    @results = []
  end

  def create!(type_name, account_public_key, details)

    hacc = History::Account.
      where(address: Convert.pk_to_address(account_public_key)).
      first

    heff = History::Effect.create!({
      history_account_id: hacc.id,
      history_operation_id: @history_operation.id,
      order: @current_index,
      type: History::Effect::BY_NAME[type_name],
      details: details,
    })
    @current_index += 1
    @results << heff
    heff
  end
end
