xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Comic Name"
  xml.subtitle "Comic subtitle"
  xml.id settings.webcomic_domain
  xml.link "href" => settings.webcomic_domain
  xml.link "href" => "#{settings.webcomic_domain}/feed.xml", "rel" => "self"
  xml.updated webcomic_feed_data.first.pub_date.to_time.iso8601
  xml.author { xml.name "Blog Author" }

  webcomic_feed_data.each do |webcomic|
    xml.entry do
      
      url= "#{settings.webcomic_domain}#{comic_path_url webcomic}"
      content= if settings.webcomic_include_comic_in_feed
        %Q|<p><img src="#{comic_image_url webcomic}" alt="#{webcomic.title}"/>\n</p>\n#{ webcomic.content}|
      else
        webcomic.content
      end
      
      xml.title webcomic.title
      xml.link "rel" => "alternate", "href" => url
      xml.id url
      xml.published webcomic.pub_date.to_time.iso8601
      xml.updated webcomic.pub_date.to_time.iso8601
      xml.author { xml.name "Article Author" }
      xml.content feed_absolute_paths(content), "type" => "html"
    end
  end
end