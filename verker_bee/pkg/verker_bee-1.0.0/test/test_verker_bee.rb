require "test/unit"
require "verker_bee"
require "stringio"
require "redgreen"

class TestVerkerBee < Test::Unit::TestCase

  def setup
    @output = StringIO.new
    $stdout = @output

    @bee = VerkerBee

    @block = Proc.new { @bee.recipe do
      work :hola, :uno, :dos, :tres do
        puts "** hola!!!"
      end

      work :uno, :dos, :tres do
        puts "** uno"
      end

      work :dos, :tres do
        puts "** dos"
      end

      work :tres do
        puts "** tres"
      end
    end }
  end

  def teardown
    $stdout = STDOUT
  end

  def test_recipe_raises_exception_when_missing_block
    assert_raise ArgumentError do
      @bee.recipe
    end
  end

  def test_recipe_happily_evals_passed_block
    actual = @bee.recipe do
      "OMFG! Swine Flu! Dance Cancelled!"
    end
    expected = "OMFG! Swine Flu! Dance Cancelled!"

    assert_equal expected, actual
  end

  def test_recipe_can_scope_a_block
    assert_block do
      @bee.recipe do
        work :dance do
          "Cancelled do to Swine Flu!!"
        end
      end
    end
  end

  def test_work_does_actually_do_work
    @bee.recipe do
      work :panic do
        "Crush, Kill, Destroy!"
      end
    end

    assert_equal "Crush, Kill, Destroy!", @bee.run(:panic)
  end

  def test_work_accepts_many_tasks
    assert_block do
      @bee.work :h1n1, :swine_flu, :run_runner_run do
        @panic
      end
    end
  end

  def test_work_runs_passed_block
    task = @bee::Work.new(:ponies, Proc.new { "Pretty!" })

    assert_equal "Pretty!", task.run
  end

  def test_work_is_marked_as_done_when_executed
    task = @bee::Work.new(:hornet, Proc.new { "Ow! That frakken hurts!" })

    assert ! task.done

    task.run

    assert task.done
  end

  def test_work_creates_tasks
    @block.call

    assert @bee.tasks.key? :hola
    assert @bee.tasks.key? :uno
    assert @bee.tasks.key? :dos
    assert @bee.tasks.key? :tres
  end

  def test_recipe_raises_exception_when_work_syntax_is_invalid
    assert_raise ArgumentError do
      VerkerBee.recipe do
        work do
          @panic
        end
      end
    end
  end

  def test_work_is_being_done
    @bee.recipe do
      work :logans_run do
        "run runner, run!"
      end
    end

    assert_equal "run runner, run!", @bee.run(:logans_run)
  end

  def test_work_runs_dependencies_first
    @bee.recipe do
      work :tofu, :garlic do
        "more please!" if VerkerBee.tasks[:tofu].done
      end

      work :garlic do
        "needs more garlic"
      end
    end

    assert_equal "more please!", @bee.run(:tofu)
  end

  def test_work_raises_error_when_task_does_not_exist
    assert_raise ArgumentError do
      @bee.run(:honey_pot)
    end
  end

  def test_work_is_not_duplicate_in_a_dependency_chain
    VerkerBee.module_eval("@cups = 0")
    @bee.recipe do
      work :reishi do
        @cups += 1
      end

      work :shizandra, :reishi do
        "sour berries, bitter mushrooms"
      end

      work :super_herbs, :shizandra, :reishi do
        "That's some sour tea! Add honey"
      end
    end

    @bee.run(:super_herbs)

    assert_equal 1, @bee.module_eval("@cups")
  end

  def test_work_with_multiple_tasks_builds_dependencies_array
    @block.call

    assert_equal @bee.tasks[:hola].dependencies, [:uno, :dos, :tres]
  end

  def test_work_creates_proper_dependency_chains
    ingredients = []
    @bee.recipe do
      work :garlic do
        ingredients << "garlic"
      end

      work :tofu, :garlic do
        ingredients << "tofu"
      end

      work :chili, :tofu, :garlic do
        ingredients << "chili"
      end
    end

    @bee.run :chili

    assert_equal [ 'garlic', 'tofu', 'chili' ], ingredients
  end

  def test_work_display
    @block.call
    
    @bee.run :hola
    
    assert_equal @output.string, "running hola\n  running uno\n    running dos\n      running tres\n** tres\n** dos\n    not running tres - already met dependency\n** uno\n  not running dos - already met dependency\n  not running tres - already met dependency\n** hola!!!\n"
  end

  def test_class_homework_api_display_assignment
    VerkerBee.recipe do
      work :sammich, :meat, :bread do
        puts "** sammich!"
      end

      work :meat, :clean do
        puts "** meat"
      end

      work :bread, :clean do
        puts "** bread"
      end

      work :clean do
        puts "** cleaning!"
      end
    end

    VerkerBee.run :sammich

    assert_equal @output.string, "running sammich\n  running meat\n    running clean\n** cleaning!\n** meat\n  running bread\n    not running clean - already met dependency\n** bread\n** sammich!\n"
  end
end
