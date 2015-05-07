class PgDump

  def initialize(connection_class, output_path)
    @db = connection_class.connection_config[:database]
    @output_path = output_path
  end

  # 
  # Dumps data from the the database into the file at path `@output_path`,
  # overwriting it if it already exists. 
  # 
  def dump
    `pg_dump #{@db} --clean --no-owner > #{@output_path}`
  end

  # 
  # Load data from `@output_path` into the provided database.
  def load
    `psql #{@db} < #{@output_path}`
  end

  private
end