defmodule ParticleSwarm do
  @moduledoc """
  Dec 20 - Particle Swarm

  We have a list of particles with their position, velocity and acceleration
  all given as <X, Y, Z> triplets. The particles are listed 0 and up.

  1. In the long term, which particle stays the closest to <0, 0, 0>?
  """

  @doc """
  Return id of the particle that stays closest to origo in the long run
  """
  def stays_closest(input) do
    input
    |> parse()
    |> only_lowest_acceleration()
    |> tick_until_increasing()
    |> Enum.sort_by(fn {id, %{d: d, v: v, a: a}} ->
         {manhattan(a), manhattan(v), manhattan(d), id}
       end)
    |> List.first()
    |> elem(0)
  end

  def only_lowest_acceleration(particles) do
    min =
      particles
      |> Enum.map(fn {_, %{a: a}} -> manhattan(a) end)
      |> Enum.min()

    Enum.filter(particles, fn {_, %{a: a}} -> manhattan(a) == min end)
  end

  @doc false
  def tick_until_increasing([{_, %{a: [0, 0, 0]}} | _] = particles) do
    particles
  end

  def tick_until_increasing(particles) do
    next = tick(particles)

    case Enum.all?(next, &increasing_in_distance_and_velocity?/1) do
      true -> next
      false -> tick_until_increasing(next)
    end
  end

  @doc false
  def tick(particles) do
    for {id, %{d: d, v: v, a: a}} <- particles, nv = increase(v, a), nd = increase(d, nv) do
      {id, %{
        d: nd,
        v: nv,
        a: a,
        dd: manhattan(nd) - manhattan(d),
        dv: manhattan(nv) - manhattan(v)
      }}
    end
  end

  def increasing_in_distance_and_velocity?({_, %{dd: dd, dv: dv}}) do
    dd > 0 and dv > 0
  end

  @doc false
  def increase([x, y, z], [dx, dy, dz]), do: [x + dx, y + dy, z + dz]

  @doc false
  def manhattan([x, y, z], [a, b, c] \\ [0, 0, 0]) do
    abs(x - a) + abs(y - b) + abs(z - c)
  end

  @regex ~r/^p=<([^>]+)>, v=<([^>]+)>, a=<([^>]+)>$/m

  @doc false
  def parse(input) do
    Regex.scan(@regex, input)
    |> Enum.with_index()
    |> Enum.map(fn {[_, distance, velocity, acceleration], index} ->
         {index, %{
           d: parse_triplet(distance),
           v: parse_triplet(velocity),
           a: parse_triplet(acceleration)
         }}
       end)
  end

  @doc false
  def parse_triplet(string) do
    string |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end
