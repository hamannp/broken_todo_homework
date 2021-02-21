module SoftDelete
  extend ActiveSupport::Concern

  included do
    default_scope -> { where(deleted_at: nil) }
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
    scope :with_deleted, -> { unscope(where: :deleted_at) }

    alias_method :destroy!, :destroy

    def destroy
      # TODO: Support delete_with_restriction

      destroy_dependents_marked_destroy
      update(deleted_at: Time.current)
    end

    def restore
      update(deleted_at: nil)
    end

    def restore_dependents
      each_dependent_marked_destroy { |models| models.unscoped.each(&:restore) }
    end

    private

    def destroy_dependents_marked_destroy
      each_dependent_marked_destroy { |models| models.each(&:destroy) }
    end

    def each_dependent_marked_destroy(&block)
      Array.wrap(dependents[:destroy]).each do |dependent|
        models = send(dependent.name)
        yield models
      end
    end

    def dependents
      @dependents ||= self.class.reflect_on_all_associations.group_by do |reflection|
        reflection.options[:dependent]
      end
    end
  end

end
