class Controllers::FilterService
  require_relative "filter_params_mapper_service"
  require_relative "filter_params_whitelist_service"

  OPERATOR_SUFFIX_WHITELIST = %w[_less _more _not]
  def initialize(collection, field_filter_whitelist, filter_params)
    @collection = collection
    @filtered_collection = @collection
    @filter_params = filter_params.respond_to?(:to_unsafe_h) ? filter_params.to_unsafe_h : filter_params
    @field_filter_whitelist = field_filter_whitelist
  end

  def filter!
    @filters = Controllers::FilterParamsWhitelistService.new(@filter_params, @field_filter_whitelist).call!
    @filters = Controllers::FilterParamsMapperService.new(@filters, @filter_params).call!
    classic_filter
    custom_filter
    @filtered_collection
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
  end

  def not_filter
    return unless not_filters = @filters.select{|filter| filter.end_with?("_not")}.presence
    @filtered_collection = @filtered_collection.where.not(not_filters.transform_keys { |k| k.delete_suffix("_not") })
  end

  def less_filter
    return unless less_filters = @filters.select{|filter| filter.end_with?("_less")}.presence
    less_filters.each do |field, value|
      @filtered_collection = @filtered_collection.where("#{field.delete_suffix("_less")} < ?", value)
    end
  end

  def more_filter
    return unless more_filters = @filters.select{|filter| filter.end_with?("_more")}.presence
    more_filters.each do |field, value|
      @filtered_collection = @filtered_collection.where("#{field.delete_suffix("_more")} > ?", value)
    end
  end
end