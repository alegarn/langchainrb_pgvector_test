require 'bundler/setup'
Bundler.require(:default)
require 'dotenv'
Dotenv.load

class VectorDb
  attr_accessor :pgvector, :db_name, :k
  def initialize(llm:)
    @db_name = choose_db_name()
    url = db_url_from_credentials()
    @pgvector = launch_vdb(url, llm)
    @k = configure_k()
    vector_db_create_default_schema()
  end

  def get_pgvector
    @pgvector
  end

  def get_db_name
    @db_name
  end

  def get_k
    @k
  end

  def set_k(k)
    @k = k.to_i
  end

  def get_dimensions
    return @dimensions
  end

  def choose_db_name
    db_name = ""
    puts "Enter your database name. Default: pdf_reader_db"
    db_name = gets.chomp
    puts "Database name: #{db_name}"
    if db_name.empty?
      puts "Database name: pdf_reader_db"
      db_name = "pdf_reader_db"
      return db_name
    end
    return db_name
  end

  def db_url_from_credentials
    username = "postgres"
    password = "postgres"
    return url = "postgres://#{username}:#{password}@localhost:5432/#{@db_name}_vector"
  end

  def launch_vdb(url, llm)
    return Langchain::Vectorsearch::Pgvector.new(url: url, index_name: "Documents", llm: llm, namespace: nil)
  end

  def configure_k
    k = 1

    puts "Configuring k..."
    while true
      puts "Enter your k. (min: 1) Default: 1\n
      k is the number of nearest neighbors returned.\n
      If k is set to 1, only the most similar document is returned.\n
      Leave empty to use default\n
      Note: avoid letters or special characters to avoid errors"

      k = gets.chomp

      if k.empty?
        set_k(k)
        puts "k: #{@k}"
        return 1
      end

      if !(Numeric === k.to_i)
        puts "k is not a number."
      else
        puts "k is a number."
        puts "k: #{k}"
        return k.to_i
      end    
    end
  end

  # Add data to the database, paths is an array of strings
  def add_data
    system "clear"
    puts "Adding data to the database"
    puts "Paths is an array of strings: \n
    e.g. ['/path/to/file1.pdf'] just 1 path\n
    e.g. ['/path/to/file1.pdf', '/path/to/file2.pdf'] 2 paths\n
    Path is the absolute path to the file\n
    e.g. linux '/home/username/Documents/path/to/file.pdf'\
    e.g. windows 'C:\\Users\\username\\Documents\\path\\to\\file.pdf\n'
    e.g. macos '/Users/username/Documents/path/to/file.pdf'"

    paths = []
    loop do
      puts "\nPlease enter a file path (press Enter to confirm the choice), or enter 'done' to finish adding paths:"
      input = gets.chomp
      
      break if input.downcase == 'done'
      
      paths << Langchain.root.join(input)
    end
    puts "Paths: #{paths}"
    if paths.empty?
      puts "No paths added"
      return
    end

    puts "Adding data to the database..."
    @pgvector.add_data(paths: paths)
    puts "Data added to the database"
    system "clear"
  end

  def query(query:)
    @pgvector.query(query: query)
  end

  def similarity_search(query:, k:)
    @pgvector.similarity_search(query: query, k: k)
  end

  def vector_db_create_default_schema
    puts "Creating default schema: #{@pgvector}\n"
    @pgvector.create_default_schema
  end

  def delete_db
    puts "Delete database #{@db_name}"
    puts "What to do: "
    puts "use psql: \n
    1 - install psql: \n
    2 - write 'dropdb #{@db_name}' in the terminal to drop the database named #{@db_name}\n"
    puts "More infos: https://www.guru99.com/postgresql-drop-database.html"
  end

end

#pgvector.create_default_schema


#my_pdf = Langchain.root.join("/home/a/Documents/Projets/Langchain/langchainrb_pgvector_test/Files/Garnier_Alex_CV_Hôte.pdf")
#puts "PDF", my_pdf

#pgvector.add_data(paths: [my_pdf])
