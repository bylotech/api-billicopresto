RSpec.shared_examples "retailer authenticated page" do  |path|
    context "when the retailer is not loged in" do
        it "redirects to the log in page" do
            expect(get path).to redirect_to("http://www.example.com/retailer/login")
        end
    end

    context "when the current user not a retailer" do
        let(:user) {create(:user)}      
        before {sign_in user}
        it "redirects to the log in page" do
            expect(get path).to redirect_to("http://www.example.com/retailer/login")
        end
    end

    context "when the retailer is logged in" do
        let(:retailer) {create(:retailer)}      
        before {sign_in retailer}
        it "is succesfull" do
            get path
            expect(response).to have_http_status(:success)
        end
    end
end