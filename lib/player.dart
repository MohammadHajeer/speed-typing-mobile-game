class Player {
  int id;
  String username;
  String email;
  int games;
  int bestScore;
  String mode;

  Player(this.id, this.username, this.email, this.games, this.bestScore,
      this.mode);
}

class Score {
  String score;
  String mode;
  String achievedOn;
  int time;

  Score(this.score, this.mode, this.achievedOn, this.time);
}

class LeaderBoardScore {
  int id;
  String username;
  String mode;
  int score;
  int rank;

  LeaderBoardScore(this.id, this.username, this.mode, this.score, this.rank);
}
