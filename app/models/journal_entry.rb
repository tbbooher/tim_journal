class JournalEntry < ActiveRecord::Base
  scope :entered_between, lambda {|start_date, end_date| where("entry_date >= ? AND entry_date <= ?", start_date, end_date )}

  def start_time
    entry_date
  end

  # not sure why we did this
  #def friends
  #  friends_in_focus.empty? ? "." : friends_in_focus
  #end

  class << self
    def smooth_results
      # let's, say, average every week
      entries = all.sort_by{|je| je.entry_date}
      dt = entries.first.entry_date
      d = []
      while dt < entries.last.entry_date
        dt_nxt = dt.next_week
        dts = entered_between(dt, dt_nxt)
        puts dts.size
        fields = {date: dt}
        [:fitness, :chrissy, :devotional].each do |k|
          fields.merge!({k => nilmean(dts.map {|je| je[k]})})
        end
        d << fields
        #fitness: dts.map(&:fitness).mean, date: dt, purity: dts.map(&:purity).mean, chrissy: dts.map(&:chrissy).mean, devotional: dts.map(&:devotional).mean}
        dt = dt_nxt
      end
      d
    end

    def monthly_report(month_string)
      dt = Date.parse("1-#{month_string}")
      entered_between(dt.beginning_of_month, dt.end_of_month).sort_by &:entry_date
    end

    def build_stairs(months = 2)
      dt_st = Date.today.months_ago(months)
      records = where(["entry_date >= ?", dt_st]).sort_by(&:entry_date)
      last = records.first.entry_date
      counts = []
      i = 0
      records.each do |je|
        obs = je.purity
        if obs == 1
          i = i + 1
          counts << {index: i, count: (je.entry_date - last).to_i}
          last = je.entry_date
        end
      end
      counts
    end

    def nilmean(a)
      unless a.nil?
        if a.size == 1 || a.is_a?(Fixnum)
          arr = a.first
          if arr.nil?
            nil
          else
            arr
          end
        else
          arr = a.compact
          (arr.inject(0.0) { |result, el| result + el }) / arr.size
        end
      end
    end

  end

end
