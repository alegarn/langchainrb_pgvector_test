require 'bundler/setup'
Bundler.require(:default)

require 'interface'
require 'vectordb'
require 'model'

class Initialize 
  def initialize 
    puts "Initializing..."
    @llm = LlmModel.new()
    puts "LLM: #{@llm.get_llm}"
    @pgvector = VectorDb.new(llm: @llm.get_llm)
    puts "PGVector: #{@pgvector.get_db_name}"
    @thread = Langchain::Thread.new

    launch_interface()
  end

  def launch_interface
    puts "Welcome to the PDF Reader Assistant!"
    Interface.new(@llm, @pgvector, @thread)
  end

end
