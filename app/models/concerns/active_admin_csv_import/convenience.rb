module ActiveAdminCsvImport::Convenience
  extend ActiveSupport::Concern

  module ClassMethods
    # Look up a belongs_to association by name.
    # E.g.
    # lookup_belongs_to :state, by: :name
    # Adds state_name as an ivar.
    def lookup_belongs_to(name, options)

      lookup_by = options[:by]

      code = <<-eoruby
      attr_accessor :#{name}_#{lookup_by}

      before_validation :lookup_#{name}_by_#{lookup_by}

      def lookup_#{name}_by_#{lookup_by}
        return if self.#{name}_#{lookup_by}.blank?
        self.#{name} = '#{name}'.camelize.constantize.where(#{lookup_by}: self.#{name}_#{lookup_by}).first
      end
      eoruby
      class_eval(code)
    end
  end
end
