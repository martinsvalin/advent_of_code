use core::cmp::Ordering;

#[derive(Clone, Copy)]
enum RockPaperScissors {
    Rock,
    Paper,
    Scissors,
}

struct Game {
    opponent: RockPaperScissors,
    me: RockPaperScissors,
}

impl PartialEq for RockPaperScissors {
    fn eq(self: &Self, rhs: &Self) -> bool {
        use RockPaperScissors::*;
        match (self, rhs) {
            (Rock, Rock) => true,
            (Paper, Paper) => true,
            (Scissors, Scissors) => true,
            _ => false,
        }
    }
}

impl PartialOrd for RockPaperScissors {
    fn partial_cmp(self: &Self, rhs: &Self) -> Option<Ordering> {
        use Ordering::*;
        use RockPaperScissors::*;
        match (self, rhs) {
            (Rock, Paper) => Some(Less),
            (Paper, Scissors) => Some(Less),
            (Scissors, Rock) => Some(Less),

            (Rock, Rock) => Some(Equal),
            (Paper, Paper) => Some(Equal),
            (Scissors, Scissors) => Some(Equal),

            (Rock, Scissors) => Some(Greater),
            (Paper, Rock) => Some(Greater),
            (Scissors, Paper) => Some(Greater),
        }
    }
}

pub fn part1(input: &String) -> String {
    let total_score: i32 = parse(input).map(to_shapes).map(score).sum();
    format!("{}", total_score)
}

fn parse(input: &String) -> impl Iterator<Item = Vec<&str>> {
    input.lines().map(|l| l.split(' ').collect())
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
    use Ordering::*;
    match game.me.partial_cmp(&game.opponent).unwrap() {
        Greater => 6,
        Equal => 3,
        Less => 0,
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
    let total_score: i32 = parse(input).map(to_shapes_part2).map(score).sum();
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
    let options = [Rock, Paper, Scissors].iter();

    let me = match strings[1] {
        "X" => options.clone().find(|shape| shape < &&opponent),
        "Y" => options.clone().find(|shape| shape == &&opponent),
        "Z" => options.clone().find(|shape| shape > &&opponent),
        other => panic!("unexpected input {other:?}"),
    }
    .unwrap();

    Game { opponent, me: *me }
}
