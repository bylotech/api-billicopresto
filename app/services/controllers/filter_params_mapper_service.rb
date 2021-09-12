class Controllers::FilterParamsMapperService

  MONEY_FIELDS = %w[
    unit_price
    amount_excluding_taxes
    amount_including_taxes
    amount_taxes
  ]

  SUFFIX_OPERATOR = %w[
    _less
    _more
    _not]
    
  def initialize(filters, filter_params)
    @filters = filters
    @filter_params = filter_params
  end

  def call!
    add_operators
    map_filters
    @filters
  end

  private

  def map_filters
    convert_cents
  end

  def convert_cents

    regex = "^(#{MONEY_FIELDS.join('|')})+(#{SUFFIX_OPERATOR.join('|')}|)$"

    money_fields = @filters.select{|key, value| key.match(/#{regex}/) }

    money_fields.each do |key,value|
      @filters[key_cents(key)] = value.to_f*100.to_i
      @filters.delete(key)
    end

    @filters
  end

  def key_cents(key)
    regex = "(#{SUFFIX_OPERATOR.join('|')})$"
    suffix = key.match(regex)&.to_s
    suffix ? key.gsub(/#{regex}/, "_cents#{suffix}") : "#{key}_cents"
  end

  def add_operators
    filter_operators = @filter_params.select{|k,v| k.end_with?("_operator") }
    filter_operators.each do |filter_operator, value|
      field = filter_operator.delete_suffix("_operator")
      next unless @filters[field]
      @filters["#{field}_#{value}"] = @filters[field]
      @filters.delete(field)
    end
  end

end
