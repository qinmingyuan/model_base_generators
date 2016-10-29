require 'rails_helper'

RSpec.describe '<%= ns_table_name %>/show', <%= type_metatag(:view) %> do
  <%= model.factory_girl_let_definitions %>
  <%= model.factory_girl_let_definition %>
  before(:each) do
    assign(:<%= model.full_resource_name %>, <%= model.full_resource_name %>)
  end

  it 'renders attributes in <p>' do
    render
<% model.columns_for(:spec_show).each do |attribute| -%>
    expect(rendered).to match(<%= attribute.sample_value_regexp_exp %>)
<% end -%>
  end
end
