require 'spec_helper'

RSpec.describe IndoorVoice do
  # @see http://en.wikipedia.org/wiki/Most_common_words_in_English
  let :words do
    %w(the be to of and a in that have I it for not on with he as you do at this but his by from they we say her she or an will my one all would there their what so up out if about who get which go me when make can like time no just him know take people into year your good some could them see other than then now look only come its over think also back after use two how our work first well way even new want because any these give day most us)
  end

  let :model do
    model = IndoorVoice.new(words, :en)
    model.setup
    model
  end

  describe '#words' do
    it 'should return the words in the language' do
      expect(model.words).to eq(words)
    end
  end

  describe '#language_id' do
    it 'should return the language ID' do
      expect(model.language_id).to eq(:en)
    end
  end

  describe '#characters' do
    it 'should return the characters in the language' do
      expect(model.characters).to eq(Set.new(%w(A B C D E F G H I J K L M N O P R S T U V W Y)))
    end
  end

  describe '#downcase' do
    it 'should downcase only non-acronyms' do
      expect(model.downcase('THE CAT WILL BEAT THE ROBOT')).to eq('the cat will beat the ROBOT') # "cat" and "beat" are not in the word list
    end
  end

  describe '#titlecase' do
    it 'should titlecase only non-acronyms' do
      expect(model.titlecase('THE CAT WILL BEAT THE ROBOT')).to eq('The Cat Will Beat The ROBOT')
    end

    it 'should titlecase only non-acronyms and non-exceptions' do
      expect(model.titlecase('THE CAT WILL BEAT THE ROBOT', except: words)).to eq('the Cat will Beat the ROBOT')
    end
  end
end
