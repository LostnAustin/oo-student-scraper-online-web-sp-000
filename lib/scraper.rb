require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :doc, :index_url

  def initialize(index_url)
    @index_url = index_url
  end

  def self.scrape_index_page(index_url)
    html = open(index_url)
    @doc = Nokogiri::HTML(html)
    students = []
      @doc.css("div.roster-cards-container").each do |info|
        info.css(".student-card a").each do |a_student|
          each_student = {
            :name => a_student.css(".student-name").text,
            :location => a_student.css(".student-location").text,
            :profile_url => a_student.attr("href")
          }
          students << each_student
        end
      end
      students
  end



  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    @doc = Nokogiri::HTML(html)
    platforms= {}
      @doc.css(".social-icon-container a").each do |platform|
      #  binding.pry
        if platform.attr("href").include?("twitter")
          platforms[:twitter] = platform.attr("href")
        elsif platform.attr("href").include?("linkedin")
          platforms[:linkedin] = platform.attr("href")
        elsif platform.attr("href").include?("github")
          platforms[:github] = platform.attr("href")

        else #platform.attr('href').include?('.vitals-container h1') #need bio user name here
          platforms[:blog] = platform.attr('href')
        end
      end
      platforms[:profile_quote] = @doc.css(".vitals-text-container div.profile-quote").text
      platforms[:bio] = @doc.css(".bio-content p").text
      platforms
  end


end
# binding.pry

#  end
  # @doc.css(".social-icon-container a")
  # @doc.css(".social-icon-container a").attr('href')
  # => #(Attr:0x127fbe0 { name = "href", value = "https://twitter.com/jmburges" })

  #   @doc.css("social-icon-container").attr('href')
  #  => nil
  #  elsif platform.attr("href").include?("blog")
  #      platforms[:blog] = platform.attr("href")
