# frozen_string_literal: true

module Pluralize
  def pluralize(count, singular, plural = "#{singular}s")
    "#{count} #{count == 1 ? singular : plural}"
  end

  def noun_for(count, singular, plural = "#{singular}s")
    count == 1 ? singular : plural
  end

  def verb_for(count, singular, plural)
    count == 1 ? singular : plural
  end
end
