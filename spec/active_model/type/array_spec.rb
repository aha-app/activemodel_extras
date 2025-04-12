# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveModel::Type::Array do
  describe "#cast" do
    context "with string subtype" do
      subject(:type) { described_class.new(of: :string) }

      it "casts nil to empty array" do
        expect(type.cast(nil)).to eq([])
      end

      it "casts a single value to an array with one element" do
        expect(type.cast("hello")).to eq(["hello"])
      end

      it "casts each element in the array to the subtype" do
        expect(type.cast([1, 2, 3])).to eq(["1", "2", "3"])
      end
    end

    context "with integer subtype" do
      subject(:type) { described_class.new(of: :integer) }

      it "casts string numbers to integers" do
        expect(type.cast(["1", "2", "3"])).to eq([1, 2, 3])
      end
    end

    context "with custom subtype" do
      let(:point_class) do
        Class.new do
          def self.cast(value)
            if value.is_a?(Hash)
              { x: value[:x].to_i, y: value[:y].to_i }
            else
              value
            end
          end
        end
      end

      subject(:type) { described_class.new(of: point_class) }

      it "uses the custom type's cast method" do
        result = type.cast([{ x: "1", y: "2" }, { x: 3, y: 4 }])
        expect(result).to eq([{ x: 1, y: 2 }, { x: 3, y: 4 }])
      end
    end
  end

  describe "#serialize" do
    context "with string subtype" do
      subject(:type) { described_class.new(of: :string) }

      it "serializes each element using the subtype serializer" do
        expect(type.serialize([1, 2, 3])).to eq(["1", "2", "3"])
      end
    end

    context "with custom subtype" do
      let(:point_class) do
        Class.new do
          def self.cast(value)
            value
          end

          def self.serialize(value)
            "#{value[:x]},#{value[:y]}"
          end
        end
      end

      subject(:type) { described_class.new(of: point_class) }

      it "uses the custom type's serialize method" do
        result = type.serialize([{ x: 1, y: 2 }, { x: 3, y: 4 }])
        expect(result).to eq(["1,2", "3,4"])
      end
    end
  end

  describe "registration" do
    it "is registered as :array type" do
      expect(ActiveModel::Type.lookup(:array)).to be_a(described_class)
    end

    it "accepts the 'of' option" do
      type = ActiveModel::Type.lookup(:array, of: :integer)
      expect(type.subtype).to be_a(ActiveModel::Type::Integer)
    end
  end
end
