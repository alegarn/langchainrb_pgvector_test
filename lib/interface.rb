require 'bundler/setup'
Bundler.require(:default)
require 'dotenv'
Dotenv.load
require 'model'
require 'vectordb'

class Interface
  
  def initialize(llm, pgvector, thread)
      @llm = llm
      @pgvector = pgvector
      @thread = thread
      @assistant = start_assistant()
      launch_interface()
  end

  def start_assistant
    Langchain::Assistant.new(
      llm: @llm.get_llm,
      thread: @thread
    )
  end

  def launch_interface
    loop do
      puts "********************************************************"
      puts "Welcome to the PDF Reader Assistant!"
      puts "1 - Enter a pdf file path to add it to the database"
      puts "2 - Query the database"
      puts "3 - Parameters: \n
      k = #{@pgvector.get_k}, \n
      model: #{@llm.get_completion_model_name}, \n
      dimension: #{@llm.get_dimensions}"
      puts "4 - Exit"
      puts "5 - Delete database"
      puts "Enter your choice: \n"
      choice = gets.chomp
      puts "********************************************************"
      case choice
        when "1"
          @pgvector.add_data()
        when "2"
          query_loop()
        when "3"
          puts "Parameters"
          puts "k = #{@pgvector.get_k} nearest neighbors returned"
          puts "model: #{@llm.get_llm} model used to generate answers"
          puts "Write a new k: "
          k = gets.chomp
          puts "Your new k is: #{k}"
          @pgvector.set_k(k)
        when "4"
          puts "Goodbye!"
          exit
        when "5"
          @pgvector.delete_db
        else
          puts "Invalid choice. Please try again."
          launch_interface
      end
    end
  end

  def query_loop
    while true
      puts "____________________________________________________"
      puts "Enter your query: \n
      e.g. 'What is ... in the pdf file?'\n
      Type: \n"
      user_input = gets.chomp  
      search = @pgvector.similarity_search(
        query: user_input,
        k: @pgvector.get_k
      )
      content = search[1].content
      prompt = "Context: \n
            #{content}\n
            Query: \n
            #{user_input}\n
            Answer: "
      @assistant.add_message(content: (prompt), role: "user")
      @assistant.run
      
      puts "Assistant's Response: #{@assistant.thread.messages.last.content}"

      puts "Do you want to continue? ('n' to stop)"
      puts "____________________________________________________"
      answer = gets.chomp
      return if answer == "n"
    end
  end
end