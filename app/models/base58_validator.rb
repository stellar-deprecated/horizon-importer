class Base58Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors[attribute] << (options[:message] || "is not base58 encoded")
      return
    end


    check_version_byte = options[:check] 

    if check_version_byte.present?
      Convert.base58.check_decode(check_version_byte, value)
    else
      Convert.base58.decode(value)
    end

  rescue ArgumentError
    record.errors[attribute] << (options[:message] || "is not base58 encoded")
  end
end