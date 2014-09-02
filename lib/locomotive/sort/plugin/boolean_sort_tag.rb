module Locomotive
  module Sort
    class BooleanSortTag < ::Liquid::Tag

      Syntax = /to\s*(#{::Liquid::VariableSignature}+)\s*from\s*(#{::Liquid::VariableSignature}+)\s*by\s*(#{::Liquid::QuotedFragment}+)\s*(reverse)?/


        def initialize(tag_name, markup, tokens, context)
          if markup =~ Syntax
            @target  = $1
            @collection = $2
            @field = $3
            @rev = $4
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'sort_boolean' - Valid syntax: sort_boolean to <var> from <content_type> by <field>")
          end
          super
        end

      def render(context)
        collection = context[@collection].dup
        first =  collection.first
        if @field and first.respond_to?(@field.to_sym)
          top = []
          bot = []
          collection.each do |entry|
            !!entry.send(@field.to_sym) ^ !!@rev ? top << entry : bot << entry
          end
          collection = Locomotive::Liquid::Drops::ProxyCollection.new(top + bot)
        end

        context[@target.to_s] = collection
        ""
      end

      def render_disabled(context)
        collection = context[@collection]
        context[@target.to_s] = collection
        ""
      end
    end
  end
end
