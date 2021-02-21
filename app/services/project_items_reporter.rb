class ProjectItemsReporter
  delegate :puts, to: :io_out

  def initialize(projects: Project.includes(:items), io_out: STDOUT)
    @projects = projects
    @io_out   = io_out
  end

  def call
    projects.each do |project|
      puts(project.title)

      project.items.each do |item|
        puts "- [#{item.complete? ? 'X' : ' '}] #{item.action}"
      end

      puts("")
    end
  end

  private

  attr_reader :projects, :io_out
end
