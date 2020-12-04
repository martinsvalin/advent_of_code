defmodule PassportProcessing do
  def count_validish_passports(input, mode \\ :only_check_fields_present) do
    input
    |> parse_into_passports()
    |> Enum.count(&passport_validish?(&1, mode))
  end

  # known atoms
  [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]

  defp parse_into_passports(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(fn raw_passport ->
      fields = Regex.scan(~r/\w{3}:\S+/, raw_passport)

      Map.new(fields, fn [field] ->
        [k, v] = String.split(field, ":")
        {String.to_existing_atom(k), v}
      end)
    end)
  end

  def passport_validish?(passport, mode \\ :only_check_fields_present)

  def passport_validish?(
        %{
          byr: birth_year,
          iyr: issue_year,
          eyr: expiration_year,
          hgt: height,
          hcl: hair_color,
          ecl: eye_color,
          pid: passport_id
          # cid: _optional
        },
        mode
      ) do
    mode == :only_check_fields_present ||
      (year_in_range?(birth_year, 1920..2002) &&
         year_in_range?(issue_year, 2010..2020) &&
         year_in_range?(expiration_year, 2020..2030) &&
         valid_height(height) &&
         valid_hair_color(hair_color) &&
         valid_eye_color(eye_color) &&
         valid_id(passport_id))
  end

  def passport_validish?(_, _), do: false

  defp year_in_range?(year, range) do
    case Integer.parse(year) do
      {year_as_int, ""} -> String.length(year) == 4 && year_as_int in range
      _ -> false
    end
  end

  defp valid_height(height) do
    {h, unit} = String.split_at(height, -2)

    case {Integer.parse(h), unit} do
      {{h, ""}, "cm"} -> h in 150..193
      {{h, ""}, "in"} -> h in 59..76
      _ -> false
    end
  end

  defp valid_hair_color("#" <> hex) when byte_size(hex) == 6 do
    match?({_, ""}, Integer.parse(hex, 16))
  end

  defp valid_hair_color(_), do: false

  defp valid_eye_color(color) do
    color in ~w(amb blu brn gry grn hzl oth)
  end

  defp valid_id(pid) do
    byte_size(pid) == 9 && Enum.all?(to_charlist(pid), &(&1 in ?0..?9))
  end
end
