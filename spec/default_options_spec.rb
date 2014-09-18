require 'spec_helper'

module Namespace
end

describe "PaperclipDatabase" do
  describe "default options" do
    before(:context) do
      create_model_tables :users, :avatars
      build_model 'User', nil, :avatar, {}

      @model = User.new
      file = File.open(fixture_file('5k.png'))

      @model.avatar = file
      @model.save

    end

    after(:context) do
      reset_activerecord
      reset_database :users, :avatars
    end

    it "has backward compatible table name" do
      expect(@model.avatar.instance_variable_get(:@database_table)).to eq 'avatars'
    end

    it "detects no namespace" do
      expect(@model.avatar.instance_variable_get(:@paperclip_class_module)).to eq Object
    end

    it "has association name" do
      expect(@model.avatar.instance_variable_get(:@paperclip_files_association_name)).to eq 'user_avatar_paperclip_files'
    end

    it "has model constant" do
      expect(@model.avatar.instance_variable_get(:@paperclip_file_model).to_s).to eq 'UserAvatarPaperclipFile'
    end

    it "has association" do
      expect(@model.methods.include?(:user_avatar_paperclip_files)).to be_truthy
    end
  end
  describe "Namespaced model" do
    describe "default options" do
      before(:context) do
        create_model_tables :users, :avatars
        build_model 'Namespace::User', nil, :avatar, {}

        @model = Namespace::User.new
        file = File.open(fixture_file('5k.png'))

        @model.avatar = file
        @model.save
      end
      after(:context) do
        reset_activerecord
        reset_database :users, :avatars
      end

      it "has backward compatible table name" do
        expect(@model.avatar.instance_variable_get(:@database_table)).to eq 'avatars'
      end

      it "detects namespace" do
        expect(@model.avatar.instance_variable_get(:@paperclip_class_module)).to eq Namespace
      end

      it "has association name" do
        expect(@model.avatar.instance_variable_get(:@paperclip_files_association_name)).to eq 'user_avatar_paperclip_files'
      end

      it "has model constant" do
        expect(@model.avatar.instance_variable_get(:@paperclip_file_model).to_s).to eq 'Namespace::UserAvatarPaperclipFile'
      end

      it "has association" do
        expect(@model.methods.include?(:user_avatar_paperclip_files)).to be_truthy
      end
    end
  end
end