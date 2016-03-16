module VotesCounter
  extend ActiveSupport::Concern

  included do
    scope :with_votes, -> {
      joins("LEFT JOIN votes ON votes.voteable_id = #{table_name}.id AND votes.voteable_type = '#{to_s}'").select("#{table_name}.*, SUM(votes.value) AS total_votes").group("#{table_name}.id")
    }

    scope :top, -> {
      with_votes.order('total_votes DESC, created_at DESC')
    }

    scope :by_date, -> {
      with_votes.order('created_at DESC')
    }
  end

  def votes_count
    if respond_to? :total_votes
      total_votes.to_i
    else
      votes_alternative
    end
  end

  def votes_alternative
    votes.reduce(0) do |sum , vote|
      sum + vote.value
    end
  end
end
