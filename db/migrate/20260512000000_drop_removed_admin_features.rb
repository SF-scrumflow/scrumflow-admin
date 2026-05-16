class DropRemovedAdminFeatures < ActiveRecord::Migration[7.2]
  def change
    drop_table :subscriptions, if_exists: true

    drop_table :enterprises, if_exists: true
    drop_table :plans, if_exists: true
    drop_table :enterprise_features, if_exists: true
    drop_table :feature_flags, if_exists: true
    drop_table :announcements, if_exists: true
    drop_table :mailing_campaigns, if_exists: true
    drop_table :system_settings, if_exists: true
    drop_table :audit_events, if_exists: true
    drop_table :support_tickets, if_exists: true
    drop_table :api_credentials, if_exists: true
  end
end