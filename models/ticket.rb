require_relative('../db/sql_runner.rb')

class Ticket

  attr_accessor :id, :customer_id, :film_id

  def initialize (options)
    @id = options['id'].to_i if options['id'].to_i
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets ( film_id, customer_id ) VALUES( $1, $2) RETURNING *"
    values = [@film_id, @customer_id]
    result = SqlRunner.run( sql, values )[0]
    @id = result['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    values = []
    visits = SqlRunner.run(sql, values)
    result = visits.map { |ticket| Ticket.new( ticket ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    values = []
    SqlRunner.run(sql, values)
  end

end
