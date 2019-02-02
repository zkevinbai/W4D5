require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    #index, #create, #new, #show, #edit, #update, #destroy

    describe "#create" do
        context "with valid parameters" do
            it "saves the user to the table" do
                post :create, params: {user: FactoryBot.attributes_for(:user, username: "UBoat")}
                expect(User.find_by(username: "UBoat")).to be_instance_of(User)
            end

            it "signs the user in after signing up" do
                post :create, params: {user: FactoryBot.attributes_for(:user)}
                expect(User.first.session_token).to eq(session[:session_token])
            end

            it "redirects the user to the index page" do
                expect(response).to redirect_to(users_path)
            end
        end 

        context "with invalid parameters" do
            it "redirects the user to the signup page" do
                expect(response).to redirect_to new_user_path
            end   

            it "flashes an error on the signup page" do
                expect(flash[:error]).to be_present
            end   
        end 
    end

    describe "#new" do
        it "render new view" do
            expect(response).to render_template(:new)
        end
    end



end
