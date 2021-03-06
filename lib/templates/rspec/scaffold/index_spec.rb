<%- unless ModelBase.config.frozen_string_literal.nil? -%>
# frozen_string_literal: <%= ModelBase.config.frozen_string_literal.inspect %>
<%- end -%>
require 'rails_helper'

<% output_attributes = model.columns.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe '<%= ns_table_name %>/index', <%= type_metatag(:view) %> do
  <%= model.factory_girl_let_definitions %>
  before(:each) do
    assign(:<%= table_name %>, [
<% [1,2].each_with_index do |id, model_index| -%>
  <%- if tc = model.title_column -%>
             <%= model.factory_girl_to(:create, extra: {tc.name.to_sym => tc.sample_value(model_index + 1)}) %>,
  <%- else -%>
             <%= model.factory_girl_to(:create, context: :spec_index, index: id, ) %>,
  <%- end -%>
<% end -%>
           ])
  end

  it 'renders a list of <%= ns_table_name %>' do
    render
<% model.columns_for(:spec_index).each do |attribute| -%>
  <%- if attribute.single_sample_only? -%>
    assert_select 'tr>td', text: <%= attribute.sample_string_exp %>, count: 2
  <%- else -%>
    assert_select 'tr>td', text: <%= attribute.sample_string_exp(1) %>, count: 1
    assert_select 'tr>td', text: <%= attribute.sample_string_exp(2) %>, count: 1
  <%- end -%>
<% end -%>
  end
end
