# challenge.rb, author: Lennart Gerson

class Base
  # shared initialisition to avoid redundancy
  def initialize(values: [], max_value: 0, mean_value: 0, valid: true)
    @values = values
    @max_value = max_value
    @mean_value = mean_value
    # valid is not needed in this version, since there is no trigger to set it 
    # to false. Left here for presentation reasons
    @valid = valid
    
  end

  attr_accessor :values, :max_value, :mean_value, :valid
end



###################################################################



# I'd personally prefer the word 'avarage' instead of 'mean', just trying to
# follow challenges' requirements
class Mean < Base

  # get average value for stack
  # use pre-stored value if valid
  def mean
    if valid
      mean_value
    else
      # fetch mean from stack if stored obj is invalid right now
      # due to unfinished data operations (see challenge_big_data.rb)
      set_mean(get_mean)
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

    # update max_value and mean_value
    set_max
    set_mean
    value
  end

  # add entry to stack
  # some_int: int value || array of integers
  def push(passed_values)
    # implemented in RubyCore::Array, no need to reinvent the wheel
    values.push(passed_values)

    # update max_value and mean_value
    # but try to avoid any extra work
    if passed_values.kind_of?( Array )
     values.flatten!
     passed_values = get_max(passed_values)
    end
    if passed_values.to_i > max_value
      set_max(passed_values)
    end
    set_mean
  end

  # get maximum value from stack.
  # try to use pre-stored value if valid
  def max
    if valid
      max_value
    else
      # fetch max from stack if stored obj is invalid right now
      # due to unfinished data operations (see challenge_big_data.rb)
      set_max(get_max)
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

  # initial fill of stack, can also be used to reset it to empty state
  # passed_values: int || array of integers
  def set_values(passed_values)
    # unique check commented out for now.
    # requirements not clear if desired or not
    self.values = [passed_values].flatten#.uniq
  end
end


##################################################################


# Commandlines for loading file into irb
# like so: irb -> load '(path to file)/challenge.rb'
# path can be omitted when irb gets executed from directory where challenge.rb is

start = Time.now
max = Max.new
p max
p "Pushing 1-10.000.000 numbers into stack"
max.push((1..10000000).to_a)
p "Time taken: " + (Time.now - start).to_s + "s"
p "Max: " + max.max.to_s
p "Mean: " + max.mean.to_s
p "Time taken: " + (Time.now - start).to_s + "s"
p "Popping last item from stack"
max.pop
p "Time taken: " + (Time.now - start).to_s + "s"
p "Max: " + max.max.to_s
p "Mean: " + max.mean.to_s
p "Time taken: " + (Time.now - start).to_s + "s"
p "Pushing 1 into stack"
max.push(1)
p "Time taken: " + (Time.now - start).to_s + "s"
p "Max: " + max.max.to_s
p "Mean: " + max.mean.to_s
p "Time taken: " + (Time.now - start).to_s + "s"
p '###########################################'

# Stresstest: pump up the numbers, you´ll see pop and push take most of the time,
# mean and max are still super fast
10.times do
  p "Pushing 100 into stack"
  max.push(100)
  p "Time taken: " + (Time.now - start).to_s + "s"
  p "Executing max and mean 1000 times"
  1000.times do
    max.max
    max.mean
  end
  p "Time taken: " + (Time.now - start).to_s + "s"
end
10.times do
  p "Popping last item"
  max.pop
  p "Time taken: " + (Time.now - start).to_s + "s"
  p "Executing max and mean 1000 times"
  1000.times do
    max.max
    max.mean
  end
  p "Time taken: " + (Time.now - start).to_s + "s"
end