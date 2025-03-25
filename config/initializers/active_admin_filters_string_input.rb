module ActiveAdmin
  module Inputs
    module Filters
      class StringInput
        # Adding new default filters to the string input
        filter :matches
        # Removing the default eq filter
        filters.delete(:eq)
      end
    end
  end
end
