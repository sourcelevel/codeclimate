require "spec_helper"

module CC::Analyzer::Normalizers::Extensions
  describe RubocopExtension do
    include FileSystemHelpers

    describe "#call" do
      it "removes unsupported extensions from Rubocop config file" do
        available_extensions = [
          "rubocop-performance",
          "rubocop/migrations",
          "rubocop-rails"
        ]

        rubocop_config_content = <<-eos
          require:
            - rubocop-performance
            - rubocop/migrations
            - unsupported-ext

          AllCops:
            Exclude:
              - 'bin/**/*'

          RandomCheck:
            Enabled: true
        eos

        path = "/tmp/code"
        make_file("#{path}/.rubocop.yml", rubocop_config_content)

        RubocopExtension.new(available_extensions, path).call

        normalized_extensions = YAML.load_file("#{path}/.rubocop.yml")["require"]
        expect(normalized_extensions).to_not include("unsupported-ext")
        expect(normalized_extensions.size).to eq(2)
      end

      it "ignores process when there is no config file" do
        expect { RubocopExtension.new(available_extensions, "/tmp/code").call }.to_not raise_error
      end

      private

      def available_extensions
        [
          "rubocop-performance",
          "rubocop/migrations",
          "rubocop-rails"
        ]
      end
    end
  end
end
