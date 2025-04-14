# frozen_string_literal: true

module ActiveModelExtras
  # NestedModel provides support for nested model attributes in ActiveModel
  # This allows you to use ActiveModel classes as attribute types and have them
  # properly cast from hashes to model instances
  #
  # Example:
  #   class Address
  #     include ActiveModel::Model
  #     include ActiveModel::Attributes
  #     extend ActiveModelExtras::NestedModel
  #
  #     attribute :street, :string
  #     attribute :city, :string
  #   end
  #
  #   class User
  #     include ActiveModel::Model
  #     include ActiveModel::Attributes
  #
  #     attribute :name, :string
  #     attribute :address, Address
  #   end
  #
  #   user = User.new(name: 'John', address: { street: 'Main St', city: 'New York' })
  #   user.address # => #<Address street="Main St", city="New York">
  module NestedModel
    # Check if the given value is already a valid instance of this model
    # @param value [Object] The value to check
    # @return [Boolean] true if the value is already a valid instance
    def assert_valid_value(value)
      value.is_a?(self)
    end

    # Cast a value to an instance of this model
    # @param value [Object] The value to cast, typically a Hash of attributes
    # @return [Object] An instance of this model
    def cast(value)
      value.is_a?(self) ? value : new(value)
    end

    # Register this model as a type for ActiveModel attributes
    # This allows the model to be used directly as an attribute type
    # @example
    #   attribute :address, Address
    def inherited(subclass)
      super
      ActiveModel::Type.register(subclass.name.underscore.to_sym, subclass)
    end
  end
end
