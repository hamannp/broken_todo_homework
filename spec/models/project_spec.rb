require 'rails_helper'

RSpec.describe Project, :type => :model do
  include_examples 'soft delete examples', 'project'

  subject { Project.new(params) }

  let(:params) {
    {
      :title => 'Some Big Project'
    }
  }

  describe "validations" do
    it "is valid with valid params" do
      expect(subject).to be_valid
    end

    it "requires a title" do
      params[:title] = ''

      expect(subject).to_not be_valid
      expect(subject.errors.keys).to eq [:title]
    end
  end

  # TODO: These tests likely want to be shared_examples.  They are
  # a little bit less generic than the other extracted examples in that there
  # can be more than one relationship marked 'dependent: :destroy'.  One possible
  # solution would be to pass in explicitly a list naming the relations to verify.
  # As a counterpoint, that could become expensive and dramatically slow the test
  # suite.  Mocking and stubbing can always help, but in my mind, it feels like
  # the interaction with the DB is integral to these behaviors under test.  A second
  # pair of eyes may come up with a less-expensive alternative.  One altenative
  # that I've seen in the past is to pick a representative model, and only test
  # that one.  That approach has the advantage of not bloating/slowing the test
  # suite.  The downside is that it loses the 'documentary' value of shared
  # examples, and to an extent, reduces the 'safety net.'  If there is precedent
  # in the codebase / shop for how similar challenges have been handled in the
  # past, then it may be safe to follow that precedent at this time.  OTOH, one
  # might simply call out the issue and then decide to wait for more cases of this
  # behavior.  Sometimes, the best way to truly see the duplication is to put in
  # the duplication and then remove it.  If we never saw another example, then at
  # least we didn't waste any money on it.

  describe "Soft Delete with relations marked 'dependent: :destroy'" do
    context "marking dependent records deleted" do
      let(:project) { FactoryBot.create(:project) }
      let(:item) { FactoryBot.create(:item, project: project) }

      it "soft_deletes the parents dependent records" do
        expect(project.items).to match_array([item])
        project.destroy

        expect(project.reload.items).to be_empty
        expect(project.items.unscoped).to match_array([item])
      end
    end

    context "restoring dependent records" do
      let(:project) { FactoryBot.create(:project) }
      let(:item) { FactoryBot.create(:item, :deleted, project: project) }

      it "soft_deletes the parents dependent records" do
        expect(project.items.exists?(item.id)).to  be false

        project.restore_dependents

        expect(project.items.exists?(item.id)).to  be true
      end
    end
  end

end
