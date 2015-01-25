class JournalEntriesController < ApplicationController
  before_action :set_journal_entry, only: [:show, :edit, :update, :destroy]
  before_action :only_tim
  respond_to :js, :html, :json

# GET /journal_entries
# GET /journal_entries.json
  def index
    @journal_entries = JournalEntry.order("entry_date desc").page(params[:page])
  end

# GET /journal_entries/1
# GET /journal_entries/1.json
  def show
  end

# GET /journal_entries/new
  def new
    @journal_entry = JournalEntry.new
    @last_entry = JournalEntry.last
    if @last_entry
      @journal_entry.memory_verse = @last_entry.memory_verse
      # @journal_entry.to_do = @last_entry.to_do
      @journal_entry.friends = @last_entry.friends
      @journal_entry.at_work = @last_entry.at_work
      @journal_entry.at_home_pc = @last_entry.at_home_pc
      @journal_entry.at_home = @last_entry.at_home
      @journal_entry.at_work = @last_entry.at_work
      @journal_entry.blog_post_ideas = @last_entry.blog_post_ideas
      @journal_entry.someday_maybe = @last_entry.someday_maybe
      @journal_entry.networking = @last_entry.networking
      @journal_entry.consulting = @last_entry.consulting
      @journal_entry.to_read = @last_entry.to_read
      @journal_entry.goals = @last_entry.goals
    end
  end

# GET /journal_entries/1/edit
  def edit
  end

# POST /journal_entries
# POST /journal_entries.json
  def create
    @journal_entry = JournalEntry.new(journal_entry_params)

    respond_to do |format|
      if @journal_entry.save
        format.html { redirect_to @journal_entry, notice: 'Journal entry was successfully created.' }
        format.json { render :show, status: :created, location: @journal_entry }
      else
        format.html { render :new }
        format.json { render json: @journal_entry.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /journal_entries/1
# PATCH/PUT /journal_entries/1.json
  def update
    respond_to do |format|
      if @journal_entry.update(journal_entry_params)
        format.html { redirect_to @journal_entry, notice: 'Journal entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @journal_entry }
      else
        format.html { render :edit }
        format.json { render json: @journal_entry.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /journal_entries/1
# DELETE /journal_entries/1.json
  def destroy
    @journal_entry.destroy
    respond_to do |format|
      format.html { redirect_to journal_entries_url, notice: 'Journal entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

# ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
# Custom Methods
# ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ

  def data
    d = Date.new(0, 1, 1)-1
    months = params[:months].to_i
    respond_to do |format|
      format.json { render json: JournalEntry.build_stairs(months).to_json }
      #format.csv {render csv: 'foo'}
      format.text { render :text => JournalEntry.all.map { |j| "#{(j.entry_date - d).to_i} #{j.fitness ? j.fitness : "NaN"} #{j.purity ? j.purity : "NaN"} #{j.chrissy ? j.chrissy : "NaN"}" }.join(";") }
    end

  end

  def report
    @months = (params[:months].nil? ? 2 : params[:months]).to_i
  end

  def month_data
    #params[:month_string] = Time.local(2013, 11,1).strftime("%b-%g") if params[:month_string] == "undefined"
    render json: JournalEntry.monthly_report(params[:month_string]).to_json(only: [:entry_date, :purity, :fitness, :chrissy, :devotional])
  end

  def month_report
    @month_string = params[:month_string]
  end

  def form_update
    # only requested via json
    # just a json response -- no redirect
    JournalEntry.find(params[:id]).update_attributes(params[:journal_entry])
    head :no_content
  end

  def calendar_report
    @events = JournalEntry.all
    month = params[:month]
    year = params[:year]
    params[:month_string] = Time.local(year, month, 1).strftime('%b-%Y') if month && year
    @month_string = params[:month_string].nil? ? Date.today.strftime('%b-%Y') : params[:month_string]
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_journal_entry
    @journal_entry = JournalEntry.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def journal_entry_params
    params.require(:journal_entry).permit(:entry_date, :description, :purity, :lack_of_discipline, :fitness, :devotional, :chrissy, :relational, :discipline, :facepicking, :stress, :sick, :flossed, :workout, :health_statement, :to_do, :memory_verse, :friends_in_focus, :problem_of_the_day, :problem_attempted, :problem_solved, :created_at, :updated_at, :friends, :workout_done)
  end

  def only_tim
    unless current_user && current_user.id == 1
      redirect_to root_url, :alert => "Access denied."
    end
  end
end
