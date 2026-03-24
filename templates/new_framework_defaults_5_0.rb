# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.0 upgrade.
#
# Once upgraded flip defaults one by one to migrate to the new default.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.

# Added as false during the upgrade, this allows running the tests in Rails 5.0
# to find places where this needs to be changed. After all deprecations are
# fixed this can be changed to true to avoid re-introducing the deprecated code.
#
# NOTE: this setting was deprecated in Rails 5.1 (since 5.1 it always behaves as true)
# and then removed, remove when upgrading to 5.2
#
# When this value is false, it shows a deprecation in Rails 5.0 in the affected places.
# This deprecation should be fixed in a 5.0 to 5.1 upgrade, then changed to true, and
# then removed in a 5.1 to 5.2 upgrade.
#
# Because it was removed, This setting does not show up in the latest guides,
# check https://guides.rubyonrails.org/v5.0/configuring.html for more details:
Rails.application.config.action_controller.raise_on_unfiltered_parameters = false

# Enable per-form CSRF tokens. Previous versions had false.
Rails.application.config.action_controller.per_form_csrf_tokens = false

# Enable origin-checking CSRF mitigation. Previous versions had false.
Rails.application.config.action_controller.forgery_protection_origin_check = false

# Make Ruby 2.4 preserve the timezone of the receiver when calling `to_time`.
# Previous versions had false.
ActiveSupport.to_time_preserves_timezone = false

# Require `belongs_to` associations by default. Previous versions had false.
Rails.application.config.active_record.belongs_to_required_by_default = false

# Do not halt callback chains when a callback returns false. Previous versions had true.
ActiveSupport.halt_callback_chains_on_return_false = true
