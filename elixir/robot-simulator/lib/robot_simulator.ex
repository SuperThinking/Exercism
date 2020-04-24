defmodule RobotSimulator do
  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    robot = %{
      "direction" => direction,
      "position" => position,
      "error" => nil
    }

    robot = case direction do
      :north -> Map.put(robot, "direction", direction)
      :south -> Map.put(robot, "direction", direction)
      :east -> Map.put(robot, "direction", direction)
      :west -> Map.put(robot, "direction", direction)
      _ -> Map.put(robot, "error", {:error, "invalid direction"})
    end

    robot = case position do
      {x, y} ->
        with true <- is_integer(x),
            true <- is_integer(y) do
              robot
        else
          _ -> Map.put(robot, "error", {:error, "invalid position"})
        end
      _ ->
        robot = Map.put(robot, "error", {:error, "invalid position"})
    end

    case check_for_error(robot) do
      true -> Map.get(robot, "error")
      false -> robot
    end

  end

  def check_for_error(robot) do
    case Map.get(robot, "error") do
      nil -> false
      _ -> true
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    robot = rec(robot, 0, instructions)
    case check_for_error(robot) do
      true -> Map.get(robot, "error", nil)
      false -> robot
    end
  end

  def rec(robot, index, instructions) do
    if index < String.length(instructions) do
      case String.at(instructions, index) do
        "R" ->
          robot = Map.put(robot, "direction", next_direction(Map.get(robot, "direction"), "R"))
          rec(robot, index+1, instructions)
        "L" ->
          robot = Map.put(robot, "direction", next_direction(Map.get(robot, "direction"), "L"))
          rec(robot, index+1, instructions)
        "A" ->
          robot = Map.put(robot, "position", move_robot(Map.get(robot, "direction"), Map.get(robot, "position")))
          rec(robot, index+1, instructions)
        _ ->
          Map.put(robot, "error", {:error, "invalid instruction"})
      end
    else
      robot
    end
  end

  def next_direction(prev_direction, move) do
    case move do
      "R" ->
        case prev_direction do
          :north -> :east
          :east -> :south
          :south -> :west
          :west -> :north
        end
      "L" ->
        case prev_direction do
          :north -> :west
          :east -> :north
          :south -> :east
          :west -> :south
        end
    end
  end

  def move_robot(direction, position) do
    {x, y} = position
    case direction do
      :north -> {x, y+1}
      :south -> {x, y-1}
      :east -> {x+1, y}
      :west -> {x-1, y}
    end
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    case check_for_error(robot) do
      true -> Map.get(robot, "error", nil)
      false -> Map.get(robot, "direction", {:error, "robot not created"})
    end
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    case check_for_error(robot) do
      true -> Map.get(robot, "error", nil)
      false -> Map.get(robot, "position", {:error, "robot not created"})
    end
  end
end
