enum RockPaperScissors {
    Rock,
    Paper,
    Scissors,
}

pub fn part1(input: &String) -> String {
    let total_score = input
        .lines()
        .map(|l| l.split(' ').collect::<Vec<&str>>())
        .map(|vec| score(vec))
        .sum::<i32>();
    format!("{}", total_score)
}

fn score(vec: Vec<&str>) -> i32 {
    use RockPaperScissors::*;
    let opponent = match vec[0] {
        "A" => Rock,
        "B" => Paper,
        "C" => Scissors,
        other => panic!("unexpected input {other:?}"),
    };
    let me = match vec[1] {
        "X" => Rock,
        "Y" => Paper,
        "Z" => Scissors,
        other => panic!("unexpected input {other:?}"),
    };
    score_win(&opponent, &me) + score_shape(&me)
}

fn score_win(opponent: &RockPaperScissors, me: &RockPaperScissors) -> i32 {
    use RockPaperScissors::*;
    match (opponent, me) {
        (Rock, Paper) => 6,
        (Rock, Rock) => 3,
        (Rock, Scissors) => 0,
        (Paper, Scissors) => 6,
        (Paper, Paper) => 3,
        (Paper, Rock) => 0,
        (Scissors, Rock) => 6,
        (Scissors, Scissors) => 3,
        (Scissors, Paper) => 0,
    }
}

fn score_shape(shape: &RockPaperScissors) -> i32 {
    use RockPaperScissors::*;
    match shape {
        Rock => 1,
        Paper => 2,
        Scissors => 3,
    }
}

pub fn part2(_input: &String) -> String {
    "well".to_string()
}
