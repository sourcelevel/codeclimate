# frozen_string_literal: true

module CC
  module Analyzer
    module Normalizers
      module Extensions
        class RubocopExtension
          CONFIG_FILE_PATH = '.rubocop.yml'.freeze

          attr_reader :available_extensions, :code_path

          def initialize(available_extensions, code_path)
            @available_extensions = available_extensions
            @code_path = code_path
          end

          def call
            begin
              extensions = config_file["require"]

              return if extensions.empty?

              supported_extensions = available_extensions & extensions

              config_file["require"] = supported_extensions

              normalize!
            rescue Errno::ENOENT
            end
          end

          private

          def config_file
            @config_file ||= YAML.load_file(config_file_path)
          end

          def normalize!
            File.open(config_file_path, "w") do |file|
              YAML.dump(config_file, file)
            end
          end

          def config_file_path
            @config_file_path ||= "#{code_path}/#{CONFIG_FILE_PATH}"
          end
        end
      end
    end
  end
end
