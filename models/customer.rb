require_relative('../db/sql_runner.rb')
require_relative('ticket')
require_relative('film')
require_relative('screening')

class Customer

  attr_accessor :name, :wallet
  attr_reader :id

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

  def update
    sql = 'UPDATE customers SET (name, funds) =  ($1, $2) WHERE id = $3'
    values =[@name, @funds, @id]
    SqlRunner.run( sql, values )
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def films_cust_gonna_see
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql, values)
    result = films.map { |film| Film.new( film ) }
    return result
  end

  def deduct_money(screening)
    sql = "SELECT films.price FROM films WHERE films.id = $1"
    values = [screening.film_id]
    result = SqlRunner.run(sql, values)[0]['price'].to_i
    @funds -= result
    update()
  end


  def buy_ticket(screening)
    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2)"
    values = [@id, screening.film_id.to_i]
    SqlRunner.run(sql, values)
    deduct_money(screening)
  end

  def tickets_bought
    sql = "SELECT tickets.* FROM tickets WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.count
  end

end
