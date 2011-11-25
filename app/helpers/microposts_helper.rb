module MicropostsHelper

  def wrap(content, max_length = 30, chunk_length = 5)
    content = sanitize(content).split.map.each do |word|
      wrap_word(word, max_length, chunk_length)
    end
    raw(content.join(' '))
  end

  private

    def wrap_word(word, max_length, chunk_length)
      if word.length <= max_length
        word
      else
        zero_width_space = '&#8203;'
        word.scan(/.{1,#{chunk_length}}/).join(zero_width_space)
      end
    end
end
