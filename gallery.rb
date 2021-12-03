require 'erb'

# Template interface exists in its own class to avoid binding pulling from the webserver scope

class Gallery
  def initialize(template_location, images)
    template = ERB.new(File.read(template_location))
    images = images
    @html = template.result(binding)
  end

  def html
    @html
  end
end
