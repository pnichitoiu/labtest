require './parser'
require './exception'

describe Parser do
  context "When testing the class" do

    context "calling initialize" do

      it "with a non existing file it should raise a FileNotExistsException" do
        expect{Parser.new('./not_exist.txt')}.to raise_error(FileNotExistsException, 'File does not exist.')
      end

      it "with an existing file it should not raise any error" do
        expect{Parser.new('./results.txt')}.not_to raise_error
      end

    end

    context "calling rows" do

      it "with a file containing one result and comment" do
        parser = Parser.new('./spec/results_1_comment.txt')
        hash = {"1"=>{:identifier=>"OBX", :index=>"1", :code=>"C100", :result=>"20.0", :comment=>"\\nComment for C100 result"}}
        expect(parser.rows).to eq hash
      end

      it "with a file containing one result and 2 comments" do
        parser = Parser.new('./spec/results_2_comments.txt')
        hash = {"4"=>{:identifier=>"OBX", :index=>"4", :code=>"B250", :result=>"++", :comment=>"\\nComment 1 for ++ result\\nComment 2 for ++ result"}}
        expect(parser.rows).to eq hash
      end

    end

    context "calling mapped_results" do
      it "with a file containing one result and comment" do
        results = [LaboratoryTestResult.new('C100', 20.0, 'float', 'Comment for C100 result')]
        parser = Parser.new('./spec/results_1_comment.txt')
        parser.mapped_results.each_with_index do |el,key|
          expect(el.to_json).to eq results[key].to_json
        end
      end

      it "with a file containing one result and 2 comments" do
        results = [LaboratoryTestResult.new('B250', -2, 'nil_3plus', 'Comment 1 for ++ result\\nComment 2 for ++ result')]
        parser = Parser.new('./spec/results_2_comments.txt')
        parser.mapped_results.each_with_index do |el,key|
          expect(el.to_json).to eq results[key].to_json
        end
      end

      it "with a file containing 2 results" do
        results = [
            LaboratoryTestResult.new('C100', 20.0, 'float', 'Comment for C100 result'),
            LaboratoryTestResult.new('B250', -2, 'nil_3plus', 'Comment 1 for ++ result\\nComment 2 for ++ result'),
          ]
        parser = Parser.new('./spec/results_2_results.txt')
        parser.mapped_results.each_with_index do |el,key|
          expect(el.to_json).to eq results[key].to_json
        end
      end

    end

  end
end