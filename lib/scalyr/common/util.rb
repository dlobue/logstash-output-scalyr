module Scalyr; module Common; module Util;


# Flattens a hash or array, returning a hash where keys are a delimiter-separated string concatenation of all
# nested keys.  Returned keys are always strings.  If a non-hash or array is provided, raises TypeError.
# Please see rspec util_spec.rb for expected behavior.
def self.flatten(obj, delimiter='_')

  # base case is input object is not enumerable, in which case simply return it
  if !obj.respond_to?(:each)
    raise TypeError.new('Input must be a hash or array')
  end

  result = Hash.new
  # require 'pry'
  # binding.pry

  if obj.respond_to?(:has_key?)

    # input object is a hash
    obj.each do |key, value|
      if value.respond_to?(:each)
        flatten(value).each do |subkey, subvalue|
          result["#{key}#{delimiter}#{subkey}"] = subvalue
        end
      else
        result["#{key}"] = value
      end
    end

  else

    # input object is an array or set
    obj.each_with_index do |value, index|
      if value.respond_to?(:each)
        flatten(value).each do |subkey, subvalue|
          result["#{index}#{delimiter}#{subkey}"] = subvalue
        end
      else
        result["#{index}"] = value
      end
    end
  end

  return result
end



def self.calculate_percentiles(values, percentiles)
  values_sorted = values.sort
  results = []
  for percentile in percentiles
    if values_sorted.length == 0
      results.append(0)
    elsif values_sorted.length == 1
      results.append(values_sorted[0])
    else
      k = (percentile*(values_sorted.length-1)+1).floor - 1
      f = (percentile*(values_sorted.length-1)+1).modulo(1)

      results.append(values_sorted[k] + (f * (values_sorted[k+1] - values_sorted[k])))
    end
  end
  results
end

end; end; end;

