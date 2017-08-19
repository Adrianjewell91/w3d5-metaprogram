require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    # ...
    # assume I have all of the methods available from SQl object.
    #this is a class method, not an instance method.
    #I'm so grateful for my renewed health .

    #return the array of results. Its like ::all but with a constraint.
    where_line = params.keys.map{|key| "#{key} = ?"}.join(' AND ')
    the_values = params.values

    results = DBConnection.execute(<<-SQL,*the_values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where_line}
    SQL

    parse_all(results)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
