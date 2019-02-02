# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  # username, password_digest, session_token, password length >= 6
  # User::find_by_credentials, #ensure_session_token, #generate_session_token, #reset_session_token!
  # #password=(password), #password, #is_password?(password)

  subject(:user){FactoryBot.create(:user)}

  describe '#initialize' do
    it {should validate_presence_of(:username)}
    it {should validate_uniqueness_of(:username)}

    it {should validate_presence_of(:password_digest)}

    it {should validate_presence_of(:session_token)}
    it {should validate_uniqueness_of(:session_token)}

    it {should validate_length_of(:password).is_at_least(6)}
  end

  describe '::find_by_credentials' do 
    context "valid input" do
      it 'should find a user' do 
        # debugger
        expect(User.find_by_credentials(user.username, "123456")).to eq(user)
      end
    end 

    context "invalid input" do
      it 'should return nil if search parameters are invalid' do 
        expect(User.find_by_credentials(user.username, "123")).to be_nil
      end
    end 
  end

  describe '#ensure_session_token' do
    it 'should be called after initalization' do
      expect(user.session_token).not_to be_nil
      User.new({username: "user", password: "123456"})
    end

    it 'should call #generate_session_token' do
      expect(user).to receive(:generate_session_token)
      user.session_token = nil
      user.ensure_session_token
    end
  end

  describe '#generate_session_token' do
    it 'should call urlsafe_base64 on SecureRandom' do
      expect(SecureRandom).to receive(:urlsafe_base64)
      User.new({username: "user", password: "123456"})
    end
  end

  describe '#reset_session_token!' do
    it 'should call #generate_session_token' do
      # allow(SecureRandom).to receive(:urlsafe_base64).
      # and_return("kBFxXPKOxhRdkBp7a1oHiw")
      expect(user).to receive(:generate_session_token).and_return("kBFxXPKOxhRdkBp7a1oHiw")
      user.reset_session_token!
    end

    it 'should reset the session_token' do
      old_token = user.session_token  

      expect(user.reset_session_token!).not_to eq(old_token)
    end
  end

  describe '#password=(password)' do
  # will this work?
    it 'should call create on BCrypt::Password' do 
      expect(BCrypt::Password).to receive(:create).with("123456")
      User.new({username: "user", password: "123456"})
    end

    it 'should set the password digest' do 
      expect(BCrypt::Password.new(user.password_digest).is_password?("123456")).to be true
    end
  end

  describe '#password' do
    it 'should return the password' do 
      expect(user.password).to eq("123456")
    end
  end

  describe '#is_password?(password)' do
    it 'should call new on BCrypt::Password' do 
      expect(BCrypt::Password).to receive(:new).with(user.password_digest).and_return(BCrypt::Password.new(user.password_digest))
      user.is_password?("123")
    end

    context 'password is the correct password' do
      it 'should return true' do 
        expect(BCrypt::Password.new(user.password_digest).is_password?("123456")).to be true
      end
    end

    context 'password is the incorrect password' do
      it 'should return false' do 
          expect(BCrypt::Password.new(user.password_digest).is_password?("123")).to be false
      end
    end 
  end
end
