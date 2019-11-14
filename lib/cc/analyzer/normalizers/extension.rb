module CC
  module Analyzer
    module Normalizers
      class Extension
        attr_reader :name, :extensions, :code_path

        def initialize(name, available_extensions = [], code_path = "")
          @name = name
          @extensions = available_extensions
          @code_path = code_path
        end

        def call
          if Kernel.const_defined?(engine_normalizer_const)
            engine_normalizer_klass = Kernel.const_get(engine_normalizer_const)

            engine_normalizer_klass.new(extensions, code_path).call
          end
        end

        private

        def namespace
          self.class.to_s.deconstantize
        end

        def engine_normalizer_const
          "#{namespace}::Extensions::#{name.underscore.classify}Extension"
        end
      end
    end
  end
end
