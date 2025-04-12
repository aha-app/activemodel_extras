# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveModel::Validations::ArrayValidator do
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :tags, :array, of: :string
    attribute :numbers, :array, of: :integer
    attribute :custom_validated, :array, of: :string

    validates :tags, array: { inclusion: { in: %w[ruby rails js] } }, allow_blank: true
    validates :numbers, array: { numericality: { greater_than: 0 } }, allow_blank: true
    validates :custom_validated, array: { custom: true }, allow_blank: true
  end

  # Custom validator for testing
  class CustomValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add(attribute, "is not valid") unless value == "valid"
    end
  end

  subject(:model) { TestModel.new }

  describe "inclusion validation" do
    it "is valid when all array elements are included in the specified values" do
      model.tags = %w[ruby rails]
      expect(model).to be_valid
    end

    it "is invalid when any array element is not included in the specified values" do
      model.tags = %w[ruby invalid]
      expect(model).not_to be_valid
      expect(model.errors[:tags]).to include("is not included in the list")
    end

    it "is valid when the array is empty" do
      model.tags = []
      expect(model).to be_valid
    end

    it "is valid when the array is nil" do
      model.tags = nil
      expect(model).to be_valid
    end
  end

  describe "numericality validation" do
    it "is valid when all numbers meet the condition" do
      model.numbers = [1, 2, 3]
      expect(model).to be_valid
    end

    it "is invalid when any number fails the condition" do
      model.numbers = [1, 0, 3]
      expect(model).not_to be_valid
      expect(model.errors[:numbers]).to include("must be greater than 0")
    end
  end

  describe "custom validator" do
    it "applies the custom validator to each element" do
      model.custom_validated = ["valid", "invalid"]
      expect(model).not_to be_valid
      expect(model.errors[:custom_validated]).to include("is not valid")
    end

    it "is valid when all elements pass the custom validation" do
      model.custom_validated = ["valid", "valid"]
      expect(model).to be_valid
    end
  end

  describe "handling of non-array values" do
    it "wraps non-array values in an array before validation" do
      model.tags = "ruby"
      expect(model).to be_valid
    end
  end
end
