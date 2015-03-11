class HexValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[a-f0-9]+$/
      record.errors[attribute] << (options[:message] || "is not hex-encoded")
    end
  end
end