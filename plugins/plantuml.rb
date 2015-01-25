# Title: PlantUML Code Blocks for Jekyll
# Author: YJ Park (yjpark@gmail.com) 
# https://github.com/yjpark/jekyll-plantuml
# Description: Integrate PlantUML intu Jekyll and Octopress.
#
# Syntax:
# {% plantuml %}
# plantuml code
# {% endplantuml %}
#
require 'open3'
require './plugins/raw'

module Jekyll

  class PlantUMLFile < StaticFile
    def write(dest)
      true
    end
  end

  class PlantUMLBlock < Liquid::Block
    def render(context)
      site = context.registers[:site]

      code = @nodelist.join

      if !site.config['plantuml_background_color'].nil?
        background_color = "skinparam backgroundColor " + site.config["plantuml_background_color"]
        code = background_color + code
      end

      folder = "/images/plantuml/"
      folderpath = site.dest + folder
      if File.exist?(folderpath)
        #puts "PlantUML image path already exist.\n"
      else
        cmd = "mkdir -p " + folderpath
        result, status = Open3.capture2e(cmd)
      end

      filename = Digest::MD5.hexdigest(code) + ".png"
      plantuml_jar = File.expand_path(site.config['plantuml_jar'])
      filepath = site.dest + folder + filename
      if File.exist?(filepath)
        #puts "PlantUML image already exist: " + filepath + "\n"
      else
        cmd = "java -jar " + plantuml_jar + " -pipe > " + filepath

        puts "Generating UML diagram file #{filepath}"
        result, status = Open3.capture2e(cmd, :stdin_data=>code)
        if result != ""
           puts "Problem generating UML diagram (returned #{result})"
           puts "  -->\t" + status.inspect() + "\t" + result
        end
      end

      site.static_files << Jekyll::PlantUMLFile.new(site, site.dest, folder, filename)

      source = "<center>"
      source += "<img src='" + folder + filename + "'>"
      source += "</center>"
      source
    end
  end
end

Liquid::Template.register_tag('uml', Jekyll::PlantUMLBlock)
