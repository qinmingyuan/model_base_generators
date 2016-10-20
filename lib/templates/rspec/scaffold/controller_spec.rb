<%-
  # ns_file_name incldues namespace.
  # file_name doesn't include namespace.
  file_name = ns_parts.blank? ? file_name || name : ns_parts.last.singularize.underscore
-%>
require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller, <%= type_metatag(:controller) %> do

<%-
  required_ref_attrs  = model.columns_for(:params).select{|attr|  attr.reference && attr.required? }
  required_data_attrs = model.columns_for(:params).select{|attr| !attr.reference && attr.required? }
-%>
<%- model.all_dependencies.each do |m| -%>
  <%= m.factory_girl_let_definition %>
<%- end -%>
<%- unless model.all_dependencies.any?{|m| m.full_resource_name == 'user' }-%>
  let(:user){ FactoryGirl.create(:user) }
<%- end -%>
  before{ devise_user_login(user) }

<%-
  unless required_ref_attrs.empty?
    extra_attributes_to_merge = ".merge(%s)" % required_ref_attrs.map{|attr| "#{attr.name}: #{attr.ref_model.full_resource_name}.id"}.join(', ')
    extra_attributes_for_factory = ", %s" % required_ref_attrs.map{|attr| "#{attr.reference.name}: #{attr.ref_model.full_resource_name}"}.join(', ')
  end
-%>
  let(:<%= file_name %>){ FactoryGirl.create(:<%= file_name %><%= extra_attributes_for_factory %>) }

  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # adjust the attributes here as well.
  let(:valid_parameters) {
    FactoryGirl.attributes_for(:<%= file_name %>)<%= extra_attributes_to_merge %>
  }

  let(:invalid_parameters) {
<%- if !required_data_attrs.empty? -%>
    valid_parameters.symbolize_keys.merge(<%= required_data_attrs.first.name %>: '')
<%- elsif !required_ref_attrs.empty? -%>
    valid_parameters.symbolize_keys.merge(<%= required_ref_attrs.first.name %>_id: '')
<%- else -%>
    skip("Add a hash of attributes invalid for your model")
<%- end -%>
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # <%= controller_class_name %>Controller. Be sure to keep this updated too.
  let(:valid_session) { {} }

<% unless options[:singleton] -%>
  describe "GET #index" do
    it "assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
      get :index, params: {}, session: valid_session
      expect(assigns(:<%= table_name %>)).to eq([<%= file_name %>])
    end
  end

<% end -%>
  describe "GET #show" do
    it "assigns the requested <%= file_name %> as @<%= file_name %>" do
      <%= file_name %> # To create <%= file_name %>
      get :show, params: {:id => <%= file_name %>.to_param}, session: valid_session
      expect(assigns(:<%= file_name %>)).to eq(<%= file_name %>)
    end
  end

  describe "GET #new" do
    it "assigns a new <%= file_name %> as @<%= file_name %>" do
      get :new, params: {}, session: valid_session
      expect(assigns(:<%= file_name %>)).to be_a_new(<%= class_name %>)
    end
  end

  describe "GET #edit" do
    it "assigns the requested <%= file_name %> as @<%= file_name %>" do
      <%= file_name %> # To create <%= file_name %>
      get :edit, params: {:id => <%= file_name %>.to_param}, session: valid_session
      expect(assigns(:<%= file_name %>)).to eq(<%= file_name %>)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new <%= class_name %>" do
        expect {
          post :create, params: {:<%= file_name %> => valid_parameters}, session: valid_session
        }.to change(<%= class_name %>, :count).by(1)
      end

      it "assigns a newly created <%= file_name %> as @<%= file_name %>" do
        post :create, params: {:<%= file_name %> => valid_parameters}, session: valid_session
        expect(assigns(:<%= file_name %>)).to be_a(<%= class_name %>)
        expect(assigns(:<%= file_name %>)).to be_persisted
      end

      it "redirects to the created <%= file_name %>" do
        post :create, params: {:<%= file_name %> => valid_parameters}, session: valid_session
        expect(response).to redirect_to(<%= class_name %>.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved <%= file_name %> as @<%= file_name %>" do
        post :create, params: {:<%= file_name %> => invalid_parameters}, session: valid_session
        expect(assigns(:<%= file_name %>)).to be_a_new(<%= class_name %>)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:<%= file_name %> => invalid_parameters}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
<%- if !required_data_attrs.empty? -%>
  <%- required_data_attrs.each do |required_data_attr| -%>
      let(:new_<%= required_data_attr.name %>){ valid_parameters[:<%= required_data_attr.name %>].succ }
  <%- end -%>
<%- elsif !required_ref_attrs.empty? -%>
      let(:another_<%= required_ref_attrs.last.name %>){ FactoryGirl.create(:<%= required_ref_attrs.last.name %><%= extra_attributes_for_factory %>) }
<%- end -%>

      let(:new_parameters) {
<%- if !required_data_attrs.empty? -%>
        valid_parameters.merge(<%= required_data_attrs.map{|attr| "#{attr.name}: new_#{attr.name}"}.join(', ') %>)
<%- elsif !required_ref_attrs.empty? -%>
        valid_parameters.merge(<%= required_ref_attrs.last.name %>_id: another_<%= required_ref_attrs.last.name %>.id)
<%- else required_data_attrs.empty? -%>
        skip("Add a hash of attributes valid for your model")
<%- end -%>
      }

      it "updates the requested <%= file_name %>" do
        <%= file_name %> # To create <%= file_name %>
        put :update, params: {:id => <%= file_name %>.to_param, :<%= file_name %> => new_parameters}, session: valid_session
        <%= file_name %>.reload
<%- if !required_data_attrs.empty? -%>
  <%- required_data_attrs.each do |attr| -%>
        expect(<%= file_name %>.<%= attr.name %>).to eq new_<%= attr.name %>
  <%- end -%>
<%- elsif !required_ref_attrs.empty? -%>
        expect(<%= file_name %>.<%= required_ref_attrs.last.name %>_id).to eq another_<%= required_ref_attrs.last.name %>.id
<%- else -%>
        skip("Add assertions for updated state")
<%- end -%>
      end

      it "assigns the requested <%= file_name %> as @<%= file_name %>" do
        <%= file_name %> # To create <%= file_name %>
        put :update, params: {:id => <%= file_name %>.to_param, :<%= file_name %> => valid_parameters}, session: valid_session
        expect(assigns(:<%= file_name %>)).to eq(<%= file_name %>)
      end

      it "redirects to the <%= file_name %>" do
        <%= file_name %> # To create <%= file_name %>
        put :update, params: {:id => <%= file_name %>.to_param, :<%= file_name %> => valid_parameters}, session: valid_session
        expect(response).to redirect_to(<%= file_name %>)
      end
    end

    context "with invalid params" do
      it "assigns the <%= file_name %> as @<%= file_name %>" do
        <%= file_name %> # To create <%= file_name %>
        put :update, params: {:id => <%= file_name %>.to_param, :<%= file_name %> => invalid_parameters}, session: valid_session
        expect(assigns(:<%= file_name %>)).to eq(<%= file_name %>)
      end

      it "re-renders the 'edit' template" do
        <%= file_name %> # To create <%= file_name %>
        put :update, params: {:id => <%= file_name %>.to_param, :<%= file_name %> => invalid_parameters}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested <%= file_name %>" do
      <%= file_name %> # To create <%= file_name %>
      expect {
        delete :destroy, params: {:id => <%= file_name %>.to_param}, session: valid_session
      }.to change(<%= class_name %>, :count).by(-1)
    end

    it "redirects to the <%= table_name %> list" do
      <%= file_name %> # To create <%= file_name %>
      delete :destroy, params: {:id => <%= file_name %>.to_param}, session: valid_session
      expect(response).to redirect_to(<%= index_helper %>_url)
    end
  end

end
<% end -%>
