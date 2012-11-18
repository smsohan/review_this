require 'spec_helper'

describe Comment do
  context '#receipient' do

    before(:each) do
      @bidder = User.new
      @comment = Comment.new
      @comment.bid = Bid.new{|b| b.bidder = @bidder}

      @requestor = User.new
      @comment.bid.stub(:requestor).and_return(@requestor)
    end

    it 'returns the bidder if the comment is sent by the requestor' do
      @comment.user = @requestor
      @comment.recipient.should == @bidder
    end

    it 'returns the requestor if the comment is sent by the bidder' do
      @comment.user = @bidder
      @comment.recipient.should == @requestor
    end

  end
end
