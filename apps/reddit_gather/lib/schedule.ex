defmodule RedditGather.Schedule do
  @moduledoc ~S"""
  Schedules jobs based on their priority class.

  The higher priority a class has, the more often it will run. Priorities
  are provided during initialization, and cannot be changed.

  It is assumed that only one job can run at once, and all jobs take the
  same amount of time to complete. As well, jobs cannot be (usefully) interupted
  or restarted.
  """
  alias RedditGather.Schedule

  defstruct total_run_count: 0, classes: [], total_weights: 0

  defmodule Class do
    @moduledoc false
    defstruct name: :unknown_class, weight: 0, run_count: 0
  end

  # Note: up next is to write the algorithm that finds the class which
  # has the greatest diffrence between it's historical run percentage and
  # actual run percentage

  @doc "Creates a schedule a collection of class priorities"
  def with_priorities(priorities) do
    Stream.unfold(start_state(priorities), &generate_next/1)
  end

  defp generate_next(state) do
    {next, _} = state.classes
    |> Enum.zip(Stream.cycle([state]))
    |> Enum.max_by(&run_fraction_delta/1)

    {next.name, update_for_run(state, next)}
  end

  defp run_fraction_delta({class, state}) do
    expected = expected_run_fraction(class, state)
    actual = run_fraction(class, state)
    expected - actual
  end

  defp expected_run_fraction(class, state) do
    class.weight / state.total_weights
  end

  defp run_fraction(class, state) do
    class.run_count / max(state.total_run_count, 1)
  end

  defp update_for_run(state, run_class) do
    %{state | :total_run_count => state.total_run_count + 1,
              :classes => update_run_count(run_class, state.classes)}
  end

  def update_run_count(run_class, classes) do
    Enum.map classes, fn class ->
      if class.name == run_class.name do
        %{class | :run_count => class.run_count + 1}
      else
        class
      end
    end
  end

  defp start_state(priorities) do
    classes = make_classes(priorities)
    total_weights = classes
    |> Enum.map(fn class -> class.weight end)
    |> Enum.sum()

    %Schedule{total_weights: total_weights, classes: classes}
  end

  defp make_classes(priorities) do
    for {name, weight} <- priorities do
      %Class{name: name, weight: weight}
    end
  end
end
