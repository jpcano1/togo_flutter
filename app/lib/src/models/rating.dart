class Rating {
  
  double score;
  String userId;

  Rating(this.score, this.userId);

  Rating.fromMap(Map<String, dynamic> map) {
    this.score = double.tryParse(map["score"]);
    this.userId = map["userId"];
  }

  toMap() {
    return {
      "score": this.score,
      "userId": this.userId
    };
  }
}