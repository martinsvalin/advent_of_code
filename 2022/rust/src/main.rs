use std::env;
use std::fs::read_to_string;

mod calorie_counting;

fn main() {
    let arg = env::args_os().last().unwrap();
    match arg.to_str() {
        Some("1") => print_solutions("1", calorie_counting::part1, calorie_counting::part2),

        _ => println!("Usage: cargo run <day>, where day is 1"),
    };
}

fn print_solutions(day: &str, part1: fn(&String) -> String, part2: fn(&String) -> String) -> () {
    let input = read_to_string(format!("../input/{day}")).unwrap();
    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}
