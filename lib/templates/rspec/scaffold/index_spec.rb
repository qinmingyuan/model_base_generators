require 'rails_helper'

<% output_attributes = model.columns.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/index", <%= type_metatag(:view) %> do
  before(:each) do
    assign(:<%= table_name %>, [
<% [1,2].each_with_index do |id, model_index| -%>
      FactoryGirl.create(:<%= ns_file_name %>),
<% end -%>
    ])
  end

  it "renders a list of <%= ns_table_name %>" do
    render
<% model.columns_for(:index).each do |attribute| -%>
    assert_select "tr>td", :text => <%= value_for(attribute) %>.to_s, :count => 2
<% end -%>
  end
end
