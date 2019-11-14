require "spec_helper"

module CC::Analyzer::Normalizers
  describe Extension do
    describe "#run" do
      it "ignores engine when there is no normalizer for it" do
        extension = Extension.new("reek", [], "/tmp/code")

        expect { extension.call }.to_not raise_error
      end

      it "ignores custom engine name when there is no normalizer for it" do
        extension = Extension.new("sass-lint", [], "/tmp/code")

        expect { extension.call }.to_not raise_error
      end

      it "calls normalizer class for engine" do
        extension = Extension.new("rubocop", [], "/tmp/code")

        expect_any_instance_of(CC::Analyzer::Normalizers::Extensions::RubocopExtension).to receive(:call)
        extension.call
      end
    end
  end
end
