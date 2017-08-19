require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'
# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
    @class_name.constantize
  end

  def table_name
    # ...
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # ...provide the default options to the user.
    @class_name = options[:class_name]   || name.camelcase
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{name}Id".underscore.to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    # ...
    @class_name = options[:class_name]   || name.singularize.camelcase
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{self_class_name}Id".underscore.to_sym
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
    the_options = BelongsToOptions.new(name.to_s, options)
    # byebug
    # byebug
    define_method(name) do
      foreign_key = the_options.send(:foreign_key)
      primary_key = the_options.send(:primary_key)

      query = the_options.model_class.where(primary_key => attributes[foreign_key])
      return nil unless query.length > 0
      query.first
    end
  end

  def has_many(name, options = {})
    the_options = HasManyOptions.new(name.to_s, options)
    # byebug
    # byebug
    define_method(name) do
      foreign_key = the_options.send(:foreign_key)
      primary_key = the_options.send(:primary_key)

      query = the_options.model_class.where(primary_key => attributes[foreign_key])
      return nil unless query.length > 0
      query
    end
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
