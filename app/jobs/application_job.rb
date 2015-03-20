class ApplicationJob
  include SuckerPunch::Job

  private
  def with_db(mod=:active_record)
    base_module = (mod.to_s + "/base").classify.constantize

    result = base_module.connection_pool.with_connection{ yield }

    result
  end

  def logger
    Rails.logger
  end
end