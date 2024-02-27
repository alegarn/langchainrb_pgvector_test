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


  def scroll_down(driver)
    prev_height = -1
    max_scrolls = 100
    scroll_count = 0

    while scroll_count < max_scrolls
      driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
      driver.manage.timeouts.implicit_wait = 500
      new_height = driver.execute_script("return document.body.scrollHeight")
      break if new_height == prev_height      
      prev_height = new_height
      scroll_count += 1
    end

  end

  # 
  def visit_article(link)
    puts "visit_article"
    driver = Selenium::WebDriver.for :chrome
    driver.get(link)
    driver.manage.timeouts.implicit_wait = 250 #[250..500]


    #html fetch detection (futur)
      # scroll down, wait / select footer, wait
      # if none scroll down last child
    
    scroll_down(driver)
    
    body_html = driver.find_element(tag_name: "body").attribute("innerHTML")
  
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

      def extract_text_lines(full_text)
        lines = full_text.split("\n")
      end
    lines = extract_text_lines(full_text)
    # create a html tree with only the tags containing one line of texts in full_text
      # <html_tag>line1</html_tag> : add in the tree
      # what is the hierarchy of the titles: ["h1", "h2", "h3", "h4", "h5", "h6", "strong"]
      # page_tree = {"title" => {"tag" => "h1", "text" => "line1", children: {"h2" => "line2", ...} ...}
    # Define the hierarchy of title tags
    hierarchy = ["h1", "h2", "h3", "h4", "h5", "h6"]

##################################
# test!!!

# + only start with h1 

    lines_with_hierarchy = []

    lines.each do |line|
      hierarchy_tag = ''  # Initialize the hierarchy tag variable
    
      html_noko.xpath("//*[text()='#{line}']").each do |element|
        tag_name = element.name
        if hierarchy.include?(tag_name)
          hierarchy_tag = tag_name
          break
        end
      end
    
      line_with_hierarchy = hierarchy.include?(hierarchy_tag) ? "#{'#' * (hierarchy.index(hierarchy_tag) + 1)} #{line}" : line
      lines_with_hierarchy << line_with_hierarchy
    end




    paragraphs = []
    current_paragraph = ""

    lines_with_hierarchy.each do |line|
      if line.start_with?("#")  # New hierarchy tag found
        paragraphs << current_paragraph unless current_paragraph.empty?
        current_paragraph = line  # Start a new paragraph
      else
        current_paragraph += "\n#{line}"  # Add line to current paragraph
      end
    end

    paragraphs << current_paragraph unless current_paragraph.empty?  # Add the last paragraph

    paragraphs.each_with_index do |paragraph, index|
      puts "Paragraph #{index + 1}:"
      puts paragraph
      puts "\n"
    end

# + find conclusion
# + return a hierarchy tree with the hierarchy of the titles
# + return the hierarchy of the paragraphes


# just summary
  # it has the conclusion of the article
    # extract xpath from conclusion as endpoint?
  # 
# Initialize an array to store the summary
summary = []

# Iterate over each heading tag in the HTML content
hierarchy.each do |tag|
  html_noko.css(tag).each do |element|
    line = element.text.strip  # Extract the text content of the heading tag
    summary << "#{'#' * (hierarchy.index(tag) + 1)} #{line}"  # Format the heading tag in Markdown style and add it to the summary
  end
end

# Output the summary
summary.each do |heading|
  puts heading
end


###
# Initialize a hash to store the hierarchy tree
hierarchy_tree = {}

# Iterate over each heading tag in the HTML content
hierarchy.each do |tag|
  html_noko.css(tag).each do |element|
    line = element.text.strip  # Extract the text content of the heading tag
    # Format the heading tag in Markdown style
    formatted_heading = "#{'#' * (hierarchy.index(tag) + 1)} #{line}"
    
    # Find the parent heading tag in the hierarchy
    parent_tag_index = hierarchy.index(tag) - 1
    parent_tag = hierarchy[parent_tag_index] if parent_tag_index >= 0
    
    if parent_tag
      # Check if the parent entry exists in the hierarchy tree
      if hierarchy_tree[parent_tag].nil?
        hierarchy_tree[parent_tag] = [formatted_heading]
      else
        hierarchy_tree[parent_tag] << formatted_heading
      end
    else
      hierarchy_tree[tag] = [formatted_heading]
    end
  end
end

# Output the hierarchical tree
def display_hierarchy_tree(tree, level = 0)
  tree.each do |key, value|
    puts "#{'#' * level} #{key}"
    value.each do |heading|
      puts "#{spacing(level)}- #{heading}"
    end
    display_hierarchy_tree(tree[key], level + 1) if tree[key].is_a?(Hash)
  end
end

def spacing(level)
  '  ' * level
end

# Display the hierarchical tree
display_hierarchy_tree(hierarchy_tree)


### summary until conclusion
summary = []
conclusion_found = false

# Iterate over each heading tag in the HTML content
hierarchy.each do |tag|
  html_noko.css(tag).each do |element|
    line = element.text.strip  # Extract the text content of the heading tag
    summary << { tag: tag, text: line }  # Store the tag and text in the summary

    # Check if the conclusion is found
    if line.downcase.include?('conclusion')
      conclusion_found = true
      break
    end
  end

  break if conclusion_found  # Break out of the loop if conclusion is found
end

# Output the summary
summary.each do |heading|
  puts "#{heading[:tag]}: #{heading[:text]}"
end


    ###########################################################








      def build_html_tree(full_text, hierarchy)
        tree = {}
        hierarchy.each do |tag|
          lines = full_text.split("\n").select { |line| line.start_with?("<#{tag}>") }
          lines.each do |line|

            tag_name = line.scan(/<(\w+)>/).flatten.first
            text = line.scan
            text = line.gsub(/<\w+>(.*?)<\/\w+>/, "\\1")
            parent_tag = line.scan(/<(\w+)>/).flatten.first
            parent_text = line.scan(/<\w+>(.*?)<\/\w+>/).flatten.first
            tree[parent_text] ||= { tag: parent_tag, text: text, children: {} }
          end
        end
        tree
      end


      def build_title_hierarchy(full_text, hierarchy)
        title_hierarchy = {}
        hierarchy.each do |tag|
          lines = full_text.split("\n").select { |line| line.start_with?("<#{tag}>") }
          lines.each_with_index do |line, index|
            parent_title = hierarchy[index - 1] unless index == 0
            tag_name = line.scan(/<(\w+)>/).flatten.first
            text = line.gsub(/<\w+>(.*?)<\/\w+>/, "\\1")
            if parent_title
              title_hierarchy[parent_title][:children][tag_name] = text
            else
              title_hierarchy[tag_name] = { tag: tag, text: text, children: {} }
            end
          end
          title_hierarchy
        end
      end

    
      def build_tree_from_html(full_text, html)
        page_tree = {}
      
        # Extract lines from the full text
        lines = full_text.split("\n")
      
        # Parse the HTML string using Nokogiri
        parsed_html = Nokogiri::HTML(html)
      
        # Iterate over each line in full text
        lines.each do |line|
          # Find the corresponding HTML element in the parsed HTML
          element = parsed_html.at_xpath("//*[contains(text(), '#{line}')]")
          
          if element
            tag = element.name
            text = element.text
            parent_tag = element.parent.name
            parent_text = element.parent.text
      
            # Add the element to the page tree
            if page_tree[parent_text]
              page_tree[parent_text][:children][tag] = text
            else
              page_tree[parent_text] = { tag: parent_tag, text: parent_text, children: { tag => text } }
            end
          end
        end
      
        page_tree
      end


      # some debug
      def build_tree_from_html(full_text, html, hierarchy)
        page_tree = {}
      
        # Extract titles based on the hierarchy
        titles_hierarchy = build_title_hierarchy(full_text, hierarchy)
      
        # Parse the HTML string using Nokogiri
        parsed_html = Nokogiri::HTML(html)
      
        # Iterate over each title in the hierarchy
        titles_hierarchy.each do |title, data|
          tag = data[:tag]
          text = data[:text]
      
          # Find the corresponding HTML element for the title
          element = parsed_html.at_xpath("//*[contains(text(), '#{text}')]")
          
          if element
            parent_title = titles_hierarchy.key(data)  # Get the parent title
            if parent_title
              parent_element = parsed_html.at_xpath("//*[contains(text(), '#{parent_title}')]")
              if parent_element
                parent_tag = parent_element.name
                parent_text = parent_element.text
        
                # Add the element to the page tree
                if page_tree[parent_text]
                  page_tree[parent_text][:children][tag] = text
                else
                  page_tree[parent_text] = { tag: parent_tag, text: parent_text, children: { tag => text } }
                end
              end
            end
          end
        end
      
        page_tree
      end      



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

=begin  

      FINDERS =

      {
        :class             => 'ClassName',
        :class_name        => 'ClassName',
        :css               => 'CssSelector',
        :id                => 'Id',
        :link              => 'LinkText',
        :link_text         => 'LinkText',
        :name              => 'Name',
        :partial_link_text => 'PartialLinkText',
        :tag_name          => 'TagName',
        :xpath             => 'Xpath',
      }
=end