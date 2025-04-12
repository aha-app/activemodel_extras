# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActivemodelExtra::NestedModel do
  # Define test classes
  class Address
    include ActiveModel::Model
    include ActiveModel::Attributes
    extend ActivemodelExtra::NestedModel

    attribute :street, :string
    attribute :city, :string
    attribute :zip, :string
  end

  class User
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :address, Address
    attribute :previous_addresses, :array, of: Address
  end

  describe ".cast" do
    it "returns the value if it's already an instance of the model" do
      address = Address.new(street: "123 Main St", city: "Anytown")
      expect(Address.cast(address)).to eq(address)
    end

    it "creates a new instance from a hash" do
      address = Address.cast({ street: "123 Main St", city: "Anytown" })
      expect(address).to be_a(Address)
      expect(address.street).to eq("123 Main St")
      expect(address.city).to eq("Anytown")
    end

    it "handles nil values" do
      expect(Address.cast(nil)).to be_a(Address)
    end
  end

  describe ".assert_valid_value" do
    it "returns true for instances of the model" do
      address = Address.new
      expect(Address.assert_valid_value(address)).to be true
    end

    it "returns false for other values" do
      expect(Address.assert_valid_value("not an address")).to be false
      expect(Address.assert_valid_value({ street: "123 Main St" })).to be false
    end
  end

  describe "integration with ActiveModel::Attributes" do
    it "casts nested model attributes" do
      user = User.new(name: "John", address: { street: "123 Main St", city: "Anytown" })
      expect(user.address).to be_a(Address)
      expect(user.address.street).to eq("123 Main St")
    end

    it "casts arrays of nested models" do
      user = User.new(
        previous_addresses: [
          { street: "123 Main St", city: "Anytown" },
          { street: "456 Oak Ave", city: "Othertown" }
        ]
      )

      expect(user.previous_addresses.size).to eq(2)
      expect(user.previous_addresses.all? { |addr| addr.is_a?(Address) }).to be true
      expect(user.previous_addresses[0].street).to eq("123 Main St")
      expect(user.previous_addresses[1].city).to eq("Othertown")
    end
  end
end
