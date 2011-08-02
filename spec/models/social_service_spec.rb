require 'spec_helper'

describe SocialService do

  describe 'with Post posting' do

    before(:each) do
      [User, Post, Event, SocialService].each do |c|
        c.delete_all
      end
      @user = Factory(:user)
      @post = Factory(:post, :user => @user)
      @post.post_to_social
      @twitter = Factory(:twitter_service, :user => @user)
      @facebook = Factory(:facebook_service, :user => @user)
      @vkontakte = Factory(:vkontakte_service, :user => @user)
    end

    describe 'to twitter' do
      it 'should post' do
        lambda {@twitter.push_post(@post.id)}.should_not raise_error
      end
    end

    describe 'to facebook' do
      it 'should post' do
        lambda {@facebook.push_post(@post.id)}.should_not raise_error
      end
    end

    describe 'to vkontakte' do
      it 'should not raise error' do
        lambda {@vkontakte.push_post(@post.id)}.should_not raise_error
      end

      it 'should post' do
        res = @vkontakte.push_post(@post.id)
        if res && res.is_a?(Array)
          if res[0] == :error
            res[1].should be_a_kind_of(Hash)
            res[1].keys.sort.should eql [:link, :id].sort
          end
        end
      end
    end

  end

  describe 'with Event posting' do

    before(:each) do
      [User, Post, Event, SocialService].each do |c|
        c.delete_all
      end
      @user = Factory(:user)
      @event = Factory(:event, :user => @user)
      @twitter = Factory(:twitter_service, :user => @user)
      @facebook = Factory(:facebook_service, :user => @user)
      @vkontakte = Factory(:vkontakte_service, :user => @user)
    end

    describe 'to twitter' do
      it 'should post' do
        lambda {@twitter.push_event(@event.id)}.should_not raise_error
      end
    end

    describe 'to facebook' do
      it 'should post' do
        lambda {@facebook.push_event(@event.id)}.should_not raise_error
      end
    end

    describe 'to vkontakte' do
      it 'should not raise error' do
        lambda {@vkontakte.push_event(@event.id)}.should_not raise_error
      end

      it 'should post' do
        res = @vkontakte.push_event(@event.id)
        if res && res.is_a?(Array)
          if res[0] == :error
            res[1].should be_a_kind_of(Hash)
            res[1].keys.sort.should eql [:link, :id].sort
          end
        end
      end
    end

  end

end
