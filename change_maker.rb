class ChangeMaker
  # Returns an array of the least amount of coins required to get to 'amount'
  # **Assumption** Change can always be made - BONUS POINTS - raise an error if
  # change can not be made
  # Params:
  # +amount+:: The amount to make change for
  # +denominations+:: An array containing the denominations that can be used.
  #                   Defaults to standard US coin denominations
  def self.make_change(amount, denominations=[1,5,10,25])
    self.naive_make_change(amount, denominations)
  end

  def self.naive_make_change(amount, denominations)
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
      raise ChangeError.new
    end
  end
end

class ChangeError < StandardError; end
