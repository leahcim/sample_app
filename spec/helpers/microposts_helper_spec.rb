require 'spec_helper'

describe MicropostsHelper do

  describe "wrap method" do
    it "should wrap long words" do
      max_length = 30
      chunk_length = 5
      helper.wrap('a' * (max_length + 1)).should_not =~
                                                    /a{#{chunk_length + 1},}/
    end
  end
end
