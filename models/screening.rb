require_relative('../db/sql_runner.rb')

class  Screening

  attr_accessor :id, :datetime, :film_id

  def initialize (options)
    @id = options['id'].to_i
    @film_id = options['film_id'].to_i
    @start_time = options['start_time']
    @empty_seats = options['empty_seats'].to_i
  end

  def save()
    sql = "INSERT INTO screenings ( film_id, start_time, empty_seats ) VALUES( $1, $2, $3) RETURNING id"
    values = [@film_id, @start_time, @empty_seats]
    result = SqlRunner.run( sql, values )[0]
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


end
