require 'rails_helper'

RSpec.describe ProjectsController, :type => :controller do
  let(:valid_attributes) { { "title" => "MyString" } }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all projects as @projects" do
      project = Project.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:projects)).to eq [project]
    end
  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :show, {:id => project.to_param}, valid_session
      expect(assigns(:project)).to eq project
    end
  end

  describe "GET new" do
    it "assigns a new project as @project" do
      get :new, {}, valid_session
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe "GET edit" do
    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :edit, {:id => project.to_param}, valid_session
      expect(assigns(:project)).to eq project
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, {:project => valid_attributes}, valid_session
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, {:project => valid_attributes}, valid_session
        expect(assigns(:project)).to be_a(Project)
        expect(assigns(:project)).to be_persisted
      end

      it "redirects to the project" do
        post :create, {:project => valid_attributes}, valid_session
        expect(response).to redirect_to(project_path(Project.first))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        post :create, {:project => { "title" => "invalid value" }},
          valid_session
        expect(assigns(:project)).to be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        post :create, {:project => { "title" => "invalid value" }},
          valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested project" do
        project = Project.create! valid_attributes
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Project).to receive(:update).with({ "title" => "MyString" })

        put :update,
          { :id => project.to_param,
            :project => { "title" => "MyString" }},
          valid_session
      end

      it "assigns the requested project as @project" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => valid_attributes},
          valid_session
        expect(assigns(:project)).to eq project
      end

      it "redirects to the project" do
        project = Project.create! valid_attributes
        put :update, {:id => project.to_param, :project => valid_attributes},
          valid_session
        expect(response).to redirect_to(project_path(project))
      end
    end

    describe "with invalid params" do
      it "assigns the project as @project" do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        put :update, { :id => project.to_param,
                       :project => { "title" => "invalid value" }},
          valid_session
        expect(assigns(:project)).to eq project
      end

      it "re-renders the 'edit' template" do
        project = Project.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Project).to receive(:save).and_return(false)
        put :update, {:id => project.to_param,
                      :project => { "title" => "invalid value" }},
          valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested project" do
      project = Project.create! valid_attributes
      expect {
        delete :destroy, {:id => project.to_param}, valid_session
      }.to change(Project, :count).by(-1)
    end

    it "redirects to the projects list" do
      project = Project.create! valid_attributes
      delete :destroy, {:id => project.to_param}, valid_session
      expect(response).to redirect_to(projects_url)
    end
  end

  describe "DELETE clear" do
    let(:project) { Project.create!(:title => 'Project') }

    before do
      project.items.create(:action => 'test')
    end

    it 'assigns project' do
      delete :clear, { :id => project.to_param }
      expect(assigns(:project)).to eq(project)
    end

    it 'informs the user when there are no completed items to destroy' do
      delete :clear, { :id => project.to_param }
      expect(assigns(:project)).to eq(project)
      expect(flash[:notice]).to match(/There are no completed items for this project\./)
    end

    it 'does not destroy incomplete items' do
      delete :clear, { :id => project.to_param }
      expect(project.items.count).to eq(1)
    end

    it 'destroys complete items' do
      project.items.first.update(:done => true)
      delete :clear, { :id => project.to_param }
      expect(project.reload.items.count).to eq(0)
      expect(flash[:notice]).to match(/Completed items were successfully cleared\./)
    end
  end
end
