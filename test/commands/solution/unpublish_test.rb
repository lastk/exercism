require 'test_helper'

class Solution::UnpublishTest < ActiveSupport::TestCase
  test "unpublishes solution" do
    solution = create :concept_solution
    iteration = create :iteration, solution: solution
    iteration.solution.update!(published_iteration: iteration, published_at: Time.current)

    Solution::Unpublish.(solution)

    assert_nil solution.published_iteration
    assert_nil solution.published_at
  end

  test "solution snippet updated to latest active iteration's snippet" do
    solution = create :concept_solution
    iteration_1 = create :iteration, solution: solution, snippet: 'aaa'
    iteration_2 = create :iteration, solution: solution, snippet: 'bbb'
    iteration_1.solution.update!(snippet: iteration_1.snippet, published_iteration: iteration_1, published_at: Time.current)

    Solution::Unpublish.(solution)

    assert_equal iteration_2.snippet, solution.snippet
  end

  test "solution num_loc updated to latest active iteration's num_loc" do
    solution = create :concept_solution
    iteration_1 = create :iteration, solution: solution, num_loc: 13
    iteration_2 = create :iteration, solution: solution, num_loc: 77
    iteration_1.solution.update!(num_loc: iteration_1.num_loc, published_iteration: iteration_1, published_at: Time.current)

    Solution::Unpublish.(solution)

    assert_equal iteration_2.num_loc, solution.num_loc
  end
end
