# Copyright (C) 2012-2023 Zammad Foundation, https://zammad-foundation.org/

class NewTableApi < ActiveRecord::Migration[6.1]
  def change
    # return if it's a new setup
    return if !Setting.exists?(name: 'system_init_done')

    Permission.create_if_not_exists(
      name:        'admin.table_search',
      note:        'Manage %s',
      preferences: {
        translations: ['Table Search']
      },
    )
  end
end
