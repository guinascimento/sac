require 'sinatra/base'
require 'mustache'

class Mustache
  # Support for Mustache in your Sinatra app.
  #
  #   require 'mustache/sinatra'
  #
  #   class Hurl < Sinatra::Base
  #     register Mustache::Sinatra
  #
  #     set :mustache, {
  #       # Should be the path to your .mustache template files.
  #       :templates => "path/to/mustache/templates",
  #
  #       # Should be the path to your .rb Mustache view files.
  #       :views => "path/to/mustache/views",
  #
  #       # This tells Mustache where to look for the Views module,
  #       # under which your View classes should live. By default it's
  #       # the class of your app - in this case `Hurl`. That is, for an :index
  #       # view Mustache will expect Hurl::Views::Index by default.
  #       # If our Sinatra::Base subclass was instead Hurl::App,
  #       # we'd want to do `set :namespace, Hurl::App`
  #       :namespace => Hurl
  #     }
  #
  #     get '/stats' do
  #       mustache :stats
  #     end
  #   end
  #
  # As noted above, Mustache will look for `Hurl::Views::Index` when
  # `mustache :index` is called.
  #
  # If no `Views::Stats` class exists Mustache will render the template
  # file directly.
  #
  # You can indeed use layouts with this library. Where you'd normally
  # <%= yield %> you instead {{{yield}}} - the body of the subview is
  # set to the `yield` variable and made available to you.
  module Sinatra
    module Helpers
      # Call this in your Sinatra routes.
      def mustache(template, options={}, locals={})
        # Locals can be passed as options under the :locals key.
        locals.update(options.delete(:locals) || {})

        # Grab any user-defined settings.
        if settings.respond_to?(:mustache)
          options = settings.send(:mustache).merge(options)
        end

        # Find and cache the view class we want. This ensures the
        # compiled template is cached, too - no looking up and
        # compiling templates on each page load.
        klass = mustache_class(template, options)

        # If they aren't explicitly disabling layouts, try to find
        # one.
        if options[:layout] != false
          # Let the user pass in a layout name.
          layout_name = options[:layout]

          # If all they said was `true` (or nothing), default to :layout.
          layout_name = :layout if layout_name == true || !layout_name

          # If they passed a layout name use that.
          layout = mustache_class(layout_name, options)

          # If it's just an anonymous subclass then don't bother, otherwise
          # give us a layout instance.
          if layout.name && layout.name.empty?
            layout = nil
          else
            layout = layout.new
          end

          # Does the view subclass the layout? If so we'll use the
          # view to render the layout so you can override layout
          # methods in your view - tricky.
          view_subclasses_layout = klass < layout.class if layout
        end

        # Create a new instance for playing with.
        instance = klass.new

        # Copy instance variables set in Sinatra to the view
        instance_variables.each do |name|
          instance.instance_variable_set(name, instance_variable_get(name))
        end

        # Render with locals.
        rendered = instance.render(instance.template, locals)

        # Now render the layout with the view we just rendered, if we
        # need to.
        if layout && view_subclasses_layout
          rendered = instance.render(layout.template, :yield => rendered)
        elsif layout
          rendered = layout.render(layout.template, :yield => rendered)
        end

        # That's it.
        rendered
      end

      # Returns a View class for a given template name.
      def mustache_class(template, options)
        @template_cache.fetch(:mustache, template) do
          compile_mustache(template, options)
        end
      end

      # Given a view name and settings, finds and prepares an
      # appropriate view class for this view.
      def compile_mustache(view, options = {})
        options[:templates] ||= settings.views if settings.respond_to?(:views)
        options[:namespace] ||= self.class

        factory = Class.new(Mustache) do
          self.view_namespace = options[:namespace]
          self.view_path      = options[:views]
        end

        # Try to find the view class for a given view, e.g.
        # :view => Hurl::Views::Index.
        klass = factory.view_class(view)

        # If there is no view class, issue a warning and use the one
        # we just generated to cache the compiled template.
        if klass == Mustache
          warn "No view class found for #{view} in #{factory.view_path}"
          klass = factory

          # If this is a generic view class make sure we set the
          # template name as it was given. That is, an anonymous
          # subclass of Mustache won't know how to find the
          # "index.mustache" template unless we tell it to.
          klass.template_name = view.to_s
        end

        # Set the template path and return our class.
        klass.template_path = options[:templates] if options[:templates]
        klass
      end
    end

    # Called when you `register Mustache::Sinatra` in your Sinatra app.
    def self.registered(app)
      app.helpers Mustache::Sinatra::Helpers
    end
  end
end

Sinatra.register Mustache::Sinatra
