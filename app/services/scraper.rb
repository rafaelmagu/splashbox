require 'nokogiri'
require 'open-uri'

class Scraper
  def initialize
    @range ||= 1..999
  end

  def run
    @range.each do |page|
      html = open_post page
      break if html.nil?
      html.each do |post|
        quick_url = post.search('.photo-container').first.attributes['src'].value
        source_url = "https://unsplash.com/photos/#{post.attributes['data-photo-id'].value}/download"
        author_name = post.search('.photo-description h2').last.text
        author_url = ("https://unsplash.com" + post.search('.photo-description h2').last.children[0].attributes['href'].value) unless post.search('.photo-description h2').last.children[0].attributes['href'].nil?

        unless Photo.find_by_source_url(source_url)
          Photo.new_from_scraper source_url, quick_url, author_name, author_url
          puts "Photo created * #{ source_url }"
        end
      end
    end
  end

  private

  def open_post page
    begin
      doc = Nokogiri::HTML(open("https://unsplash.com/?page=#{ page }"))
      doc.css('.photo-container')
    rescue => e
      puts "End of site reached at page: #{ page }"
    end
  end
end
