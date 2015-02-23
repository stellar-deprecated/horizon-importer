RSpec::Matchers.define :transition_to do |expected_result_state|

  match do |actual|
    @trigger.call
    subject.aasm.current_state == expected_result_state
  end

  chain :on do |&trigger|
    @trigger = trigger
  end
  
end