require 'set'

require 'unicode_utils/casefold'
require 'unicode_utils/downcase'
require 'unicode_utils/each_word'
require 'unicode_utils/titlecase'
require 'unicode_utils/upcase'

# Lowercases uppercase strings excluding acronyms.
class IndoorVoice
  # @return [Array<String>] the words in the language
  attr_reader :words

  # @return [Symbol] the language's BCP 47 code
  attr_reader :language_id

  # @return [Set<String>] the characters in the language
  attr_reader :characters

  # @return [Array<Regexp>] regular expressions matching non-word character sequences
  attr_reader :patterns

  # Excludes "\t", "\n", "\v", "\f", "\r", " " and "#".
  # "(", ")", "*", "+", "?", "[" and "\\" can cause SyntaxError.
  SPECIAL_CHARACTERS = Set.new(["$", "(", ")", "*", "+", "-", ".", "?", "[", "\\", "]", "^", "{", "|", "}"])

  # @param [Array<String>] words the words in the language
  # @param [Symbol] language_id the language's BCP 47 code
  # @see http://tools.ietf.org/html/bcp47
  def initialize(words, language_id = :en)
    @words = words
    @language_id = language_id
    @characters = Set.new
    @patterns = []
  end

  # Determines the regular expressions for non-word character sequences.
  def setup
    types = [:prefix, :suffix, :infix]

    data = {}
    types.each do |type|
      data[type] = Hash.new do |hash,character|
        hash[character] = Set.new
      end
    end

    # Determine the possible two-character sequences. Should be O(n) of all characters in all words.
    @words.each do |word|
      chars = UnicodeUtils.upcase(word, @language_id).chars
      @characters.merge(chars)
      if chars.size > 1
        data[:prefix][chars[0]].add(chars[1])
        data[:suffix][chars[-2]].add(chars[-1])
        chars[2..-2].each_with_index do |character,i|
          data[:infix][chars[i + 1]].add(character)
        end
      end
    end

    # Determine whether the language contains any characters requiring escaping.
    escape = @characters.intersect?(SPECIAL_CHARACTERS)

    patterns = {}
    types.each do |type|
      patterns[type] = []
    end

    # Build the regular expressions for non-word character sequences.
    data.each do |type,hash|
      hash.each do |character,set|
        difference = @characters - set
        unless difference.empty?
          # The first condition is just to make the patterns more human-readable.
          patterns[type] << if difference.one?
            if escape
              "#{Regexp.escape(character)}#{Regexp.escape(difference.to_a.first)}"
            else
              "#{character}#{difference.to_a.first}"
            end
          else
            if escape
              "#{Regexp.escape(character)}[#{Regexp.escape(difference.to_a.join)}]"
            else
              "#{character}[#{difference.to_a.join}]"
            end
          end
        end
      end
    end

    @patterns = [
      Regexp.new("^(?:#{patterns[:prefix].join('|')})"),
      Regexp.new("(?:#{patterns[:suffix].join('|')})$"),
      Regexp.new("\\B(?:#{patterns[:infix].join('|')})\\B"),
    ]
  end

  # Downcases all words except for acronyms.
  #
  # @param [String] string an uppercase string
  # @return [String] a string with only acronyms in uppercase
  def downcase(string)
    UnicodeUtils.each_word(string).map do |word|
      if @patterns.any?{|pattern| word[pattern]}
        word
      else
        UnicodeUtils.downcase(word, @language_id)
      end
    end.join
  end

  # Titlecases all words except for acronyms.
  #
  # @param [String] string a string
  # @param [Hash] options optional arguments
  # @option options [Array<String>] :except words to downcase, e.g. conjunctions
  # @return [String] a string with acronyms in uppercase and others in titlecase
  def titlecase(string, options = {})
    blacklist = options.fetch(:except, []).map do |word|
      UnicodeUtils.casefold(word)
    end

    UnicodeUtils.each_word(string).map do |word|
      if @patterns.any?{|pattern| word[pattern]}
        word
      elsif blacklist.include?(UnicodeUtils.casefold(word))
        UnicodeUtils.downcase(word, @language_id)
      else
        UnicodeUtils.titlecase(word, @language_id).gsub(/\b\p{L}\.\p{Ll}\b/) do |s|
          UnicodeUtils.upcase(s, @language_id)
        end
      end
    end.join
  end
end
