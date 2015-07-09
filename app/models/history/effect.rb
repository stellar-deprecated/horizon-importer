class History::Effect < History::Base

  BY_TYPE = {
    # account effects
    0 => "account_created", # from create_account
    1 => "account_removed", # from merge_account
    2 => "account_credited", # from create_account, payment, path_payment, merge_account
    3 => "account_debited", # from create_account, payment, path_payment, create_account
    4 => "account_thresholds_updated", # from set_options
    5 => "account_home_domain_updated", # from set_options
    6 => "account_flags_updated", # from set_options

    # signer effects
    10 => "signer_created", # from set_options
    11 => "signer_removed", # from set_options
    12 => "signer_updated", # from set_options

    # trustline effects
    20 => "trustline_created", # from change_trust
    21 => "trustline_removed", # from change_trust
    22 => "trustline_updated", # from change_trust, allow_trust
    23 => "trustline_authorized", # from allow_trust
    24 => "trustline_deauthorized", # from allow_trust

    # trading effects
    30 => "offer_created", # from manage_offer, creat_passive_offer
    31 => "offer_removed", # from manage_offer, creat_passive_offer, path_payment
    32 => "offer_updated", # from manage_offer, creat_passive_offer, path_payment
    33 => "trade", # from manage_offer, creat_passive_offer, path_payment
  }

  BY_NAME = BY_TYPE.invert


  include Pageable

  # disable STI
  def self.inheritance_column ; nil ; end

  self.primary_keys = [:history_account_id, :history_operation_id, :order]

  validates :history_account_id, presence: true
  validates :history_operation_id, presence: true
  validates :order,
    presence: true,
    uniqueness: {scope: [:history_account_id, :history_operation_id]},
    numericality: true

end
