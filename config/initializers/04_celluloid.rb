require 'celluloid'
require 'sucker_punch'
Celluloid.logger = Rails.logger

Metriks.gauge("celluloid.actor_count"){ Celluloid.actor_system.running.size }