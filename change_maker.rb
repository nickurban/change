class ChangeMaker
  # Returns an array of the least amount of coins required to get to 'amount'
  # **Assumption** Change can always be made - BONUS POINTS - raise an error if
  # change can not be made
  # Params:
  # +amount+:: The amount to make change for
  # +denominations+:: An array containing the denominations that can be used.
  #                   Defaults to standard US coin denominations
  def self.make_change(amount, denominations=[1,5,10,25])
    self.make_change_recursively(amount, denominations).tap do |solution|
      raise ChangeError.new("Could not make change for #{amount} from #{denominations}") if solution.nil?
    end
  end

  # Slower, but more complete, recursive solution.
  def self.make_change_recursively(amount, denominations, stored_solutions = {})
    useful_denominations = denominations.reject { |den| den > amount }
    return nil if useful_denominations.empty?

    stored_solutions[amount] ||=
      if denominations.include?(amount)
        [amount]
      else
        solutions = denominations.map do |den| 
          sub_solution = self.make_change_recursively(amount - den, denominations) 
          sub_solution.nil? ? nil : sub_solution + [den]
        end
        solutions.compact.min_by(&:length)
      end
  end

  # Works for US coins but not for arbitrary denominations
  # Note: not currently tested in specs.
  def self.make_change_greedily(amount, denominations)
    denominations.sort!

    remaining_amount = amount
    change = []

    denominations.reverse_each do |denomination|
      coins_at_this_denomination = remaining_amount / denomination

      if coins_at_this_denomination > 0
        remaining_amount -= denomination * coins_at_this_denomination
        change += Array.new(coins_at_this_denomination, denomination)
      end
    end

    if remaining_amount == 0
      change
    else
      raise ChangeError.new "Could not make change for #{amount} from #{denominations}"
    end
  end
end

class ChangeError < StandardError; end
