import 'package:hive/hive.dart';

enum TransactionType { income, expense }

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? note;

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  String? _readNote(BinaryReader reader) {
    final hasNote = reader.readBool();
    if (!hasNote) return null;
    return reader.readString();
  }

  @override
  final int typeId = 10;

  @override
  TransactionModel read(BinaryReader reader) {
    return TransactionModel(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      type: TransactionType.values[reader.readInt()],
      category: reader.readString(),
      note: _readNote(reader),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeDouble(obj.amount)
      ..writeInt(obj.date.millisecondsSinceEpoch)
      ..writeInt(obj.type.index)
      ..writeString(obj.category)
      ..writeBool(obj.note != null);

    if (obj.note != null) {
      writer.writeString(obj.note!);
    }
  }
}
