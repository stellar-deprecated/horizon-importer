class Metriks::RegistrySerializer < ApplicationSerializer

  schema do
    link :self, href: "/metrics"


    Metriks::Registry.default.each do |name, metric|

      case metric
      when Metriks::Meter
        property "#{name}_one_minute_rate", metric.one_minute_rate
        property "#{name}_five_minute_rate", metric.five_minute_rate
        property "#{name}_fifteen_minute_rate", metric.fifteen_minute_rate
      else
        proprty name, "TODO"
      end
    end
  end
end