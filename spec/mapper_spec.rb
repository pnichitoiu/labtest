require './parser'
require './exception'

describe Mapper do
  context "When testing the class" do

    context "calling mapped_format" do
      it "with a valid code it should return mapped format" do
        Mapper::CODE_MAP.each do|code, format|
          mapper= Mapper.new(code, 'sample')
          expect(mapper.mapped_format).to eq format.is_a?(Hash) ? format.keys[0] : format
        end
      end

      it "with a wrong code it should raise a CodeFormatException" do
        mapper= Mapper.new('test', 'sample')
        expect{mapper.mapped_format}.to raise_error(CodeFormatException, 'Code test has no format map.')
      end
    end

    context "calling mapped_value" do
      it " with a valid code/result, it should return value format" do
        Mapper::CODE_MAP.each do|code, format|
          if format.is_a?(Hash)
            format[format.keys[0]].each do |value, mapped_value|
              mapper= Mapper.new(code, value)
              expect(mapper.mapped_value).to eq mapped_value
            end
          end
        end
      end

      it "with a wrong result it should raise a ValueFormatException" do
        mapper= Mapper.new('A250', '+++++')
        expect{mapper.mapped_value}.to raise_error(ValueFormatException, 'Result +++++ has no value map.')
      end

      it "with a wrong code it should raise a CodeFormatException" do
        mapper= Mapper.new('A23454', '+++')
        expect{mapper.mapped_value}.to raise_error(CodeFormatException, 'Code A23454 has no format map.')
      end
    end
  end
end