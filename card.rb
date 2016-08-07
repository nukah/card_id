class Card
  attr_reader :number

  SYSTEM_MATCHER = {
    /^(34|37)\d{13}$/ => 'AMEX',
    /^(6011)\d{12}$/ => 'Discover',
    /^(51|52|53|54|55)\d{14}$/ => 'Mastercard',
    /^4(\d{12}|\d{15})$/ => 'VISA'
  }

  def initialize(number)
    @number = number.to_s.gsub(/(\s)|(\.)|(\,)|(\|)|(\-)/,'')
  end

  def system
    return 'Unknown' unless identified_system

    identified_system.last
  end

  def valid?
    !number.match(/^\d*$/).nil?
  end

  def correct?
    return false if !valid? || identified_system.nil? || check_sum.zero?
    (check_sum % 10) == 0
  end

  private

  def identified_system
    SYSTEM_MATCHER.find { |pattern, system| !number.match(pattern).nil? }
  end

  def check_sum
    (immutable + mutable).inject(0, :+)
  end

  def immutable
    cc_symbols.reject.with_index(&chosen_selector)
  end

  def mutable
    cc_symbols.select.with_index(&chosen_selector).map do |element, _|
      multiple = element * 2

      multiple > 9 ? (multiple - 9) : multiple
    end
  end

  def cc_symbols
    @cc_symbols ||= number.split('').map(&:to_i)
  end

  def chosen_selector
    cc_symbols.length.even? ? -> (_, index) { index.even? } : -> (_, index) { index.odd? }
  end
end
