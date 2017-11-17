require_relative('../db/sql_runner.rb')


class Customer

  attr_accessor :id, :name, :wallet

def initialize (options)
  @id = options['id'].to_i
  @name = options['name']
  @funds = options['funds'].to_i
end

def save()
  sql = "INSERT INTO customers ( name, funds ) VALUES( $1, $2) RETURNING id"
  values = [@name, @funds]
  visit = SqlRunner.run( sql,values ).first
  @id = visit['id'].to_i
end

def self.all()
  sql = "SELECT * FROM customers"
  values = []
  visits = SqlRunner.run(sql, values)
  result = visits.map { |customer| Customer.new( customer ) }
  return result
end

def self.delete_all()
  sql = "DELETE FROM customers"
  values = []
  SqlRunner.run(sql, values)
end




end
