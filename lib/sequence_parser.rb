# lib/sequence_parser.rb

require 'open-uri'

class SequenceParser
  SEQUENCE_LENGTH = 4
  GIST_URL = 'https://gist.githubusercontent.com/seanbiganski/8c657690b75a830e28557480690bb437/raw/061441e9a3253d6e890be410d0352eeeea40010a/dictionary%2520words'

  def initialize(dictionary_path = nil)
    @dictionary_path = dictionary_path || download_dictionary
    @sequences = Hash.new { |h, k| h[k] = [] }
  end

  def parse
    File.foreach(@dictionary_path) do |line|
      word = line.strip
      next if word.empty?

      # Get valid sequences from the word
      extract_sequences(word)
    end

    # Filter for sequences that appear exactly once
    unique_sequences = @sequences.select { |_, words| words.length == 1 }

    # Sort sequences alphabetically
    unique_sequences.sort.to_h
  end

  def write_output(sequences_file, words_file)
    File.open(sequences_file, 'w') do |seq_file|
      File.open(words_file, 'w') do |word_file|
        @sequences.sort.each do |sequence, words|
          next unless words.length == 1
          seq_file.puts(sequence)
          word_file.puts(words.first)
        end
      end
    end
  end

  private

  def extract_sequences(word)
    # Skip words with numbers or special characters
    return if word =~ /[^a-zA-Z]/

    # Convert to lowercase for case-insensitive comparison
    word_downcase = word.downcase

    # Extract all possible sequences of SEQUENCE_LENGTH
    (0..word_downcase.length - SEQUENCE_LENGTH).each do |i|
      sequence = word_downcase[i, SEQUENCE_LENGTH]
      @sequences[sequence] << word unless @sequences[sequence].include?(word)
    end
  end

  def download_dictionary
    file_path = 'downloaded_dictionary.txt'
    URI.open(GIST_URL) do |remote_file|
      File.open(file_path, 'w') { |file| file.write(remote_file.read) }
    end
    file_path
  rescue StandardError => e
    puts "Failed to download the dictionary file: #{e.message}"
    exit(1)
  end
end