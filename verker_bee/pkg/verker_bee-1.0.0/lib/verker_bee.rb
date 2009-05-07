# John Howe
# Week 3::SWINE FLU!!
# 2009.05.01

module VerkerBee
  VERSION = '1.0.0'

  class Work
    attr_reader :dependencies, :block, :done

    def initialize dependencies, block
      @dependencies = dependencies
      @block = block
      @done = false
    end

    def run
      @done = true
      @block.call
    end
  end

  @tasks = {}

  class << self
    def tasks
      @tasks
    end

    def recipe &block
      raise ArgumentError, "A block is required for a Recipe" unless block_given?
      module_eval(&block)
    end

    def work name, *dependencies, &block
      raise ArgumentError, "A block is required for Work" unless block_given?
      @tasks[name] = VerkerBee::Work.new dependencies, block
    end

    def run name, iterations = 0
      raise ArgumentError, "Task: #{name.to_s} invalid" unless @tasks.key? name
      puts "#{'  ' * iterations}running #{name}"
      @tasks[name].dependencies.each do |current_job|
        if @tasks[current_job].done
          puts "#{'  ' * (iterations + 1)}not running #{current_job} - already met dependency"
        else
          self.run current_job, iterations + 1
        end
      end
      @tasks[name].run
    end
  end
end
