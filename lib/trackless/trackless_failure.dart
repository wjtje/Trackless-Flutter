class TracklessFailure {
  final int code;
  final int detailCode;

  TracklessFailure(this.code, {this.detailCode = 0});

  @override
  String toString() {
    return ' (Code: ${this.code} - ${this.detailCode})';
  }
}
