# Copyright (C) 2012-2023 Zammad Foundation, https://zammad-foundation.org/

class Controllers::TablesControllerPolicy < Controllers::ApplicationControllerPolicy
  default_permit!('admin.table_search')
end
