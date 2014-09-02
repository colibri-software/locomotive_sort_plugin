require 'spec_helper.rb'

module Locomotive
  module Sort
    describe BooleanSortTag do
      before :each do
        @type = FactoryGirl.build(:content_type)
        @type.entries_custom_fields.build(label: 'name', type: 'string')
        @type.entries_custom_fields.build(label: 'bool', type: 'boolean')
        @type.save
        @site = @type.site
        Locomotive::Plugins.use_site(@site)
        @plugin = Plugin.new()
        @type.entries.create(name: "A", bool: false)
        @type.entries.create(name: "B", bool: true)
        @type.entries.create(name: "C", bool: false)
        @context = ::Liquid::Context.new({},
          {'contents' => Locomotive::Liquid::Drops::ContentTypes.new},
          {enabled_plugin_tags: [Locomotive::Sort::BooleanSortTag::TagSubclass],
           site: @site})
      end

      it 'should sort content entries' do
        template = "{% sort_boolean to sorted from contents.#{@type.slug} by bool %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "B, A, C, "
      end
      it 'should sort content entries in reverse' do
        template = "{% sort_boolean to sorted from contents.#{@type.slug} by bool reverse %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "A, C, B, "
      end
      it 'should not sort content entries if disabled' do
        @context = ::Liquid::Context.new({},
          {'contents' => Locomotive::Liquid::Drops::ContentTypes.new},
          {enabled_plugin_tags: [],
           site: @site})
        template = "{% sort_boolean to sorted from contents.#{@type.slug} by bool %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "A, B, C, "
      end

    end
  end
end
