module Machinist::ActiveRecord
  module Machinable
    def self.included(klass)
      klass.class_eval do
        define_callbacks :after_make
      end
    end

    def make(*args)
      super(*process_make_args(*args))
    end

    # Make and save an object.
    def make!(*args)
      old_save_value = Thread.current["machinist_hard_save"]
      begin
        Thread.current["machinist_hard_save"] = true
        r = super(*process_make_args(*args))
      ensure
        Thread.current["machinist_hard_save"] = old_save_value
      end
      r
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
