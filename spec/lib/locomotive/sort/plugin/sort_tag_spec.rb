require 'spec_helper.rb'

module Locomotive
  module Sort
    describe SortTag do
      before :each do
        @type = FactoryGirl.build(:content_type)
        @type.entries_custom_fields.build(label: 'name', type: 'string')
        @type.entries_custom_fields.build(label: 'type', type: 'string')
        @type.save
        @site = @type.site
        Locomotive::Plugins.use_site(@site)
        @plugin = Plugin.new()
        @type.entries.create(name: "C", type: "B")
        @type.entries.create(name: "A", type: "C")
        @type.entries.create(name: "B", type: "A")
        @context = ::Liquid::Context.new({},
          {'contents' => Locomotive::Liquid::Drops::ContentTypes.new},
          {enabled_plugin_tags: [Locomotive::Sort::SortTag::TagSubclass],
           site: @site})
      end

      it 'should sort content entries' do
        template = "{% sort_by_field to sorted from contents.#{@type.slug} by name %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "A, B, C, "
      end
      it 'should sort content entries in reverse' do
        template = "{% sort_by_field to sorted from contents.#{@type.slug} by name reverse %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "C, B, A, "
      end
      it 'should sort content entries by any field' do
        template = "{% sort_by_field to sorted from contents.#{@type.slug} by type %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "B, C, A, "
      end
      it 'should be able to chain sort content entries' do
        template = "{% sort_by_field to sorted from contents.#{@type.slug} by name %}"+
        "{% sort_by_field to sorted2 from sorted by type %}"+
        "{% for entry in sorted2 %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "B, C, A, "
      end
      it 'should not sort content entries if disabled' do
        @context = ::Liquid::Context.new({},
          {'contents' => Locomotive::Liquid::Drops::ContentTypes.new},
          {enabled_plugin_tags: [],
           site: @site})
        template = "{% sort_by_field to sorted from contents.#{@type.slug} by name %}"+
        "{% for entry in sorted %}"+
          "{{entry.name}}, " +
          "{% endfor %}"
        ::Liquid::Template.parse(template).render(@context).should eq "C, A, B, "
      end

    end
  end
end
