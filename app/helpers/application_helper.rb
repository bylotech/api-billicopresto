module ApplicationHelper
    def current_auth_resource
        if retailer_signed_in?
            current_retailer
        else
            current_user
        end
    end

    def current_ability
        @current_ability or @current_ability = Ability.new(current_auth_resource)
    end
end
