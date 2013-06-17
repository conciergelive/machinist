module Machinist::ActiveRecord
  module Machinable
    def make(*args)
      super(*process_make_args(*args))
    end

    # Make and save an object.
    def make!(attributes = {})
      super(*process_make_args(*args))
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
