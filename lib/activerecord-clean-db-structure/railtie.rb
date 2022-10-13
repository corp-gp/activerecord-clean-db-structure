module ActiveRecordCleanDbStructure
  class Railtie < Rails::Railtie
    config.activerecord_clean_db_structure = ActiveSupport::OrderedOptions.new
  end
end
