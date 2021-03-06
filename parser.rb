require './exception.rb'
require 'json'

class Parser

  attr_accessor :file_path, :delimiter, :rows

  def initialize(file_path, delimiter = "|")
    @file_path = file_path
    @delimiter = delimiter
    raise FileNotExistsException.new unless File.exist?(file_path)
    raise FileNotReadableException.new unless File.readable?(file_path)
  end

  def rows
    @rows = Hash.new
    File.foreach(file_path) do |line|
      line_a = line.chomp.split(delimiter)
      index = line_a[1]
      # initialize rows index
      @rows[index] = Hash.new unless @rows[index]
      line.include?("OBX") ? parse_result(line_a) : parse_comment(line_a)
    end
    @rows
  end

  def mapped_results
    mapped_results = []
    rows.values.each do |row|
      row_mapper = Mapper.new(row[:code], row[:result])
      mapped_results.append(
        LaboratoryTestResult.new(
          row[:code],
          row_mapper.mapped_value,
          row_mapper.mapped_format,
          row[:comment].nil? ? nil : row[:comment].chomp
        )
      )
    end
    mapped_results
  end

  private

  def parse_result(array)
    %w[identifier index code result].zip(array) { |x,y| @rows[array[1]][x.to_sym] = y }
  end

  def parse_comment(array)
    #fetch comment and add it to the result hash index
    @rows[array[1]][:comment] = '' unless @rows[array[1]][:comment]
    @rows[array[1]][:comment] <<  array.last + "\n"
  end

end


class Mapper

  CODE_MAP = {
    'C100' => 'float',
    'C200' => 'float',
    'A250' => {
      'boolean' => {
        'NEGATIVE' => -1,
        'POSITIVE' => -2
      }
    },
    'B250' =>
      {
        'nil_3plus' => {
          'NIL' => -1,
          '+' => -2,
          '++' => -2,
          '+++' => -3
        }
      }
    }.freeze

  attr_accessor :code, :result

  def initialize(code, result)
    @code = code
    @result = result
  end

  def mapped_format
    if CODE_MAP[code] == nil
      raise CodeFormatException.new "Code #{code} has no format map."
    else
      CODE_MAP[code].is_a?(Hash) ?  CODE_MAP[code].keys[0] : CODE_MAP[code]
    end
  end

  def mapped_value
    format = mapped_format
    case format
    when 'float'
      value = result.to_f
    else
      value = CODE_MAP[code][format][result]
    end
    if value.nil?
      raise ValueFormatException.new "Result #{result} has no value map."
    end
    value
  end
end

class LaboratoryTestResult
  attr_accessor :code, :result, :format, :comment

  def initialize(*args)
    @code, @result, @format, @comment = *args
  end

  def as_json(options={})
    {
      code: @code,
      result: @result,
      format: @format,
      comment: @comment
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
