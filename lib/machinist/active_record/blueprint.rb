module Machinist::ActiveRecord
  class Blueprint < Machinist::Blueprint
    def make(*args)
      super(*process_make_args(*args))
    end

    # Make and save an object.
    def make!(attributes = {})
      Thread.current["#{klass.name}_hard_save"] = true
      object = make(attributes)
      object.save!
      r = object.reload
      Thread.current["#{klass.name}_hard_save"] = false
      false
    end

    def lathe_class #:nodoc:
      Machinist::ActiveRecord::Lathe
    end

    private
      # merge in scoped attributes, makes company.users.make! possible without creating a new company
      def process_make_args(*args)
        association_attributes = scope(:create) || {}
        attributes = args.extract_options!
        attributes = association_attributes.merge(attributes)
        args << attributes
        args
      end
  end
end
