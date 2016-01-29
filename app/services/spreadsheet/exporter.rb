require 'csv'

class Spreadsheet::Exporter
  SNAPSHOT_DURATION = 15

  attr_accessor :filename, :snapshot_counter, :event_start_time, :event_end_time

  def initialize(snapshot_counter:, event_start_time:, event_end_time:)
    self.filename = generate_filename
    self.snapshot_counter = snapshot_counter
    self.event_start_time = event_start_time
    self.event_end_time = event_end_time
  end

  def export
    csv << headers
    insert_rows
    close_csv

    filename
  end

  def current_snapshot_start_time
    event_start_time + ((snapshot_counter - 1) * SNAPSHOT_DURATION).minutes
  end

  def current_snapshot_end_time
    current_snapshot_start_time + SNAPSHOT_DURATION.minutes
  end

  def previous_snapshot_start_time
    current_snapshot_start_time - SNAPSHOT_DURATION.minutes
  end

  def previous_snapshot_end_time
    current_snapshot_end_time - SNAPSHOT_DURATION.minutes
  end

  private

  def csv
    @csv ||= ::CSV.open(filename, 'w')
  end

  def close_csv
    csv.close
    @csv = nil
  end

  def generate_filename
    Rails.root.join "tmp", "tweet_export_#{snapshot_counter}.csv"
  end

  def insert_rows
    Person.order(:last).each do |person|
      csv << Row.new(self, person).build
    end
  end

  def headers
    [
      'Candidate_Name',
      'Candidate_Last_Name',
      'hashtage_search',
      'Snapshot_Counter',
      'Most_Recent_Time_Stamp',
      'Time_Elapsed',
      'Overall_Tweet_Percentage',
      'Overall_Tweet_Mentions',
      'Overall_Tweet_Mention_Rank',
      'Most_Recent_Tweet_Percentage',
      'Most_Recent_Tweet_Mentions',
      'Most_Recent_Tweet_Mention_Rank',
      'Last_Tweet_Percentage',
      'Last_Tweet_Mentions',
      'Last_Tweet_Mention_Rank',
      'Overall_Sentiment_Score',
      'Overall_Sentiment_Score_Rank',
      'Most_Recent_Sentiment_Score',
      'Most_Recent_Sentiment_Score_Rank',
      'Last_Sentiment_Score',
      'Last_Sentiment_Score_Rank',
      'Most_Recent_Top_Topic',
      'Most_Recent_Top_Topic_Percentage',
      'Most_Recent_Top_Topic_Tweets',
      'Most_Recent_Top_Linked_Candidate',
      'Most_Recent_Top_Linked_Candidate_Tweets',
      'Most_Recent_Top_Linked_Candidate_Sentiment_Score',
      'Most_Recent_Top_Hashtag',
      'Most_Recent_Top_Hashtag_Tweet_Percentage',
      'Most_Recent_Top_Hashtag_Tweets',
    ]
  end

  class Row
    attr_accessor :person, :exporter

    delegate :event_start_time, :event_end_time, :current_snapshot_start_time,
      :current_snapshot_end_time, :previous_snapshot_start_time, :previous_snapshot_end_time,
      :snapshot_counter, to: :exporter

    def initialize(exporter, person)
      self.exporter = exporter
      self.person = person
    end

    def build
      [
        person.name,
        person.last,
        EVENT_HASHTAG,
        snapshot_counter,
        most_recent_time_stamp,
        "#{SNAPSHOT_DURATION} minutes",
        overall_tweet_percentage,
        overall_tweet_mentions,
        overall_tweet_mentions_rank,
        current_snapshot_tweet_percentage,
        current_snapshot_tweet_mentions,
        current_snapshot_tweet_mentions_rank,
        previous_snapshot_tweet_percentage,
        previous_snapshot_tweet_mentions,
        previous_snapshot_tweet_mentions_rank,
        overall_sentiment_score,
        overall_sentiment_score_rank,
        current_snapshot_sentiment_score,
        current_snapshot_sentiment_score_rank,
        previous_snapshot_sentiment_score,
        previous_snapshot_sentiment_score_rank,
        current_snapshot_top_topic,
        current_snapshot_top_topic_percentage,
        current_snapshot_top_topic_count,
        current_snapshot_top_referenced_person,
        current_snapshot_top_referenced_person_count,
        current_snapshot_top_referenced_person_sentiment_score,
        current_snapshot_top_hashtag,
        current_snapshot_top_hashtag_percentage,
        current_snapshot_top_hashtag_count,
      ]
    end

    private

    # Methods referenced in build

    def most_recent_time_stamp
      current_snapshot_person_tweets.maximum(:created_at)
    end

    def overall_tweet_percentage
      (overall_tweet_mentions.to_f / overall_tweet_count).round(2)
    end

    def overall_tweet_mentions
      overall_person_tweets.count
    end

    def overall_tweet_mentions_rank
      tweet_mentions_rank(event_start_time, event_end_time)
    end

    def current_snapshot_tweet_percentage
      (current_snapshot_tweet_mentions.to_f / current_snapshot_tweet_count).round(2)
    end

    def current_snapshot_tweet_mentions
      current_snapshot_person_tweets.count
    end

    def current_snapshot_tweet_mentions_rank
      tweet_mentions_rank(current_snapshot_start_time, current_snapshot_end_time)
    end

    def previous_snapshot_tweet_percentage
      (previous_snapshot_tweet_mentions.to_f / previous_snapshot_tweet_count).round(2)
    end

    def previous_snapshot_tweet_mentions
      previous_snapshot_person_tweets.count
    end

    def previous_snapshot_tweet_mentions_rank
      tweet_mentions_rank(previous_snapshot_start_time, previous_snapshot_end_time)
    end

    def overall_sentiment_score
      overall_person_tweets.average(:sentiment_score)
    end

    def overall_sentiment_score_rank
      sentiment_score_rank(event_start_time, event_end_time)
    end

    def current_snapshot_sentiment_score
      current_snapshot_person_tweets.average(:sentiment_score)
    end

    def current_snapshot_sentiment_score_rank
      sentiment_score_rank(current_snapshot_start_time, current_snapshot_end_time)
    end

    def previous_snapshot_sentiment_score
      previous_snapshot_person_tweets.average(:sentiment_score)
    end

    def previous_snapshot_sentiment_score_rank
      sentiment_score_rank(previous_snapshot_start_time, previous_snapshot_end_time)
    end

    def current_snapshot_top_topic
      current_snapshot_topic_counts.first.try(:first).try(:name)
    end

    def current_snapshot_top_topic_percentage
      (current_snapshot_top_topic_count.to_f / current_snapshot_tweet_count).round(2)
    end

    def current_snapshot_top_topic_count
      current_snapshot_topic_counts.first.try(:last)
    end

    def current_snapshot_top_referenced_person
      current_snapshot_referenced_people_tweets.first.try(:first).try(:last)
    end

    def current_snapshot_top_referenced_person_count
      current_snapshot_top_referenced_person_tweets.try(:size)
    end

    def current_snapshot_top_referenced_person_sentiment_score
      return if current_snapshot_top_referenced_person_tweets.nil?
      sum = current_snapshot_top_referenced_person_tweets.map(&:sentiment_score).reduce(&:+).to_f
      sum / current_snapshot_top_referenced_person_tweets.size
    end

    def current_snapshot_top_hashtag
      current_snapshot_hashtag_counts.first.try(:first).try(:name)
    end

    def current_snapshot_top_hashtag_percentage
      (current_snapshot_top_hashtag_count.to_f / current_snapshot_tweet_count).round(2)
    end

    def current_snapshot_top_hashtag_count
      current_snapshot_hashtag_counts.first.try(:last)
    end

    # Helpers

    def overall_person_tweets
      person.tweets.between(event_start_time, event_end_time)
    end

    def overall_tweets
      Tweet.between(event_start_time, event_end_time)
    end

    def overall_tweet_count
      overall_tweets.count
    end

    def current_snapshot_person_tweets
      person.tweets.between(current_snapshot_start_time, current_snapshot_end_time)
    end

    def current_snapshot_tweets
      Tweet.between(current_snapshot_start_time, current_snapshot_end_time)
    end

    def current_snapshot_tweet_count
      current_snapshot_tweets.count
    end

    def previous_snapshot_person_tweets
      person.tweets.between(previous_snapshot_start_time, previous_snapshot_end_time)
    end

    def previous_snapshot_tweets
      Tweet.between(previous_snapshot_start_time, previous_snapshot_end_time)
    end

    def previous_snapshot_tweet_count
      previous_snapshot_tweets.count
    end

    def tweet_mentions_rank(start_time, end_time)
      ranks = Person.all.map do |p|
        [p, p.tweets.between(start_time, end_time).count]
      end
      ranks.sort_by{ |ary| ary[1] }.index{|ary| ary[0] == person} + 1
    end

    def sentiment_score_rank(start_time, end_time)
      ranks = Person.all.map do |p|
        [p, p.tweets.between(start_time, end_time).average(:sentiment_score)]
      end
      ranks.sort_by{ |ary| ary[1] }.index{|ary| ary[0] == person} + 1
    end

    def current_snapshot_topic_counts
      if @current_snapshot_topic_counts.nil?
        @current_snapshot_topic_counts = {}
        current_snapshot_person_tweets.each do |tweet|
          tweet.topics.each do |topic|
            @current_snapshot_topic_counts[topic] ||= 0
            @current_snapshot_topic_counts[topic] += 1
          end
        end
        @current_snapshot_topic_counts.sort_by {|topic, count| count}.reverse
      end
      @current_snapshot_topic_counts
    end

    def current_snapshot_referenced_people_tweets
      if @current_snapshot_referenced_people.nil?
        @current_snapshot_referenced_people = {}
        current_snapshot_person_tweets.each do |tweet|
          tweet.people.excluding(person).each do |p|
            @current_snapshot_referenced_people[p] ||= []
            @current_snapshot_referenced_people[p] << tweet
          end
        end
        @current_snapshot_referenced_people.sort_by {|topic, tweets| tweets.size}.reverse
      end
      @current_snapshot_referenced_people
    end

    def current_snapshot_top_referenced_person_tweets
      current_snapshot_referenced_people_tweets.first.try(:last)
    end

    def current_snapshot_hashtag_counts
      if @current_snapshot_hashtag_counts.nil?
        @current_snapshot_hashtag_counts = {}
        current_snapshot_person_tweets.each do |tweet|
          tweet.hashtags.each do |hashtag|
            @current_snapshot_hashtag_counts[hashtag] ||= 0
            @current_snapshot_hashtag_counts[hashtag] += 1
          end
        end
        @current_snapshot_hashtag_counts.sort_by {|hashtag, count| count}.reverse
      end
      @current_snapshot_hashtag_counts
    end

  end

end