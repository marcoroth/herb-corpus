# frozen_string_literal: true

module Pluralize
  def plural_of(singular)
    return singular.sub(/y\z/, "ies") if singular.match?(/[^aeiou]y\z/)
    return "#{singular}es" if singular.match?(/(s|x|z|ch|sh)\z/)

    "#{singular}s"
  end

  def pluralize(count, singular, plural = plural_of(singular))
    "#{count} #{count == 1 ? singular : plural}"
  end

  def noun_for(count, singular, plural = plural_of(singular))
    count == 1 ? singular : plural
  end

  def verb_for(count, singular, plural)
    count == 1 ? singular : plural
  end
end
