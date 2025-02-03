# spec/sequence_parser_spec.rb

require 'rspec'
require_relative '../lib/sequence_parser'

RSpec.describe SequenceParser do
  let(:test_dict_path) { 'spec/fixtures/test_dictionary.txt' }
  let(:parser) { SequenceParser.new(test_dict_path) }

  before do
    # Create test dictionary file
    File.write(test_dict_path, <<~DICT)
      arrows
      18th
      carrots
      give
      me
      Isn't
    DICT
  end

  after do
    # Clean up test files
    File.delete(test_dict_path) if File.exist?(test_dict_path)
    File.delete('sequences.txt') if File.exist?('sequences.txt')
    File.delete('words.txt') if File.exist?('words.txt')
    File.delete('downloaded_dictionary.txt') if File.exist?('downloaded_dictionary.txt')
  end

  describe '#parse' do
    it 'correctly identifies unique sequences' do
      results = parser.parse

      expected_sequences = {
        'carr' => ['carrots'],
        'give' => ['give'],
        'rots' => ['carrots'],
        'rows' => ['arrows'],
        'rrot' => ['carrots'],
        'rrow' => ['arrows']
      }

      expect(results).to eq(expected_sequences)
    end

    it 'ignores words with numbers and special characters' do
      results = parser.parse
      expect(results.values.flatten).not_to include('18th')
      expect(results.values.flatten).not_to include("Isn't")
    end
  end

  describe '#write_output' do
    it 'writes correct output files' do
      parser.parse
      parser.write_output('sequences.txt', 'words.txt')

      sequences = File.readlines('sequences.txt').map(&:strip)
      words = File.readlines('words.txt').map(&:strip)

      expect(sequences).to eq(['carr', 'give', 'rots', 'rows', 'rrot', 'rrow'])
      expect(words).to eq(['carrots', 'give', 'carrots', 'arrows', 'carrots', 'arrows'])
    end
  end

  describe '#download_dictionary' do
    it 'downloads the dictionary file from the provided Gist URL' do
      parser_with_download = SequenceParser.new
      expect(File).to exist('downloaded_dictionary.txt')
    end
  end
end
