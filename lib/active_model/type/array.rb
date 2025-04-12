# frozen_string_literal: true

module ActiveModel
  module Type
    # Array type for ActiveModel that supports casting array elements to a specified subtype
    #
    # Example:
    #   attribute :tags, :array, of: :string
    #   attribute :points, :array, of: :integer
    #   attribute :users, :array, of: User
    #
    class Array < ActiveModel::Type::Value
      attr_reader :subtype

      def initialize(**args)
        type = args.delete(:of)
        @subtype = type.is_a?(Symbol) ? ActiveModel::Type.lookup(type) : type
        super
      end

      def type
        :array
      end

      def cast(value)
        Array(value).map { |v| @subtype.cast(v) }
      end

      def serialize(value)
        Array(value).map { |v| @subtype.serialize(v) }
      end
    end

    # Register the array type for use with ActiveModel attributes
    register(:array, Array)
  end
end
