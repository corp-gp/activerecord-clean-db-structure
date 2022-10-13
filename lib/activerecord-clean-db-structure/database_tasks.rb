module ActiveRecordCleanDbStructure
  module DatabaseTasks

    def dump_schema(*args)
      super
      _run_postprocess_structure
    end

    private def _run_postprocess_structure
      filenames = []
      filenames << ENV['DB_STRUCTURE'] if ENV.key?('DB_STRUCTURE')

      if ActiveRecord::VERSION::MAJOR >= 6
        # Based on https://github.com/rails/rails/pull/36560/files
        databases = ActiveRecord::Tasks::DatabaseTasks.setup_initial_database_yaml
        ActiveRecord::Tasks::DatabaseTasks.for_each(databases) do |spec_name|
          Rails.application.config.paths['db'].each do |path|
            filenames << File.join(path, spec_name + '_structure.sql')
          end
        end
      end

      unless filenames.present?
        Rails.application.config.paths['db'].each do |path|
          filenames << File.join(path, 'structure.sql')
        end
      end

      filenames.each do |filename|
        cleaner = CleanDump.new(
          File.read(filename),
          **Rails.application.config.activerecord_clean_db_structure
        )
        cleaner.run
        File.write(filename, cleaner.dump)
      end
    end
  end
end