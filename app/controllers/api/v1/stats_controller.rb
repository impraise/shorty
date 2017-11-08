class Api::V1::StatsController < ApplicationController
  before_action :find_stats, only: [:fetch_stats]

  def fetch_stats
    relevant_attrs = select_attrs(@stats)
    json_response(relevant_attrs, :ok)
  end

  private

  def select_attrs(stats)
    stats.attributes.select do
      |k, v| ['start_date', 'redirect_count', 'last_seen_date'].include?(k)
    end
  end

  def find_stats
    @short_link = ShortLink.find_by_shortcode!(params[:shortcode])
    @stats = @short_link.stat
  rescue ActiveRecord::RecordNotFound
    json_response('The shortcode cannot be found in the system', :not_found)
  end
end
