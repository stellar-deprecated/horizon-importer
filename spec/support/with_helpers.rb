module WithHelpers

  def with(*args, &block)
    add_with_clause 'let', *args, &block
  end

  def with!(*args, &block)
    add_with_clause 'let!', *args, &block
  end

  private
  def add_with_clause(method_name, *args, &block)
    overrides     = args.extract_options!
    factory, name = *args
    name          ||= factory

    send(method_name, name) do
      if block.present?
        overrides.merge!(instance_eval(&block)) 
      end
      FactoryGirl.create factory, overrides
    end
  end
end

RSpec.configure{|c| c.extend WithHelpers}