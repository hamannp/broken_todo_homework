require 'csv'

class CompletedItemsCsvExporter
  def initialize(items: Item.complete, io_out: STDOUT)
    @items = items
    @io_out = io_out
    @header = ['Project Title', 'Action', 'Date Completed', 'Date Added']
  end

  def export!
    CSV(io_out) do |csv|
      csv << header

      items.each do |item|
        csv << [item.project_title, item.action, item.updated_at.to_date, item.created_at.to_date]
      end
    end
  end

private

  attr_reader :items, :io_out, :header
end
