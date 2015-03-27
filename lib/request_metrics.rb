# 
# Rack middleware and to record request data into the metrics subsystem
# 
class RequestMetrics

  def initialize(app, metriks)
    @app = app
    @metrics = metriks
    @total = metriks.meter("requests.total")
    @succeeded = metriks.meter("requests.succeeded")
    @failed = metriks.meter("requests.failed")
  end


  def call(env)
    status, headers, body = @app.call(env)

    if should_record(env)
      @total.mark

      if status >= 200 && status < 400
        @succeeded.mark
      elsif status >= 400 && status < 600
        @failed.mark
      end
    end

    [status, headers, body]
  end

  private
  def should_record(env)
    !env["request_metrics.ignore"]
  end

end
