module Machinist::ActiveRecord

  class Lathe < Machinist::Lathe

    def make_one_value(attribute, args) #:nodoc:
      value = if block_given?
        raise_argument_error(attribute) unless args.empty?
        yield
      else
        make_association(attribute, args)
      end

      # save the associations if we are doing a hard make!
      if Thread.current["machinist_hard_save"] && value.is_a?(ActiveRecord::Base)
        value.save!
      end

      value
    end

    def make_association(attribute, args) #:nodoc:
      association = @klass.reflect_on_association(attribute)
      if association
        # only make the association if neccessary
        object.send(attribute) || association.klass.make(*args)
      else
        raise_argument_error(attribute)
      end
    end

  end
end
