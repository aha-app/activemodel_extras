# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-04-11

### Added
- Initial release with the following features:
  - `ActiveModel::Type::Array`: Type for handling arrays with properly typed elements
    - Supports all built-in ActiveModel types as element types
    - Supports custom types including nested models
  - `ActiveModel::Validations::ArrayValidator`: Apply any validator to each element in an array
    - Works with all built-in Rails validators (inclusion, numericality, etc.)
    - Supports custom validators
  - `ActiveModelExtra::NestedModel`: Module for using ActiveModel classes as attribute types
    - Automatic casting from hashes to model instances
    - Seamless integration with the array type for arrays of models
