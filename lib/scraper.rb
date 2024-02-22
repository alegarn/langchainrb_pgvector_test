require 'bundler/setup'
Bundler.require(:default)


class Scraper
  include HTTParty
  include Nokogiri

  # general scraper

  # save doc scraper
    # send the text + link
    # follow ? 
      

  # headless scroll
    # spidr ?
      # https://github.com/postmodern/spidr
    # How to scroll to an element in Ruby and Selenium
      # https://stackoverflow.com/questions/55403469/how-to-scroll-to-an-element-in-ruby-and-selenium
    # selenium scroll element into (center of) view
      # https://stackoverflow.com/questions/20167544/selenium-scroll-element-into-center-of-view
    
  # heavy js (has all content)?
    # no -> next
    # yes -> activate some trigger
    
  # page_text_all = mouse "select all"
    # retrieve html tags + css
    # write summary
    # markdown

  # Scrape only visible elements with Nokogiri
    # https://stackoverflow.com/questions/31428731/scrape-only-visible-elements-with-nokogiri
  # Scrape all visible text from a web page
    # https://stackoverflow.com/questions/26779088/scrape-all-visible-text-from-a-web-page
  
  # https://brightdata.com/blog/how-tos/web-scraping-with-ruby
      # Web Scraping with Ruby: Complete Guide
    
  # summary structure
    # all tags
    # all text 
    # https://github.com/rgrove/sanitize
    # It removes all HTML and/or CSS from a string except the elements, attributes, and properties you choose to allow.
    # if not
      # with css

  #      

  #medium
  # enter in db
  # with part infos
  # a special id (domain / title / author / ...)


  def initialize
    @scraper = nil
    @text_treatment = nil
    interface()
  end

  def interface
    system "clear"
    puts "Page Scraper"
    puts "Enter your link: "
    link = gets.chomp
    puts "Link: #{link}"
    visit_page(link)
  end


  def is_Ssr(script)
    is_ssr = script.text.include?("ssr")
    is_ssr = script.text.include?("SSR")
    return is_ssr
  end

  def search_if_important_javascript(scripts)
    length = scripts.length
    scripts.map do |script|

    end
  end

  def visit_medium_article(link, response)
    puts "visit_medium_article"

    html = Nokogiri::HTML(response.body)
    scripts = html.xpath("//script")
    search_if_important_javascript(scripts)

    binding.pry

    title = html.xpath("//h1").text
    puts "title: #{title}"


    sub_title = html.xpath("//h2").text
    sub_sub_title = html.xpath("//h3").text
    paragraphes = html.xpath("//p")
    # <script>window.__APOLLO_STATE__ 
    #"Paragraph:a04f891b8042_1":{"__typename":"Paragraph","id":"a04f891b8042_1","name":"109f","type":"H4","href":null,"layout":null,"metadata":null,"text":"Why is K-Nearest Neighbors one of the most popular machine-learning algorithms? Let’s understand it by diving into its math, and building it from scratch.","hasDropCap":null,"dropCapImage":null,"markups":[],"codeBlockMetadata":null,"iframe":null,"mixtapeMetadata":null},"ImageMetadata:0*AGPTGho6P9vJFvUh":{"__typename":"ImageMetadata","id":"0*AGPTGho6P9vJFvUh","originalHeight":1024,"originalWidth":1792,"focusPercentX":null,"focusPercentY":null,"alt":null}
    # "ImageMetadata:
    puts "sub_title: #{sub_title}"
    puts "sub_sub_title: #{sub_sub_title}"
    puts "paragraphes: #{paragraphes}"


    def extract_paragraphs(str)
      content = []
      
      while str =~ /"__typename":"Paragraph".*?"type":"(.*?)".*?"text":"(.*?)"/m
        type = $1
        text = $2
        
        content << { type: type, text: text }
        
        str = $'
      end
      
      content
    end

    
    # paragraphes
    s = (scripts[5]).to_s
    content = []
    s_length = s.length

    (s.split(',"Paragraph:')).each_with_index do |paragraphe, index|
      next if index == 0
      break if index == s_length
      prg = extract_paragraphs(paragraphe)
      content << prg
    end
    puts content
    
    # markdown
    markdown_text = ""
    summary = ""
    content << [{ type: "H1", text: title }]
    content << [{ type: "H2", text: sub_title }]

    content.each do |element|
      type = element[0][:type]
      text = element[0][:text]

      # build a markdown article from the content
      case type
      when "H1"
        markdown_text << "# #{text}\n\n"
        summary << "# #{text}\n\n"
      when "H2"
        markdown_text << "## #{text}\n\n"
        summary << "## #{text}\n\n"
      when "H3"
        markdown_text << "### #{text}\n\n"
        summary << "### #{text}\n\n"
      when "H4"
        markdown_text << "#### #{text}\n\n"
        summary << "#### #{text}\n\n"
      when "IMG"
        markdown_text << "![#{text}](image_url_here)\n\n"
      when "P"
        markdown_text << "#{text}\n\n"
      when "BG"
        markdown_text << "> #{text}\n\n"
      end

    end

    puts markdown_text
    puts summary
    


    binding.pry
    

  end

  def visit_page(link)

    link_without_spaces = link.gsub(/\s+/, '')
    response = HTTParty.get(link_without_spaces)

    is_medium = link.include?("medium.com")
    visit_medium_article(link, response) if is_medium

    puts "response, #{response.class}"
    

    html = Nokogiri::HTML(response.body)
    scripts = html.xpath("//script")
    search_if_important_javascript(scripts)
    binding.pry

    # link
    # 
    # page_type
      # no js ?
      # Spidr / Crawler nokogiri
      # many js ?
        # important text inside?
          # selenium-webdriver
  end

  def text_treatment
    # TextTreatment.new
    #   .get_sumary
    #   .get_headlines
    #   .get_paragraphs
    #   .get_tokens

    # chunker
    #   .get_chunks

    # add infos(id, date, title, section)
    # chunker
    #   .get_chunks (new text size)
    #   .add_infos
    # 
    # 
  end
end