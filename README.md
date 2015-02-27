# IndoorVoice: Lowercase all-caps strings excluding acronyms

[![Gem Version](https://badge.fury.io/rb/indoor_voice.svg)](https://badge.fury.io/rb/indoor_voice)
[![Build Status](https://secure.travis-ci.org/jpmckinney/indoor_voice.png)](https://travis-ci.org/jpmckinney/indoor_voice)
[![Dependency Status](https://gemnasium.com/jpmckinney/indoor_voice.png)](https://gemnasium.com/jpmckinney/indoor_voice)
[![Coverage Status](https://coveralls.io/repos/jpmckinney/indoor_voice/badge.png)](https://coveralls.io/r/jpmckinney/indoor_voice)
[![Code Climate](https://codeclimate.com/github/jpmckinney/indoor_voice.png)](https://codeclimate.com/github/jpmckinney/indoor_voice)

DOES YOUR DATA CONTAIN ALL-CAPS TEXT THAT YOU WISH WAS PROPERLY CASED?

Have your data use its indoor voice.

```ruby
require 'open-uri'

require 'indoor_voice'

# You can use any word list and any language. Here's we use Scrabble words. 
url = 'https://scrabblehelper.googlecode.com/svn/trunk/ScrabbleHelper/src/dictionaries/TWL06.txt'
words = open(url).readlines.map(&:chomp)

# :en is the BCP 47 code for English.
model = IndoorVoice.new(words, :en)
model.setup

model.downcase('HP AND IBM ARE TECHNOLOGY CORPORATIONS.')
# => "HP and IBM are technology corporations."
```

![](http://i.giphy.com/ol57TlMlftsQg.gif)

IndoorVoice is based on the assumption that most acronyms contain non-word character sequences. For example, no English word has the character sequence `bm` in a word-final position, therefore `IBM` must be an acronym.

Once you have a string with only acronyms in uppercase, you can (in your own code) selectively uppercase letters, like the first letter in each sentence, or the first letter of each word. Since most titlecasing gems recase acronyms, titlecasing is a planned feature.

# Why?

No gem for titlecasing dealt with acronyms well. In case this gem doesn't suit your needs, see:

* [titleize](https://rubygems.org/gems/titleize), [titlecase](https://rubygems.org/gems/titlecase), [title_case](https://rubygems.org/gems/title_case) and [gruber-case](https://rubygems.org/gems/gruber-case), based on [TitleCase.pl](http://daringfireball.net/2008/05/title_case) by John Gruber
* [namecase](https://rubygems.org/gems/namecase), based on [Lingua::EN::NameCase](http://search.cpan.org/~barbie/Lingua-EN-NameCase-1.19/lib/Lingua/EN/NameCase.pm) by Mark Summerfield
* [clever_title](https://rubygems.org/gems/clever_title)

Copyright (c) 2014 James McKinney, released under the MIT license
