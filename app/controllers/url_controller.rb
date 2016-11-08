class UrlController < ApplicationController
	def shorten
		@url = Url.new
		@url.url = params[:url]
		@url.shortcode = params[:shortcode] if params[:shortcode]
		if @url.save
			render status: 201, json: { shortcode: @url.shortcode }
		elsif @url.errors[:url].include? "can't be blank"  
			render status: 400, json: { message: "Missing url parameter" }
		elsif @url.errors[:shortcode].include? "is already taken"  
			render status: 409, json: { message: "Shortcode is already in use" }
		elsif @url.errors[:shortcode].include? "is invalid"  
			render status: 422, json: { message: "Shortcode should be only alphanumeric characters and at least 4 long." }
		else
			render status: 500
		end
	end
	def redirect
		@url = Url.where(shortcode: params[:shortcode]).first
		if @url
			@url.visit!
			@url.save
			redirect_to @url.url, status: 302
		else
			render status: 404
		end
	end
	def stats
		@url = Url.where(shortcode: params[:shortcode]).first
		if @url
			api_response = {
				lastSeenDate: @url.last_seen_at,
				startDate: @url.created_at,
				redirectCount: @url.redirect_count
			}
			render 200, json: api_response
		else
			render status: 404
		end
	end
end
