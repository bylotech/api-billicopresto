class Controllers::FilterService
  require_relative "filter_params_mapper_service"
  require_relative "filter_params_whitelist_service"

  OPERATOR_SUFFIX_WHITELIST = %w[_less _more _not]
  def initialize(collection, field_filter_whitelist, filter_params)
    @collection = collection
    @filtered_collection = @collection
    @filter_params = filter_params.respond_to?(:to_unsafe_h) ? filter_params.to_unsafe_h : filter_params
    @field_filter_whitelist = field_filter_whitelist
    @operator_available_fields = field_filter_whitelist.select{|k,v| v[:operator_available]}.keys
    @filter_used = []
  end

  def filter!
    @filters = Controllers::FilterParamsWhitelistService.new(@filter_params, @field_filter_whitelist.keys).call!
    @filters = Controllers::FilterParamsMapperService.new(@filters, @filter_params, @field_filter_whitelist).call!
    classic_filter
    custom_filter
    result = {
      result: @filtered_collection,
      filters_used: @filter_used
    }
  end

  def list!
    @filters = Controllers::FilterParamsWhitelistService.new(@filter_params, @field_filter_whitelist.keys).call!
    @filters = Controllers::FilterParamsMapperService.new(@filters, @filter_params).call!
    @filters.transform_keys do |key|
      regex = /(?<prefix>.+)_(?<suffix>more|less)/
      key_contain_suffix = key.match?(regex)

      return @field_filter_whitelist.dig(key.to_sym, :public_name) unless key_contain_suffix

      new_key = @field_filter_whitelist.dig(key.match(regex)[:prefix].to_sym, :public_name)
      operator = @field_filter_whitelist.dig(key.match(regex)[:prefix].to_sym, :public_name_operators, key.match(regex)[:suffix].to_sym)
      "#{new_key} #{operator}"
    end
    
  end

  private

  def custom_filter
    not_filter 
    less_filter
    more_filter
  end

  def classic_filter
    return unless classic_filters = @filters.reject{|filter| filter.end_with?(*OPERATOR_SUFFIX_WHITELIST)}.presence
    @filtered_collection = @filtered_collection.where(classic_filters)
    @filter_used.push *classic_filters.map{ |filter, value| {filter => value} }
  end

  def not_filter
    return unless not_filters = @filters.select{|filter| filter.end_with?("_not")}.presence
    @filtered_collection = @filtered_collection.where.not(not_filters.transform_keys { |k| k.delete_suffix("_not") })
    @filter_used.push *not_filters.map{ |not_filter, value| {not_filter => value} }
  end

  def less_filter
    return unless filters = less_filters.presence
    less_filters.each do |field, value|
      @filtered_collection = @filtered_collection.where("#{field.delete_suffix("_less")} < ?", value)
      @filter_used<<{field => value}
    end
  end

  def less_filters 
    @filters.select do |filter| 
      filter.end_with?("_less") && operator_available_filter?(filter)
    end
  end


  def more_filter
    return unless filters = more_filters.presence
    more_filters.each do |field, value|
      @filtered_collection = @filtered_collection.where("#{field.delete_suffix("_more")} > ?", value)
      @filter_used<<{field => value}
    end
  end

  def more_filters 
    @filters.select do |filter|
      filter.end_with?("_more") && operator_available_filter?(filter)
    end
  end

  def operator_available_filter?(filter)
    allowed_filter = Controllers::FilterParamsWhitelistService.new(@filter_params, @operator_available_fields).call!
    allowed_filter = Controllers::FilterParamsMapperService.new(allowed_filter, @filter_params, @field_filter_whitelist).call!
    allowed_filter.keys.include?(filter)
  end

end