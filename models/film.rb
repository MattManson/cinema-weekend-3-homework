require_relative('../db/sql_runner.rb')
require_relative('ticket')
require_relative('customer')
require_relative('screening')


class Film

  attr_accessor :name, :price
  attr_reader :id

  def initialize (options)
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end


  def save()
    sql = "INSERT INTO films ( title, price ) VALUES( $1, $2) RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run( sql,values ).first
    @id = result['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    visits = SqlRunner.run(sql, values)
    result = visits.map { |film| Film.new( film ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE films
    SET (title, price) = ($1, $2)
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql,values)
  end

  def customers_gonna_see_it
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE tickets.film_id = $1"
    values = [@id]
    people = SqlRunner.run(sql, values)
    result = people.map { |person| Customer.new( person ) }
    return result
  end

  def customers_coming
    sql = "SELECT tickets.* FROM tickets WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.count
  end

end
