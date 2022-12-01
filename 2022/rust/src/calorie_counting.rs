pub fn part1(input: &String) -> String {
    grouped_sums(input).max().unwrap().to_string()
}

pub fn part2(input: &String) -> String {
    let mut groups: Vec<i32> = grouped_sums(input).collect();
    groups.sort_by(|a, b| b.cmp(a));
    groups[0..3].into_iter().sum::<i32>().to_string()
}

fn grouped_sums(input: &String) -> impl Iterator<Item = i32> + '_ {
    input
        .trim_end()
        .split("\n\n") // split into groups of calories carried per elf
        .map(sum_numbers_on_lines)
}

fn sum_numbers_on_lines(input: &str) -> i32 {
    input
        .split("\n")
        .fold(0, |acc, row| acc + row.parse::<i32>().unwrap())
}
