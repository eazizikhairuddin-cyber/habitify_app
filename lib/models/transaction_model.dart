import 'package:hive/hive.dart';

enum TransactionType { income, expense }

class TransactionModel extends HiveObject {
  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  final String id;
  String title;
  double amount;
  TransactionType type;
  String category;
  DateTime date;
  String? note;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    final value = reader.readInt();
    return value == 0 ? TransactionType.income : TransactionType.expense;
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    writer.writeInt(obj == TransactionType.income ? 0 : 1);
  }
}

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 2;

  @override
  TransactionModel read(BinaryReader reader) {
    return TransactionModel(
      id: reader.readString(),
      title: reader.readString(),
      amount: reader.readDouble(),
      type: reader.read() as TransactionType,
      category: reader.readString(),
      date: reader.readDateTime(),
      note: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeDouble(obj.amount)
      ..write(obj.type)
      ..writeString(obj.category)
      ..writeDateTime(obj.date)
      ..write(obj.note);
  }
}

class TransactionCategories {
  static const List<String> all = [
    'Food',
    'Transport',
    'Salary',
    'Shopping',
    'Health',
    'Bills',
    'Entertainment',
    'Other',
  ];
}
