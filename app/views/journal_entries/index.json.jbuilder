json.array!(@journal_entries) do |journal_entry|
  json.extract! journal_entry, :id, :entry_date, :description, :purity, :lack_of_discipline, :fitness, :devotional, :chrissy, :relational, :discipline, :facepicking, :stress, :sick, :flossed, :workout, :health_statement, :to_do, :memory_verse, :friends_in_focus, :problem_of_the_day, :problem_attempted, :problem_solved, :created_at, :updated_at, :friends, :workout_done
  json.url journal_entry_url(journal_entry, format: :json)
end
