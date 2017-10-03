require 'digest'
require 'active_record'

module Seed
  class Configuration
    def initialize
      # error if adapter is not mysql
      raise 'seed-snapshot support only MySQL' unless adapter_name == 'Mysql2'
    end

    def adapter_name
      @adapter_name ||= ActiveRecord::Base.connection.adapter_name
    end

    def schema_version
      @schema_version ||= Digest::SHA1.hexdigest(ActiveRecord::Migrator.get_all_versions.sort.join)
    end

    def database_options
      @options ||= ActiveRecord::Base.connection.raw_connection.query_options
    end

    # ${Rails.root}/tmp/dump
    def base_path
      Pathname.new(Dir.pwd).join('tmp').join('dump')
    end

    # ${Rails.root}/tmp/dump/123456789.sql'
    def current_version_path
      base_path.join(schema_version.to_s + '.sql')
    end

    def make_tmp_dir
      FileUtils.mkdir_p(base_path) unless File.exist?(base_path)
    end
  end
end
