# spec/sequence_parser_spec.rb

require 'rspec'
require_relative '../lib/sequence_parser'

RSpec.describe SequenceParser do
  let(:test_dict_path) { 'spec/fixtures/test_dictionary.txt' }
  let(:parser) { SequenceParser.new(test_dict_path) }

  before do
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

    it 'returns sequences with given length' do
      sequence_length = 3
      results = SequenceParser.new(test_dict_path, sequence_length).parse
      expected_sequences = {
        'car' => ['carrots'],
        'giv' => ['give'],
        'ive' => ['give'],
        'ots' => ['carrots'],
        'ows' => ['arrows'],
        'rot' => ['carrots'],
        'row' => ['arrows']
      }

      expect(results).to eq(expected_sequences)
    end

    it 'returns an empty hash for an empty dictionary' do
      empty_dict_path = 'spec/fixtures/empty_dictionary.txt'
      File.write(empty_dict_path, '')

      results = SequenceParser.new(empty_dict_path).parse

      expected_sequences = {}

      expect(results).to eq(expected_sequences)

      File.delete(empty_dict_path) if File.exist?(empty_dict_path)
    end

    it 'returns an empty hash when dictionary has words shorter than sequence length' do
      short_dict_path = 'spec/fixtures/short_words.txt'
      File.write(short_dict_path, "me\nI\n")

      sequence_length = 3
      results = SequenceParser.new(short_dict_path, sequence_length).parse

      expected_sequences = {}

      expect(results).to eq(expected_sequences)

      File.delete(short_dict_path) if File.exist?(short_dict_path)
    end

    it 'handles a dictionary with only one word' do
      single_word_dict_path = 'spec/fixtures/single_word.txt'
      File.write(single_word_dict_path, "carrots")

      results = SequenceParser.new(single_word_dict_path).parse
      expected_sequences = {
        'carr' => ['carrots'],
        'arro' => ['carrots'],
        'rots' => ['carrots'],
        'rrot' => ['carrots']
      }

      expect(results).to eq(expected_sequences)

      File.delete(single_word_dict_path) if File.exist?(single_word_dict_path)  # Clean up
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
