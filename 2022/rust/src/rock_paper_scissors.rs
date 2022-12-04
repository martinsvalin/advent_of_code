enum RockPaperScissors {
    Rock,
    Paper,
    Scissors,
}

struct Game {
    opponent: RockPaperScissors,
    me: RockPaperScissors,
}

pub fn part1(input: &String) -> String {
    let total_score = input
        .lines()
        .map(|l| l.split(' ').collect::<Vec<&str>>())
        .map(to_shapes)
        .map(|vec| score(vec))
        .sum::<i32>();
    format!("{}", total_score)
}

fn to_shapes(strings: Vec<&str>) -> Game {
    use RockPaperScissors::*;
    let opponent = match strings[0] {
        "A" => Rock,
        "B" => Paper,
        "C" => Scissors,
        other => panic!("unexpected input {other:?}"),
    };
    let me = match strings[1] {
        "X" => Rock,
        "Y" => Paper,
        "Z" => Scissors,
        other => panic!("unexpected input {other:?}"),
    };
    Game { opponent, me }
}

fn score(game: Game) -> i32 {
    score_outcome(&game) + score_shape(&game.me)
}

fn score_outcome(game: &Game) -> i32 {
    use RockPaperScissors::*;
    match (&game.opponent, &game.me) {
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

pub fn part2(input: &String) -> String {
    let total_score = input
        .lines()
        .map(|l| l.split(' ').collect::<Vec<&str>>())
        .map(to_shapes_part2)
        .map(|vec| score(vec))
        .sum::<i32>();
    format!("{}", total_score)
}

fn to_shapes_part2(strings: Vec<&str>) -> Game {
    use RockPaperScissors::*;
    let opponent = match strings[0] {
        "A" => Rock,
        "B" => Paper,
        "C" => Scissors,
        other => panic!("unexpected input {other:?}"),
    };
    let me = match (&opponent, strings[1]) {
        (Rock, "X") => Scissors,     // X means Lose
        (Rock, "Y") => Rock,         // Y means Draw
        (Rock, "Z") => Paper,        // Z means Win
        (Paper, "X") => Rock,        // X means Lose
        (Paper, "Y") => Paper,       // Y means Draw
        (Paper, "Z") => Scissors,    // Z means Win
        (Scissors, "X") => Paper,    // X means Lose
        (Scissors, "Y") => Scissors, // Y means Draw
        (Scissors, "Z") => Rock,     // Z means Win
        (_, other) => panic!("unexpected input {other:?}"),
    };
    Game { opponent, me }
}
