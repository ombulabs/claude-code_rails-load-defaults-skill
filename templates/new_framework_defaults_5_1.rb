# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.1 upgrade.
#
# Once upgraded flip defaults one by one to migrate to the new default.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.

# Make `form_with` generate non-remote forms.
#
# Note: this value's default changes to true in Rails 5.1 but then it changes
# back to false in Rails 6.1
#
# If this file is removed in favor of load_defaults we should recommend setting
# the value they actually want to use in the future to prevent defaults from
# changing it.
Rails.application.config.action_view.form_with_generates_remote_forms = false

# Unknown asset fallback will return the path passed in when the given
# asset is not present in the asset pipeline.
# Rails.application.config.assets.unknown_asset_fallback = false
