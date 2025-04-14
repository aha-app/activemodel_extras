# ActiveModel Extra

ActiveModel Extra provides powerful extensions to ActiveModel that fill common gaps in Rails' built-in functionality:

- **Array Type**: Handle arrays with properly typed elements (strings, integers, custom models, etc.)
- **Nested Model Support**: Use ActiveModel classes as attribute types with automatic casting from hashes
- **Array Validator**: Apply any ActiveModel validator to each element in an array

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activemodel-extra'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install activemodel-extra
```

## Usage

### Array Type

The `Array` type allows you to specify a subtype for array elements, ensuring all elements are properly cast to the expected type:

```ruby
class Product
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :tags, :array, of: :string
  attribute :prices, :array, of: :decimal
  attribute :quantities, :array, of: :integer
end

product = Product.new(
  name: 'Widget', 
  tags: ['sale', 'new'], 
  prices: ['10.99', '9.99'],
  quantities: ['5', 10, nil]
)

product.tags       # => ["sale", "new"]
product.prices     # => [#<BigDecimal:10.99>, #<BigDecimal:9.99>]
product.quantities # => [5, 10, 0]  # Note: nil cast to 0 for integer type
```

### Nested Model Support

The `NestedModel` module allows you to use ActiveModel classes as attribute types with automatic casting from hashes to model instances:

```ruby
class Address
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModelExtra::NestedModel

  attribute :street, :string
  attribute :city, :string
  attribute :zip, :string
end

class User
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :address, Address
  attribute :previous_addresses, :array, of: Address  # Array of nested models!
end

user = User.new(
  name: 'John', 
  address: { street: 'Main St', city: 'New York', zip: '10001' },
  previous_addresses: [
    { street: '123 Oak Ave', city: 'Boston', zip: '02108' },
    { street: '456 Pine St', city: 'Chicago', zip: '60601' }
  ]
)

user.address.city  # => "New York"
user.previous_addresses[0].city  # => "Boston"
user.previous_addresses[1].zip   # => "60601"
```

### Array Validator

The `ArrayValidator` allows you to apply any ActiveModel validator to each element in an array:

```ruby
class Survey
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :responses, :array, of: :string
  attribute :ratings, :array, of: :integer
  
  # Validate each response is one of the allowed values
  validates :responses, 
            array: { inclusion: { in: %w[yes no maybe] } }, 
            allow_blank: true
            
  # Validate each rating is between 1 and 5
  validates :ratings,
            array: { numericality: { greater_than: 0, less_than_or_equal_to: 5 } },
            allow_blank: true
end

survey = Survey.new(
  responses: ['yes', 'invalid', 'no'],
  ratings: [5, 3, 0, 4]
)

survey.valid?  # => false
survey.errors.full_messages  
# => ["Responses is not included in the list", "Ratings must be greater than 0"]
```

### Combining Features

All these features work together seamlessly:

```ruby
class Comment
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend ActiveModelExtra::NestedModel
  
  attribute :text, :string
  attribute :rating, :integer
  
  validates :text, presence: true
  validates :rating, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
end

class BlogPost
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  
  attribute :title, :string
  attribute :comments, :array, of: Comment
  
  validates :title, presence: true
  validates :comments, array: { custom: true }
  
  # Custom validator that uses the model's own validation
  class CustomValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value.valid?
        record.errors.add(attribute, "contains invalid #{value.class.name.downcase}")
      end
    end
  end
end

post = BlogPost.new(
  title: "My Blog Post",
  comments: [
    { text: "Great post!", rating: 5 },
    { text: "", rating: 0 }  # Invalid comment
  ]
)

post.valid?  # => false
post.errors.full_messages  # => ["Comments contains invalid comment"]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aha-app/activemodel-extra.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
