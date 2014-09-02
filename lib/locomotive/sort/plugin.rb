require "locomotive/sort/plugin/sort_tag"
require "locomotive/sort/plugin/boolean_sort_tag"

module Locomotive
  module Sort
    class Plugin
      include Locomotive::Plugin

      def self.default_plugin_id
        'sort'
      end

      def self.liquid_tags
        {
          :by_field => SortTag,
          :boolean => BooleanSortTag,
        }
      end
    end
  end
end
