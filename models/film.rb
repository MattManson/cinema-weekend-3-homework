require_relative('../db/sql_runner.rb')


class Film

  attr_accessor :id, :name, :price

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

end