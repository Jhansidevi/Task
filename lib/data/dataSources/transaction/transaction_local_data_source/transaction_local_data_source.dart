import '../../../../../domain/entities/transaction_entity.dart';
import '../../../models/transaction/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getAllTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final List<TransactionModel> dummyTransactions = [
      TransactionModel(
        id: '1',
        type: TransactionType.expense,
        title: 'Grocery Shopping',
        category: 'Groceries',
        amount: 1200.0,
        date: '26/07/2025',
      ),
      TransactionModel(
        id: '2',
        type: TransactionType.expense,
        title: 'Online Course',
        category: 'Education',
        amount: 800.0,
        date: '20/02/2025',
      ),
      TransactionModel(
        id: '3',
        type: TransactionType.income,
        title: 'Freelance Income',
        category: 'Income',
        amount: 5000.0,
        date: '17/06/2025',
      ),
      TransactionModel(
        id: '4',
        type: TransactionType.expense,
        title: 'Dinner Out',
        category: 'Food',
        amount: 600.0,
        date: '15/04/2025',
      ),
      TransactionModel(
        id: '5',
        type: TransactionType.expense,
        title: 'Electricity Bill',
        category: 'Utilities',
        amount: 950.0,
        date: '10/03/2025',
      ),
      TransactionModel(
        id: '6',
        type: TransactionType.expense,
        title: 'Book Purchase',
        category: 'Education',
        amount: 450.0,
        date: '05/05/2025',
      ),
      TransactionModel(
        id: '7',
        type: TransactionType.income,
        title: 'Salary',
        category: 'Income',
        amount: 15000.0,
        date: '28/07/2025',
      ),
      TransactionModel(
        id: '8',
        type: TransactionType.expense,
        title: 'Gym Membership',
        category: 'Health',
        amount: 2500.0,
        date: '22/07/2025',
      ),
      TransactionModel(
        id: '9',
        type: TransactionType.expense,
        title: 'Car Repair',
        category: 'Transport',
        amount: 4000.0,
        date: '30/06/2025',
      ),
      TransactionModel(
        id: '10',
        type: TransactionType.expense,
        title: 'Movie Tickets',
        category: 'Entertainment',
        amount: 300.0,
        date: '12/05/2025',
      ),
      TransactionModel(
        id: '11',
        type: TransactionType.expense,
        title: 'Coffee',
        category: 'Food',
        amount: 150.0,
        date: '24/07/2025',
      ),
      TransactionModel(
        id: '12',
        type: TransactionType.expense,
        title: 'Clothes Shopping',
        category: 'Shopping',
        amount: 1800.0,
        date: '19/06/2025',
      ),
      TransactionModel(
        id: '13',
        type: TransactionType.income,
        title: 'Dividend',
        category: 'Income',
        amount: 1200.0,
        date: '01/04/2025',
      ),
      TransactionModel(
        id: '14',
        type: TransactionType.expense,
        title: 'Internet Bill',
        category: 'Utilities',
        amount: 800.0,
        date: '08/03/2025',
      ),
      TransactionModel(
        id: '15',
        type: TransactionType.expense,
        title: 'Birthday Gift',
        category: 'Gifts',
        amount: 700.0,
        date: '25/02/2025',
      ),
      TransactionModel(
        id: '16',
        type: TransactionType.expense,
        title: 'Birthday Gift',
        category: 'Gifts',
        amount: 700.0,
        date: '26/07/2025',
      ),
      TransactionModel(
        id: '16',
        type: TransactionType.expense,
        title: 'Birthday Dress',
        category: 'Gifts',
        amount: 800.0,
        date: '26/07/2025',
      ),
      TransactionModel(
        id: '16',
        type: TransactionType.expense,
        title: 'Birthday Gift',
        category: 'Gifts',
        amount: 700.0,
        date: '26/07/2025',
      ),
      TransactionModel(
        id: '16',
        type: TransactionType.expense,
        title: 'Festival Dress',
        category: 'Festival',
        amount: 800.0,
        date: '25/07/2025',
      ),
    ];
    return dummyTransactions;
  }
}
