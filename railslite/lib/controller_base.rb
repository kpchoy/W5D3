require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise_error if already_built_response?
    @already_built_response = true
    # res.redirect(url, status = 302)
    res.status = 302
    res['Location'] = url

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise_error if already_built_response?
    @already_built_response = true
    self.res['Content-Type'] = content_type
    self.res.write(content)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # a = self.class.name[0...-10]
    # a = a.downcase + "_controller"
    a = self.class.name.underscore
    # File.dirname("../views/#{a}/#{template_name}.html.erb")
    dir_path = File.dirname(__FILE__)
    path = File.join(dir_path, "..", "views","#{a}","#{template_name}.html.erb")
    template = ERB.new(File.read(path)).result(binding)
    # debugger
    render_content(template, "text/html")

  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
