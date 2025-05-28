# frozen_string_literal: true

module ActiveModel
  module Validations
    # ArrayValidator allows validating each element of an array against specified validation rules.
    #
    # Usage example:
    #   validates :fields, array: { inclusion: { in: %i[id reference_num name] } }, allow_blank: true
    #
    # The above example validates that each value in the 'fields' array is one of: 'id', 'reference_num', or 'name'.
    # The 'allow_blank: true' option skips validation if the array is empty or nil.
    class ArrayValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, values)
        Array(values).each do |value|
          # For each validator option provided (excluding Rails validation control options)
          options.except(*%i[if unless on allow_nil allow_blank strict]).each do |validator_type, options|
            validator = build_validator(validator_type, options)
            # Apply the validator to the individual element
            validator.validate_each(record, attribute, value)
          end
        end
      end

      private

      # Dynamically builds a validator instance based on the validator type
      # @param type [Symbol] The type of validator to build (e.g., :inclusion, :email)
      # @param options [Hash] Arguments to pass to the validator
      # @return [ActiveModel::EachValidator] The instantiated validator
      def build_validator(type, options)
        # First, try to find the validator in the global namespace
        # e.g., 'email' becomes 'EmailValidator'
        validator = "#{type.to_s.camelize}Validator".safe_constantize

        # If not found, try the ActiveModel::Validations namespace
        # e.g., 'ActiveModel::Validations::InclusionValidator'
        validator ||= "ActiveModel::Validations::#{type.to_s.camelize}Validator".constantize

        validator.new(_parse_validates_options(options).merge(attributes: attributes))
      end

      def _parse_validates_options(options)
        case options
        when TrueClass
          {}
        when Hash
          options
        when Range, Array
          { in: options }
        else
          { with: options }
        end
      end
    end
  end
end
