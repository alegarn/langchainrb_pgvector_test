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

  def visit_article(link)
    puts "visit_article"
    driver = Selenium::WebDriver.for :chrome
    driver.get(link)
    driver.manage.timeouts.implicit_wait = 500 #[250..500]


    binding.pry
    #html fetch detection
      # scroll down, wait / select footer, wait
      # if none scroll down last child


    # footer
    footer = driver.find_elements(tag_name: 'footer')
    #wait x seconds
      # footer = nil ? find class footer / id footer / body last child, little wait, try again 
      # footer = driver.find_elements(tag_name: 'body').child.last ? scroll down

    
    # if none scroll down
    driver.action
          .scroll_to(footer)
          .perform

    driver.manage.timeouts.implicit_wait = 500

    # save the text with everithing in order (human visible text only)       
    full_text = driver.find_element(tag_name: "body").text
    
    #body html (article's hierarchy)
    html = driver.find_element(tag_name: "body").attribute("innerHTML")
    # nokogiri html (article's hierarchy)
    html_noko = Nokogiri::HTML(html)
    # nokogiri html + css
    
    binding.pry
    
    # get the titles/texts human visible order with full_text
      # from full_text build a new array containing all lines with like: ["line1", "line2", "line3", ..., "lineN"]
    # create a html tree with only the tags containing one line of texts in full_text
      # <html_tag>line1</html_tag> : add in the tree
      # what is the hierarchy of the titles: ["h1", "h2", "h3", "h4", "h5", "h6", "strong"]
      # page_tree = {"title" => {"tag" => "h1", "text" => "line1", children: {"h2" => "line2", ...} ...}

    # Extract titles/texts in human visible order from full_text
    titles_texts = full_text.scan(/<h[1-6]>.*?<\/h[1-6]>/)

    # Create a HTML tree with tags containing all texts in full_text
    html_tree = ""
    titles_texts.each do |title_text|
      html_tree << title_text
    end



    # use nokogiri to add the tags html hierarchy,  with full_text strings to get

    # order the tree 
      # for each paragraph (= the text bewteen a title and the next one, or the end of the body) 
        # 1: get all the "sections titles" (h1, h2, h3, h4, h5, h6) above it in the tree (hierarchy, just the first h1, h2, etc... )
          # until page title
        # 2: link + author
        # 3: date + link = uuid
        # 4: titles
        # infos = 1 + 2 + 3 + 4
        # infos = ***INFOS***url: "...", author: "...", date: "...", uuid: "...", titles: "my h1/my h2/my h3"***INFOS***
        # 
      # chunk = infos + paragraph
      # example: 
      # <h1>title</h1>
      # <p>text 1 </p>
      # <h2>title </h2>
      # <p>text 2</p>
      # chunk1 = infos(link + author + date + uuid + <h1>title) + paragraph(text 1)
      # chunk2 = infos(link + author + date + uuid + <h1>title+<h2>title) + paragraph(text 2)

    # if the text is in the full_text, get the text, compare it with the text in html_noko

    
    # if title / text / title
      # 
    

    # write the multiple chunks with order
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # to save infos/paragraphes
      # chunk = paragraphe + ({} : all "sections titles" above + uuid + link + author)
      # 
      # client.add_texts(texts: [chunk])

    # return all elements
    html_tag_list = [ "body", "h1", "h2", "h3", "h4", "p", "quote", "span", "a", "script" ]
    
    html_tag_list.each do |tag|
      elements = driver.find_elements(tag_name: tag)
      elements.each do |element|
        full_text << element.text
      end
    end
    
    
    binding.pry
    

    driver.quit
    
    html = Nokogiri::HTML(response.body)

    
    binding.pry
    

    scripts = html.xpath("//script")
    search_if_important_javascript(scripts)
    binding.pry
  end


  def visit_medium_article(link)
    puts "visit_medium_article"
    response = HTTParty.get(link)
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

    # add title and sub_title
    content << [{ type: "H1", text: title }]
    content << [{ type: "H2", text: sub_title }]

    puts content

    # which type of structure ?
      # with title and sub_title ?
      # use quotes ? (https://medium.com/@sejuhutish/discover-the-power-of-ruby-an-introduction-to-the-ruby-programming-language-29d7e743b27b)
      # <strong> ? (https://medium.com/@larahocheiser/know-a-coding-language-you-can-learn-ruby-in-a-day-6f61f9e5148)


    def article_to_markdown(title, sub_title, content)
      markdown_text = ""
      summary = ""

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
  
      return {markdown_text: markdown_text, summary: summary}
    end
    
    # markdown parapgraphs / summary
    markdown_text, summary = article_to_markdown(title, sub_title, content)
    
    puts markdown_text
    puts summary
    


    binding.pry
    

  end

  def visit_page(link)

    link_without_spaces = link.gsub(/\s+/, '')
    is_medium = link.include?("medium.com")
    visit_medium_article(link_without_spaces) if is_medium
    visit_article(link_without_spaces) unless is_medium

    # response = HTTParty.get(link_without_spaces)


    # scroll down

    # js

    # html structure
    # with css
    # build summary
    
    # puts "response, #{response.class}"
    

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