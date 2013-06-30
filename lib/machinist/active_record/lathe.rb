module Machinist::ActiveRecord

  class Lathe < Machinist::Lathe

    def make_one_value(attribute, args) #:nodoc:
      value = if is_association?(attribute) && !object.send(attribute).nil?
        object.send(attribute)
      elsif block_given?
        raise_argument_error(attribute) unless args.empty?
        yield
      else
        make_association(attribute, args)
      end

      # save the associations if we are doing a hard make!
      if Thread.current["machinist_hard_save"] && value.is_a?(ActiveRecord::Base) && value.new_record?
        value.save!
      end

      value
    end

    def make_association(attribute, args) #:nodoc:
      if !(association = find_association(attribute)).nil?
        association.klass.make(*args)
      else
        raise_argument_error(attribute)
      end
    end

    private
      def is_association?(attribute)
        !find_association(attribute).nil?
      end

      def find_association(attribute)
        @klass.reflect_on_association(attribute)
      end
  end
end
