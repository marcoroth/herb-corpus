# frozen_string_literal: true

ERB_LINT_CONFIGS = %w[.erb-lint.yml .erb_lint.yml .erb-lint.yaml .erb_lint.yaml].freeze
BETTER_HTML_CONFIGS = %w[.better-html.yml .better_html.yml .better-html.yaml .better_html.yaml].freeze
ERB_FORMATTER_CONFIGS = %w[.erb-formatter.yml .erb_formatter.yml .erb-formatter.yaml .erb_formatter.yaml].freeze

PRIOR_ART_TOOLS = {
  "erb_lint" => { "pattern" => "erb[_-]lint", "configs" => ERB_LINT_CONFIGS },
  "better_html" => { "pattern" => "better[_-]html", "configs" => BETTER_HTML_CONFIGS, "via" => "erb_lint" },
  "erb-formatter" => { "pattern" => "erb[_-]formatter", "configs" => ERB_FORMATTER_CONFIGS }
}.freeze

PRIOR_ART_CONFIGS = PRIOR_ART_TOOLS.values.flat_map { |spec| spec["configs"] }.freeze

COMPONENTS = {
  "herb" => { "kind" => "gem", "project" => "Herb", "gem" => /\Aherb\z/ },
  "@herb-tools/linter" => { "kind" => "npm", "project" => "Herb" },
  "@herb-tools/formatter" => { "kind" => "npm", "project" => "Herb" },
  "@herb-tools/language-server" => { "kind" => "npm", "project" => "Herb" },
  "reactionview" => { "kind" => "gem", "project" => "ReActionView", "gem" => /\Areaction_?view\z/, "aliases" => %w[reaction_view] },
  ".herb.yml" => { "kind" => "config", "project" => "Herb" },
  ".herb/" => { "kind" => "directory", "project" => "Herb" }
}.freeze
