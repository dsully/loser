module Merb
  module GlobalHelpers
    # helpers defined here available to all views.

    def is_numeric?(object)
      true if Float(object) rescue false
    end

    # From validates_date_time - updated.
    def is_valid_date?(object)
      return if object.nil?
      return object if object.is_a?(Date)
      return object.to_date if object.is_a?(Time) || object.is_a?(DateTime)

      year, month, day = case object.to_s.strip
        # 22/1/06, 22\1\06 or 22.1.06
        when /\A(\d{1,2})[\\\/\.-](\d{1,2})[\\\/\.-](\d{2}|\d{4})\Z/
          [$3, $1, $2]
        # 22 Feb 06 or 1 jun 2001
        when /\A(\d{1,2}) (\w{3,9}) (\d{2}|\d{4})\Z/
          [$3, $2, $1]
        # July 1 2005
        when /\A(\w{3,9}) (\d{1,2})\,? (\d{2}|\d{4})\Z/
          [$3, $1, $2]
        # 2006-01-01
        when /\A(\d{4})[-\/](\d{2})[-\/](\d{2})\Z/
          [$1, $2, $3]
        # 2006-01-01T10:10:10+13:00
        when /\A(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\Z/
          [$1, $2, $3]
        # Not a valid date string
        else
          return nil
      end

      Date.civil(unambiguous_year(year), month_index(month), day.to_i)
    end

    def month_index(month)
      return month.to_i if month.to_i.nonzero?
      Date::ABBR_MONTHNAMES.index(month.capitalize) || Date::MONTHNAMES.index(month.capitalize)
    end

    def unambiguous_year(year)
      year = "#{year.to_i < 20 ? '20' : '19'}#{year}" if year.length == 2
      year.to_i
    end
  end
end
