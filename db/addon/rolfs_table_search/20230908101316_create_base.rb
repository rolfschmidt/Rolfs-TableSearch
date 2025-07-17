# Copyright (C) 2012-2025 Zammad Foundation, https://zammad-foundation.org/

class CreateBase < ActiveRecord::Migration[4.2]
  def self.up
    Permission.create_if_not_exists(
      name:        'admin.table_search',
      preferences: {
        translations: ['Table Search']
      },
    )
  end

  def self.down
    Permission.find_by(name: 'admin.table_search').destroy
  end
end
