require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    #query the database, get the first element (the array of columns)
    # and return them as symbols.
    @col ||= DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    SQL

    @col[0].map(&:to_sym)
  end

  def self.finalize!
    #iterate through every col symbol and establish getter and setting methods
    #but instead of variables, put them in an options hash (!?).
    #creates them but them don't work.
    #theres something to do with defining methods, and the correct scope.

    columns.each do |col|
      define_method(col) do
        attributes[col] #this is literally what goes inside of the method.
      end

      define_method("#{col}=") do |val|
        attributes[col] = val
      end
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= inspect.tableize
    @table_name
    # ...
  end

  def self.all
    # ...
    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    # ...
    results.map{|result| self.new(result)}
  end

  def self.find(id)
    # ...
    query = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      id = ?
    SQL
    return nil unless query.length > 0
    self.new(query.first)
  end

  def initialize(params = {})
    # ...
    #1. iterate each parameter and check if it's part of the attributes hash
    #2. set each attribute to the value from parameters.
    #Some how need to call columns from the class method.
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute \'#{attr_name}\'"
      end

      self.send("#{attr_name}=",value)
    end

  end

  def attributes
    # ...
    @attributes ||= Hash.new
    @attributes
  end

  def attribute_values
    # ...
    self.class.columns.inject([]) do |acc, attribute|
      acc << attributes[attribute]
      acc
    end
  end

  def insert # instance method, using class methods.
    # ...
    # byebug
    col_names = self.class.columns[1..-1].join(', ')
    insert_values = attribute_values[1..-1]
    question_marks = Array.new(attribute_values.length-1,'?').join(',')
    #I need to remove the id, part
    DBConnection.execute(<<-SQL, *insert_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
