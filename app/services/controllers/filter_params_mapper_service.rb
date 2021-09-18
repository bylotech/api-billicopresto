class Controllers::FilterParamsMapperService

  SUFFIX_OPERATOR = %w[
    _less
    _more
    _not]
    
  def initialize(filters, filter_params, filter_params_whitelist)
    @filters = filters
    @filter_params = filter_params
    @filter_params_whitelist = filter_params_whitelist
  end

  def call!
    map_keys
    convert_cents
    add_operators
    @filters
  end

  private

  def convert_cents
    money_fields = @filters.select{|key, value| key.end_with?("_cents")}
    money_fields.each do |key,value|
      @filters[key] = value.to_f*100.to_i
    end
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
      mapped_field = @filter_params_whitelist.dig(field, :mapped_field) || field
      filter_value = @filters[mapped_field]
      next unless filter_value
      @filters["#{mapped_field}_#{value}"] = filter_value
      @filters.delete(mapped_field)
    end
  end

  def map_keys
    keys_to_map = @filter_params_whitelist.select{|k,v| v[:mapped_field] && @filters[k]}
    keys_to_map.each do |k,v|
      @filters[v[:mapped_field]] = @filters[k]
      @filters.delete(k)
    end
  end

end
