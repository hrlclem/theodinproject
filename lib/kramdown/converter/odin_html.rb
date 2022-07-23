# All Kramdown methods that can be overridden are listed here: https://kramdown.gettalong.org/rdoc/Kramdown/Element.html
require 'kramdown/converter/html'

module Kramdown
  module Converter
    module OdinHtml
      def convert_img(element, _indent)
        return super if @stack.last.type == :a

        href = element.attr['src']
        link_attributes = { href:, target: '_blank', rel: 'noopener noreferrer' }

        %(<a#{html_attributes(link_attributes)}>#{super}</a>)
      end

      def convert_a(element, indent)
        if element.attr['href'].starts_with?('http')
          element.attr.merge!('target' => '_blank', 'rel' => 'noopener noreferrer')
          super(element, indent)
        else
          super
        end
      end

      def convert_header(element, indent)
        if element.options[:level] == 3
          section_anchor = "##{generate_id(element.options[:raw_text])}"
          body = "<a#{html_attributes({ href: section_anchor, class: 'internal-link' })}>#{inner(element, indent)}</a>"

          format_as_block_html('h3', element.attr, body, indent)
        else
          super
        end
      end
    end
  end
end

Kramdown::Converter::Html.prepend(Kramdown::Converter::OdinHtml)
