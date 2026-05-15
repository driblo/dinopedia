import 'package:hive/hive.dart';

class QuizStateEntry {
  QuizStateEntry({
    this.highScore = 0,
    this.checkpointTier = 0,
  });

  int highScore;
  int checkpointTier;
}

class QuizStateEntryAdapter extends TypeAdapter<QuizStateEntry> {
  @override
  final int typeId = 2;

  @override
  QuizStateEntry read(BinaryReader reader) {
    return QuizStateEntry(
      highScore: reader.readInt(),
      checkpointTier: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, QuizStateEntry obj) {
    writer
      ..writeInt(obj.highScore)
      ..writeInt(obj.checkpointTier);
  }
}
