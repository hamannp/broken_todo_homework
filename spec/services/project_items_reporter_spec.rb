require 'spec_helper'

describe ProjectItemsReporter do
  let(:action1) { 'Walk Dogs' }
  let(:item1) do
    instance_double(Item, action: action1, complete?: true)
  end

  let(:action2) { 'Feed Dogs' }
  let(:item2) do
    instance_double(Item, action: action2, complete?: false)
  end

  let(:project_title) { 'Care for dogs' }
  let(:project) do
    instance_double(Project, title: project_title, items: [item1, item2])
  end

  let(:project_relation) { [project] }

  let(:io_object) do
    instance_double(IO,
                    :pos => 0,
                    :gets => nil,
                    :puts => nil,
                    :rewind => 0,
                    :close => nil)
  end
  let(:params) do
    { projects: project_relation,
      io_out: io_object }
  end
  let(:reporter) do
    ProjectItemsReporter.new(params)
  end

  describe '#call' do
    it 'prints the report to io_out' do
      expect(io_object).to receive(:puts).with(project_title)
      expect(io_object).to receive(:puts).with("- [X] #{action1}")
      expect(io_object).to receive(:puts).with("- [ ] #{action2}")
      expect(io_object).to receive(:puts).with("")

      reporter.call
    end
  end
end
