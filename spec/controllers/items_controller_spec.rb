require 'rails_helper'

RSpec.describe ItemsController, :type => :controller do
  let(:project) { FactoryBot.create(:project, title: 'A Project') }

  describe "GET new" do
    before do
      get :new, :project_id => project.id
    end

    it "assigns project" do
      expect(assigns(:project)).to eq(project)
    end

    it "assigns new item" do
      expect(assigns(:item)).to be_a_new(Item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before do
        post :create, { :project_id => project.id,
                        :item => { :action => "Retrieve money." } }
      end

      it 'creates a new item' do
        expect(project.reload.items.count).to eq(1)
      end

      it 'sets notice' do
        expect(flash[:notice]).to eq('Item was successfully created.')
      end

      it 'redirects to project page' do
        expect(response).to redirect_to(project_path(project))
      end
    end

    describe "with invalid params" do
      let(:action) { 'Retrieve money.' }

      it 'sets notice and redirects to the 404 page when project not found' do
        # TODO: It's hard to say why a user would be able to select a project
        # that doesn't exist. One answer might be that someone is trying to do
        # something malicious with a CURL client.  Redirecting to the 404 page
        # without giving the user much info might be appropriate.  In any case,
        # it would not be ideal to blow up with a 500. I would say a similar thing
        # about Item not found on edit.

        post :create, { :project_id => 'not_there',
                        :item => { :action => action } }

        expect(flash[:notice]).to match(/Couldn't find Project with 'id'=not_there/)
      end
    end
  end

  describe "GET edit" do
    let(:item) { project.items.create(:action => 'Go shopping.') }
    before do
      get :edit, :project_id => project.id, :id => item.id
    end

    it 'assigns project' do
      expect(assigns(:project)).to eq(project)
    end

    it 'assigns item' do
      expect(assigns(:item)).to eq(item)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:item) {
        project = Project.create!(:title => 'A Project')
        project.items.create!(:action => 'thing to do')
      }
      before do
        put :update, { :id => item.id, :project_id => item.project.id,
                       :item => { :action => "bar" } }
      end

      it 'updates the requested item' do
        expect(Item.first.action).to eq('bar')
      end

      it 'assigns requested item' do
        expect(assigns(:item)).to eq(item)
      end

      it 'redirects to the project page' do
        expect(response).to redirect_to(project_path(item.project))
      end
    end

    describe "with invalid params" do
      # TODO: add tests for the error cases
    end
  end
end
