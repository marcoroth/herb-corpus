# frozen_string_literal: true

COMPONENTS = {
  "herb" => { "kind" => "gem", "project" => "Herb", "gem" => /\Aherb\z/ },
  "@herb-tools/linter" => { "kind" => "npm", "project" => "Herb" },
  "@herb-tools/formatter" => { "kind" => "npm", "project" => "Herb" },
  "@herb-tools/language-server" => { "kind" => "npm", "project" => "Herb" },
  "reactionview" => { "kind" => "gem", "project" => "ReActionView", "gem" => /\Areaction_?view\z/, "aliases" => %w[reaction_view] },
  ".herb.yml" => { "kind" => "config", "project" => "Herb" },
  ".herb/" => { "kind" => "directory", "project" => "Herb" }
}.freeze
