require 'spec_helper'
require 'rake'

RSpec.describe CodeQuality do
  it "has a version number" do
    expect(CodeQuality::VERSION).not_to be nil
  end

  def load_rake_tasks
    # Rake.application.rake_require 'tasks/code_quality.rake' # Can't find tasks/code_quality.rake
    Rake::Task.send :load, 'tasks/code_quality.rake'
  end

  def run_rake(task_name)
    ENV["CI"] = 'true'
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  end

  it "load rake task" do
    expect{ Rake::Task['code_quality'] }.to raise_error(RuntimeError) # "Don't know how to build task 'code_quality'"

    load_rake_tasks

    expect{ Rake::Task['code_quality'] }.not_to raise_error
  end

  describe "rake code_quality", type: :task do
    before { load_rake_tasks }

    it "work for ruby project" do
      expect { run_rake 'code_quality' }.not_to raise_error
    end

    it ":quality_audit:rubycritic" do
      expect { run_rake 'code_quality:quality_audit:rubycritic' }.to output(/## Rubycritic/).to_stdout
    end

    it ":quality_audit:rubocop" do
      expect { run_rake 'code_quality:quality_audit:rubocop' }.to output(/## rubocop/).to_stdout
    end

    it ":quality_audit:metric_fu" do
      expect { run_rake 'code_quality:quality_audit:metric_fu' }.to output(/## metric_fu/).to_stdout
    end
  end
end