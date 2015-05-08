class History::OperationParticipant < History::Base

  belongs_to :history_operation, class_name: "History::Operation"
  belongs_to :history_account,   class_name: "History::Account"
end
