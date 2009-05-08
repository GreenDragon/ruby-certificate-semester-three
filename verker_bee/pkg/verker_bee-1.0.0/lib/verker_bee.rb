# John Howe
# Week 4::No Drama H1N1, it was released back in the 70's
# Now with Threads!
# 2009.05.07

module VerkerBee
  VERSION = '1.1.0'

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
      module_eval(&block)
    end

    def work name, *dependencies, &block
      @tasks[name] = VerkerBee::Work.new dependencies, block
    end

    def run name, iterations = 0
      raise ArgumentError, "Can not find task: #{name} " unless @tasks.key? name
      threads = []

      puts "#{'  ' * iterations}running #{name}"
      threads << Thread.new do
        @tasks[name].dependencies.each do |current_job|
          if @tasks[current_job].done
            puts "#{'  ' * (iterations + 1)}not running #{current_job} - already met dependency"
          else
            self.run current_job, iterations + 1
          end
        end
      end
      threads.each { |thread| thread.join }
      @tasks[name].run
    end
  end
end
