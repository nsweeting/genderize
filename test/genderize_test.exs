defmodule GenderizeTest do
  use ExUnit.Case

  describe "find/1" do
    test "will work for female names" do
      assert Genderize.find("mary") == {:female, 1.0}
    end

    test "will work for male names" do
      assert Genderize.find("bob") == {:male, 0.74}
    end

    test "will work for unknown names" do
      assert Genderize.find("asdf") == {:unknown, nil}
    end
  end
end
