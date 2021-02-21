require 'spec_helper'

describe CompletedItemsCsvExporter do
  let(:project_title) { 'Awesome Project' }
  let(:created_date) { Date.current }
  let(:updated_date) { Date.current }
  let(:action) { 'do something' }
  let(:item1) do
    instance_double(Item,
                    :project_title => project_title,
                    :updated_at => updated_date,
                    :created_at => created_date,
                    :action => action)
  end
  let(:item_relation) { [item1] }
  let(:io_object) do
    instance_double(IO,
                    :<< => true,
                    :pos => 0,
                    :gets => nil,
                    :rewind => 0,
                    :close => nil)
  end
  let(:params) do
    { :items => item_relation,
      :io_out => io_object }
  end
  let(:exporter) do
    CompletedItemsCsvExporter.new(params)
  end

  describe '.new' do
    it 'instantiates' do
      expect(exporter).to be_a(CompletedItemsCsvExporter)
    end
  end

  describe '#export!' do
    let(:header) { "Project Title,Action,Date Completed,Date Added\n" }

    it 'writes header' do
      expect(io_object).to receive(:<<).with(header)
      exporter.export!
    end

    it 'writes expected completed item lines to file' do
      expect(io_object).to receive(:<<).with(
        "#{project_title},#{action},#{updated_date},#{created_date}\n"
      )
      exporter.export!
    end
  end
end
