module Retailers::Statistics
    class StatisticService
        def initialize(retailer)
            @retailer = retailer
        end

        def sales_by_product(**args)

            order = args[:order] == 'ASC' ? 'ASC' : 'DESC'
            limit = args[:limit].is_a?(Integer) && args[:limit]
             
            products = @retailer.products.joins(items: {receipt_lines: {receipt: :till}})
                .where(tills: {retailer: @retailer})
                .group(:id)
                .order("sum_quantity #{order}")
                .sum(:quantity).to_a

            products = product.last(limit) if limit
        
            sales_by_product_mapper(products)
        end


        def consumer_by_product(product_id, **args)

            order = args[:order] == 'ASC' ? 'ASC' : 'DESC'
            limit = args[:limit].is_a?(Integer) && args[:limit]

            users = User.joins(receipts: [:till, receipt_lines: {item: :product}])
                                    .where(tills: {retailer: @retailer}, 'item.product_id': product_id)
                                    .group(:id)
                                    .order("sum_quantity #{order}")
                                    .sum(:quantity).to_a
            
            users = users.last(limit) if limit
        
            bigest_consumer_by_product_mapper(users)
        end
        
        private 

        def sales_by_product_mapper(products)
            products.map do |product|
              keys = [:product_id, :quantity]
              values = product.flatten
              [keys, values].transpose.to_h
            end
        end
        
        def bigest_consumer_by_product_mapper(users)
        users.map do |user|
            keys = [:user_id, :quantity]
            values = user.flatten
            [keys,values].transpose.to_h
        end
        end
              
    end
end