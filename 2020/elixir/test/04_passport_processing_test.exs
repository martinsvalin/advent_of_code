defmodule PassportProcessingTest do
  use ExUnit.Case

  @sample """
  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
  """

  describe "count_validish_passports/1" do
    assert PassportProcessing.count_validish_passports(@sample) == 2
  end

  describe "passport_validish?/1" do
    test "passport with all fields present is valid" do
      assert PassportProcessing.passport_validish?(%{
               byr: "byr",
               iyr: "iyr",
               eyr: "eyr",
               hgt: "hgt",
               hcl: "hcl",
               ecl: "ecl",
               pid: "pid",
               cid: "cid"
             })
    end

    test "passport with a required field missing is not valid" do
      refute PassportProcessing.passport_validish?(%{
               iyr: "iyr",
               eyr: "eyr",
               hgt: "hgt",
               hcl: "hcl",
               ecl: "ecl",
               pid: "pid",
               cid: "cid"
             })
    end

    test "passport with an optional field missing is valid" do
      assert PassportProcessing.passport_validish?(%{
               byr: "byr",
               iyr: "iyr",
               eyr: "eyr",
               hgt: "hgt",
               hcl: "hcl",
               ecl: "ecl",
               pid: "pid"
             })
    end
  end

  @valid_passport %{
    byr: "1978",
    iyr: "2012",
    eyr: "2022",
    hgt: "178cm",
    hcl: "#c0ffee",
    ecl: "blu",
    pid: "012345678",
    cid: "se"
  }

  describe "passport_validish?/2" do
    test "passport with valid values for all required fields is valid" do
      @valid_passport
      |> PassportProcessing.passport_validish?(:strict)
      |> assert
    end

    test "birth year out of range" do
      refute passport(:byr, "1919")
      assert passport(:byr, "1920")
      assert passport(:byr, "2002")
      refute passport(:byr, "2003")
    end

    test "issue year out of range" do
      refute passport(:iyr, "2009")
      assert passport(:iyr, "2010")
      assert passport(:iyr, "2020")
      refute passport(:iyr, "2021")
    end

    test "expiration year out of range" do
      refute passport(:eyr, "2019")
      assert passport(:eyr, "2020")
      assert passport(:eyr, "2030")
      refute passport(:eyr, "2031")
    end

    test "height" do
      refute passport(:hgt, "149cm")
      assert passport(:hgt, "150cm")
      assert passport(:hgt, "193cm")
      refute passport(:hgt, "194cm")

      refute passport(:hgt, "58in")
      assert passport(:hgt, "59in")
      assert passport(:hgt, "76in")
      refute passport(:hgt, "77in")

      refute passport(:hgt, "100")
    end

    test "hair color" do
      assert passport(:hcl, "#c0ffee")
      refute passport(:hcl, "c0ffee")
      refute passport(:hcl, "#ff")
      refute passport(:hcl, "#112233a")
      refute passport(:hcl, "#apples")
    end

    test "eye color" do
      assert passport(:ecl, "amb")
      assert passport(:ecl, "blu")
      assert passport(:ecl, "brn")
      assert passport(:ecl, "gry")
      assert passport(:ecl, "grn")
      assert passport(:ecl, "hzl")
      assert passport(:ecl, "oth")
      refute passport(:ecl, "foo")
    end

    test "passport id" do
      assert passport(:pid, "123456789")
      assert passport(:pid, "012345678")
      refute passport(:pid, "12345678a")
      refute passport(:pid, "0123456789")
      refute passport(:pid, "01234567")
    end
  end

  def passport(field, value) do
    Map.put(@valid_passport, field, value)
    |> PassportProcessing.passport_validish?(:strict)
  end

  @invalid_passports """
  eyr:1972 cid:100
  hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

  iyr:2019
  hcl:#602927 eyr:1967 hgt:170cm
  ecl:grn pid:012533040 byr:1946

  hcl:dab227 iyr:2012
  ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

  hgt:59cm ecl:zzz
  eyr:2038 hcl:74454a iyr:2023
  pid:3556412378 byr:2007
  """

  @valid_passports """
  pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  hcl:#623a2f

  eyr:2029 ecl:blu cid:129 byr:1989
  iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

  hcl:#888785
  hgt:164cm byr:2001 iyr:2015 cid:88
  pid:545766238 ecl:hzl
  eyr:2022

  iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  """

  test "sample invalid passwords are all invalid" do
    assert PassportProcessing.count_validish_passports(@invalid_passports, :strict) == 0
  end

  test "sample valid passwords are all valid" do
    assert PassportProcessing.count_validish_passports(@valid_passports, :strict) == 4
  end
end
