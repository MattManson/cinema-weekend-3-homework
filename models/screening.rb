require_relative('../db/sql_runner.rb')
require_relative('customer')
require_relative('film')
require_relative('ticket')

class  Screening

  attr_accessor :datetime, :film_id
  attr_reader :id

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


  def update
    sql = "UPDATE screenings SET (film_id, start_time, empty_seats) = ($1, $2, $3) WHERE id = $4"
    values = [@film_id, @start_time, @empty_seats, @id]
    SqlRunner.run(sql,values)
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    screenins = SqlRunner.run(sql, values)
    result = screenings.map { |film| Film.new( film ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.most_popular
    sql = "SELECT films.title, COUNT(films.id) AS most_frequent
    FROM films
    JOIN tickets
    ON films.id = tickets.film_id
    GROUP BY films.id
    ORDER BY COUNT(films.id) DESC"
    values = []
    result = SqlRunner.run(sql, values)
    return result.map { |film| Film.new( film ) }[0]
  end

end
