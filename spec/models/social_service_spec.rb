require 'spec_helper'

describe SocialService do

  describe 'with Post posting' do

    before(:each) do
      [User, Post, Event, SocialService].each do |c|
        c.delete_all
      end
      @user = Factory(:user)
      @post = Factory(:post, :user => @user)
      @twitter = Factory(:twitter_service, :user => @user)
      @facebook = Factory(:facebook_service, :user => @user)
      @vkontakte = Factory(:vkontakte_service, :user => @user)
    end

    shared_examples_for "social post" do
      it 'should post' do
        lambda { subject }.should_not raise_error
      end

      it "should post without errors" do
        subject.should eql Hash.new
      end
    end

    describe 'to twitter' do
      subject { @post.post_to_social({ @twitter.id => {"id" => @twitter.id}}, 'http://socialposter.local/testurl')}
      it_behaves_like "social post"
    end

    describe 'to facebook' do
      subject { @post.post_to_social({ @facebook.id => {"id" => @facebook.id}}) }
      it_behaves_like "social post"
    end

    describe 'to vkontakte' do
      subject { @post.post_to_social({ @vkontakte.id => {"id" => @vkontakte.id}}, 'http://socialposter/testurl2') }
      it_behaves_like "social post"
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
      subject { @event.post_to_social({ @twitter.id => {"id" => @twitter.id}}, 'http://socialposter.local/testurl')}
      it_behaves_like "social post"
    end

    describe 'to facebook' do
      subject { @event.post_to_social({ @facebook.id => {"id" => @facebook.id}}) }
      it_behaves_like "social post"
    end

    describe 'to vkontakte' do
      subject { @event.post_to_social({ @vkontakte.id => {"id" => @vkontakte.id}}, 'http://socialposter.local/testurl')}
      it_behaves_like "social post"
    end

  end

end
