Action = Struct.new(:actor, :previous_amount, :new_amount) do
  def type
    signed_amount >= 0 ? "credit" : "debit"
  end

  def amount
    signed_amount.abs
  end

  private

  def signed_amount
    new_amount - previous_amount
  end
end
