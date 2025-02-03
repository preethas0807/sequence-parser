require_relative 'lib/sequence_parser'

# Initialize the parser (downloads dictionary if not provided)
parser = SequenceParser.new

# Parse the dictionary and write the outputs
parser.parse
parser.write_output('sequences.txt', 'words.txt')

puts "Parsing complete! Check 'sequences.txt' and 'words.txt' for results."