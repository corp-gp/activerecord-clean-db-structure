require 'activerecord-clean-db-structure/railtie'
require 'activerecord-clean-db-structure/clean_dump'
require 'activerecord-clean-db-structure/database_tasks'

ActiveSupport.on_load(:active_record) do
  if defined?(ActiveRecord::Tasks::DatabaseTasks)
    ActiveRecord::Tasks::DatabaseTasks.singleton_class.prepend(ActiveRecordCleanDbStructure::DatabaseTasks)
  end
end