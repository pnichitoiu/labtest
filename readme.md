## Parser

Parser is a ruby class used to parse a txt file having the following format:
```
OBX|1|C100|20.0|
NTE|1|Comment for C100 result|
OBX|2|C200|500|
NTE|2|Comment for C200 result|
OBX|3|A250|NEGATIVE|
NTE|3|Comment for NEGATIVE result|
OBX|4|B250|++|
NTE|4|Comment 1 for ++ result|
NTE|4|Comment 2 for ++ result|
```

### Usage

```ruby
require 'parser'

parser = Parser.new('results.txt')
p parser.mapped_results
```

### Rspec testing

Run the following command to run all tests 
```
rspec --pattern=./spec/*_spec.rb -f d
```
