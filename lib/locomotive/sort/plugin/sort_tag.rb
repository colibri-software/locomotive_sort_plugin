module Locomotive
  module Sort
    class SortTag < ::Liquid::Tag

      Syntax = /to\s*(#{::Liquid::VariableSignature}+)\s*from\s*(#{::Liquid::QuotedFragment})\s*by\s*(#{::Liquid::VariableSignature}+)\s*(reverse)?/


        def initialize(tag_name, markup, tokens, context)
          if markup =~ Syntax
            @target  = $1
            @content_type = $2
            @field_variable = $3
            @rev = $4
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'sort_by_field' - Valid syntax: sort_by_field to <var> from <content_type> by <variable with field>")
          end
          super
        end

      def render(context)
        collection = context[@content_type].send(:collection).to_a
        field = context[@field_variable] || @field_variable
        first =  collection.first
        if field and first.respond_to?(field.to_sym)
          collection.sort! do |a,b|
            aEntry = a
            bEntry = b
            if !!@rev
              bEntry.send(field.to_sym) <=> aEntry.send(field.to_sym)
            else
              aEntry.send(field.to_sym) <=> bEntry.send(field.to_sym)
            end
          end
        end
        context[@target.to_s] = Locomotive::Liquid::Drops::ProxyCollection.new(collection)
        ""
      end

      def render_disabled(context)
        context[@target.to_s] = context[@content_type]
        ""
      end
    end
  end
end
