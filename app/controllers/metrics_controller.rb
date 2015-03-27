class MetricsController < ApplicationController
  def index
    request.env["request_metrics.ignore"] = true
    render oat:Metriks::Registry.default
  end
end
