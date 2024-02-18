require 'bundler/setup'
Bundler.require(:default)
Dotenv.load

class LlmModel
  attr_accessor :llm, :temperature, :chat_completion_model_name, :dimensions
  def initialize
    @temperature = 0.0
    @chat_completion_model_name = "gpt-3.5-turbo"
    @dimensions = 1536
    @llm = configure_llm()
  end

  def get_llm
    return @llm
  end

  def get_temperature
    return @temperature
  end

  def get_dimensions
    return @dimensions
  end

  def get_completion_model_name
    return @chat_completion_model_name
  end

  def ask_confirmation_to_continue

    puts "Do you want to continue? (y/n)"
    input = gets.chomp
    if input == "y"
      return true
    else
      return false
    end
  
  end

  def choose_temperature
    answer = false
    temperature = "0.0"

    while answer == false
      puts "Enter your temperature as float (min: '0.0', max: '1.0')\n
      Default: 0.0\n
      Leave empty to use default\n
      Note: avoid letters or special characters to avoid errors"
      temperature = (gets.chomp)

      if temperature.empty?
        puts "Temperature: 0.0"
        answer = ask_confirmation_to_continue
        return temperature.to_f if answer
      end

      puts "Temperature: #{temperature}"

      answer = ask_confirmation_to_continue
      break if answer
    end

    return temperature.to_f
  end

  def choose_model
    answer = false
    chat_completion_model_name = "gpt-3.5-turbo"
    while answer == false
      puts "Enter your model. Default: gpt-3.5-turbo"
      puts "Note: cheaper models have 'turbo' in their name"
      puts "Choices: 
        1 - gpt-3.5-turbo (16,385 tokens context)\n
        2 - gpt-3.5-turbo-0125 (16,385 tokens context)\n
        3 - gpt-4-turbo-preview (128,000 tokens context)\n
        4 - gpt-4-0125-preview (128,000 tokens context)"

      chat_completion_model_choice = (gets.chomp)

      case chat_completion_model_choice
        when "1"
          chat_completion_model_name = "gpt-3.5-turbo"
        when "2"
          chat_completion_model_name = "gpt-3.5-turbo-0125"
        when "3"
          chat_completion_model_name = "gpt-4-turbo-preview"
        when "4"
          chat_completion_model_name = "gpt-4-0125-preview"
        else 
          puts "Invalid choice. Please try again."
      end

      puts "Model: #{chat_completion_model_name}"

      answer = ask_confirmation_to_continue
      break if answer
    end
    return chat_completion_model_name
  end

  def choose_dimensions
    answer = false
    dimensions = 1536
    while answer == false
      puts "Enter your dimension as integer ('0', '1536', ...) \n
      Note: avoid letters or special characters to avoid errors \n
      Default: 1536 \n
      Leave empty to use default"
      dimensions = gets.chomp

      if dimensions.empty?
        puts "Dimensions: 1536"
        dimensions = 1536
      end

      if !dimensions.empty?
        puts "Dimensions: #{dimensions}"
      end

      answer = ask_confirmation_to_continue
      break if answer
    end
    return dimensions.to_i
  end

  def configure_llm
    puts "Configuring LLM..."
    puts "Default values: \n
    Temperature: 0.0 \n
    Model: gpt-3.5-turbo \n
    Dimension: 1536"
    puts "Do you want to change these values? (y/n)\n"
    input = gets.chomp

    if input == "y"
      @temperature = choose_temperature
      @chat_completion_model_name = choose_model
      @dimensions = choose_dimensions
      llm = Langchain::LLM::OpenAI.new(
        api_key: ENV["OPENAI_API_KEY"], 
        llm_options: { 
          temperature: @temperature, 
          chat_completion_model_name: @chat_completion_model_name, 
          dimension: @dimensions, 
          embeddings_model_name: "text-embedding-3-small"
        }
      )
    else
      llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
    end
    return llm
  end

end