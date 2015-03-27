class Metriks::RegistrySerializer < ApplicationSerializer

  schema do
    link :self, href: "/metrics"


    Metriks::Registry.default.each do |name, metric|

      case metric
      when Metriks::Meter
        property name, meter_data(metric)
      when Metriks::Timer
        property name, timer_data(metric)
      when Metriks::Gauge
        property name, metric.value
      else
        property name, "TODO"
      end
    end
  end

  private
  def meter_data(metric)
    {
      one_minute_rate:     metric.one_minute_rate,
      five_minute_rate:    metric.five_minute_rate,
      fifteen_minute_rate: metric.fifteen_minute_rate,
    }
  end

  def timer_data(metric)
    {
      count:               metric.count,
      one_minute_rate:     metric.one_minute_rate,
      five_minute_rate:    metric.five_minute_rate,
      fifteen_minute_rate: metric.fifteen_minute_rate,
      min:                 metric.min,
      max:                 metric.max,
      mean:                metric.mean,
    }
  end
end