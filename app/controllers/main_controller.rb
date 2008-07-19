class MainController < ApplicationController
  before_filter :build_archive_links, :get_tags
  
  caches_page :index, :tagged, :by_date, :feed
  
  def index
		@posts = Post.paginate(:all, :page => params[:page], :per_page => 5, :order => 'date DESC')
	rescue Exception => ex
	  logger.warn("ERROR: " + ex.message)
	  flash.now[:error] = 'There was an error getting the latest posts.'
	end
	
	def by_date
		if params[:day]
			@query = "#{params[:year]}-#{params[:month]}-#{params[:day]}%"
		elsif params[:month]
			@query = "#{params[:year]}-#{params[:month]}%"
		elsif params[:year]
			@query = "#{params[:year]}%"
		else
			flash[:error] = "I did not understand your request."
			redirect_to home_path
		end
    # now get the post(s) for that date
		if params[:title]
			title = params[:title].gsub("-", " ")
			@post = Post.find(:first, :conditions => "title LIKE '#{title}' AND date LIKE '#{@query}'", :order => 'date DESC')
		else
			@posts = Post.find(:all, :conditions => "date LIKE '#{@query}'", :order => 'date')
		end
	rescue Exception => ex
	  logger.warn("ERROR: " + ex.message)
	  flash.now[:error] = 'There was an error getting the requested post(s).'
	end
	
	def comment
		@comment = Comment.new(params[:comment])
		render :update do |page|
		  if @comment.save
  			page.replace_html 'comment_notice', 'Your comment has been submitted and is awaiting approval.'
  			page.show 'comment_notice'
  			page.hide 'comment_form'
        # clear out params
        page['comment_name'].value = ''
        page['comment_content'].value = ''
  		else
  			page.replace_html 'comment_error', 'Comment could not be recorded.'
  			page.show 'comment_error'
  		end
		end
		
		post = Post.find(params[:comment][:post_id])
		ContactMailer.deliver_contact(post)
	rescue Exception => ex
	  logger.warn("ERROR: " + ex.message)
	end
	
	def tagged
    tag_name = params[:name].gsub('-',' ')
    @tag = Tag.find_by_name(tag_name)
    @posts = @tag.posts.paginate(:all, :page => params[:page], :per_page => 5, :order => 'date DESC')
  rescue Exception => ex
    logger.warn("ERROR: " + ex.message)
    flash.now[:error] = 'There was an error getting the posts for that tag.'
	end
	
	def feed
	  @posts = Post.find(:all, :order => 'date DESC', :limit => 10)
  rescue Exception => ex
    logger.warn("ERROR: " + ex.message)
    flash.now[:error] = 'There was an error generating the feed.'
	end
	
	def old_rss
	  redirect_to(post_rss_path(:rss))
	end
	
	private
	def build_date(date)
		if date.month.to_s.length == 1
			@month = "0" + date.month.to_s
		else
			@month = date.month
		end
		
		if date.day.to_s.length == 1
			@day = "0" + date.day.to_s
		else
			@day = date.day
		end
	end
	
	def build_archive_links
		@links = []
		@cur_year = Date.today.year
		build_date(Date.today)
		@month = @month.to_i
		
		#get all posts of the current year
		@results = Post.find(:all, :conditions => "date LIKE '#{@cur_year}%'", :order => 'date DESC')
		if @results and @results.length > 0
			for p in @results
				#if the month of the post is less than the current month, make a link to it
				if p.date.month < @month
					#this block fixes the single integer returned from the month() and day() methods
					if p.date.month.to_s.length == 1
						@link_month = "0" + p.date.month.to_s
					else
						@link_month = p.date.month.to_s
					end
					#generate the link's name and the link's URL
					name = get_month_name(@link_month.to_i) + " " + @cur_year.to_s
					linkage = @cur_year.to_s + "/" + @link_month
					#add the archive link to the @links array if it's not already in
					@links.push([name, linkage]) unless @links.include?([name, linkage])
				end
			end
		end
		
		#find all the posts that are not from the current year
		@results = Post.find(:all, :conditions => "date NOT LIKE '#{@cur_year}%'", :order => 'date DESC')
		if @results and @results.length > 0
			for p in @results
				#generate the link's name and the link's URL
				name = p.date.year.to_s
				linkage = p.date.year.to_s
				#add the link to the array if it's not already in
				@links.push([name, linkage]) unless @links.include?([name, linkage])
			end
		end
	end
	
	def get_tags
	  @tags = Tag.find(:all, :order => 'name')
	  @item_count = Post.count(:all)
	end
	
	def get_month_name(num)
		if num == 1
			return "January"
		elsif num == 2
			return "February"
		elsif num == 3
			return "March"
		elsif num == 4
			return "April"
		elsif num == 5
			return "May"
		elsif num == 6
			return "June"
		elsif num == 7
			return "July"
		elsif num == 8
			return "August"
		elsif num == 9
			return "September"
		elsif num == 10
			return "October"
		elsif num == 11
			return "November"
		elsif num == 12
			return "December"
		end
	end
	
end
