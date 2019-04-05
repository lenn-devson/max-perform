# challenge_big_data.rb, author: Lennart Gerson

# Theoretical thoughts to implement it with a ActiveRecord Database

class Base < ActiveRecord
  
  has_many :items
  
  # shared initialisition to avoid redundancy
  def initialize(values: [], max_value: 0, mean_value: 0, valid: true)
    @values = values
    @max_value = max_value
    @mean_value = mean_value
    @valid = valid
  end

  attr_accessor :values, :max_value, :mean_value, :valid
  
  def read_items_from_db(options: {})
    self.values ||= Item.all(options)
    # set mean and max up to date
    set_mean
    set_max
  end
  
  def write_item_to_db(passed_value)
    self.valid = false
    if Item.create(passed_value)
      self.valid = true
    end
  end
  
  def remove_item_from_db(passed_value)
    self.valid = false
    if Item.destroy(passed_value)
      self.valid = true
    end
  end
  
  def valid?
    if valid
      # check for new data e.g. via timestamp or cached requests
      if new_data_exists?
        read_values_from_db
      end
    end
    valid
  end
  
end



###################################################################



class Mean < Base
  # valid? hopefully return true, there is no fallback or catch for the false yet
  def mean
    if valid?
      mean_value
    end
  end

  private

  def get_mean
    values.inject(:+)/values.count
  end

  def set_mean(passed_value=nil)
    self.mean_value = passed_value || get_mean
    self.valid = true
  end
end



#################################################################



class Max < Mean

  # delete last entry from stack and return it
  def pop
    # implemented in RubyCore::Array, no need to reinvent the wheel
    value = values.pop
    delete_item_from_db(value)
    # update max value and max mean
    set_max
    set_mean
    value
  end

  # add entry to stack
  # some_int: one int value || array of int values
  def push(passed_values)
    # implemented in RubyCore::Array, no need to reinvent the wheel
    values.push(passed_values)

    # update max value
    # but try to avoid any extra work
    if passed_values.kind_of?( Array )
     values.flatten!
     passed_values.each do |value|
       write_item_to_db(value)
     end
     
     passed_values = get_max(passed_values)
    else
      write_item_to_db(passed_values)
    end
    if passed_values.to_i > max_value
      set_max(passed_values)
    end
    set_mean
  end

  # get maximum value from stack.
  # try to use pre-stored value if valid
  def max
    if valid?
      max_value
    end
  end

  private

  # passed_value: integer
  def set_max(passed_value=nil)
    self.max_value = passed_value || get_max
    # max value is up-to-date again
    self.valid = true
  end

  # get the maximum value of an array
  # either from passed array or from stack
  # passed_values: array of integers
  def get_max(passed_values=nil)
    passed_values && passed_values.count > 0 ? passed_values.max : values.max
  end

end


