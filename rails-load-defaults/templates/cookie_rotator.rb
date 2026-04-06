# config/initializers/cookie_rotator.rb
#
# This rotator allows Rails to transparently read cookies encrypted with
# SHA1 (the Rails 6.1 default) and re-write them using SHA256 (the Rails 7.0
# default). This ensures users are not logged out or lose cookie data after
# the load_defaults is changed to 7.0.
#
# WHEN TO ADD: After the Rails 6.1 → 7.0 upgrade is complete and 6.1 is
# fully removed from the codebase, when changing load_defaults to 7.0.
#
# WHEN TO REMOVE: After a grace period (discuss with client — typically weeks
# to months depending on user session patterns). It is also safe to leave
# this in the codebase indefinitely, including through future upgrades.
#
Rails.application.config.after_initialize do
  Rails.application.config.action_dispatch.cookies_rotations.tap do |cookies|
    authenticated_encrypted_cookie_salt = Rails.application.config.action_dispatch.authenticated_encrypted_cookie_salt
    signed_cookie_salt = Rails.application.config.action_dispatch.signed_cookie_salt

    secret_key_base = Rails.application.secret_key_base

    key_generator = ActiveSupport::KeyGenerator.new(
      secret_key_base, iterations: 1000, hash_digest_class: OpenSSL::Digest::SHA1
    )
    key_len = ActiveSupport::MessageEncryptor.key_len

    old_encrypted_secret = key_generator.generate_key(authenticated_encrypted_cookie_salt, key_len)
    old_signed_secret = key_generator.generate_key(signed_cookie_salt)

    cookies.rotate :encrypted, old_encrypted_secret
    cookies.rotate :signed, old_signed_secret
  end
end
