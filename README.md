# README.md

# Dictionary Sequence Parser

This Ruby program parses a dictionary file and finds unique sequences of letters that appear in exactly one word.

## Requirements

- Ruby 2.7+
- RSpec (for running tests)

## Installation

1. Clone the repository
2. Install dependencies:
```bash
bundle install
```

## Usage

### Using a Local Dictionary File
```ruby
parser = SequenceParser.new('path_to_dictionary.txt')
parser.parse
parser.write_output('sequences.txt', 'words.txt')
```

### Downloading Dictionary Automatically
If no file path is provided, the program will automatically download the dictionary from the provided Gist URL:
```bash
ruby run_parser.rb
```

## Running Tests

```bash
rspec spec/sequence_parser_spec.rb
```

## Features

- Downloads dictionary automatically if no file is provided
- Case-insensitive sequence matching
- Ignores words with numbers and special characters
- Memory-efficient file processing