import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'model.dart';

class AppWriteClient {
  Client client = Client();
  // Account? auth;
  // Database? db;
  String balanceCollectionId = '617ddfb859893';
  String transactionCollectionId = '617ddfa27af1b';

  AppWriteClient() {
    client
        .setEndpoint('http://localhost:1111/v1') // Your Appwrite Endpoint
        .setProject('615d24b79c735') // Your project ID
        .setSelfSigned();
  }

  Future<void> signup(String email, String password) async {
    Account auth = Account(client);
    try {
      await auth.create(email: email, password: password, name: email);
    } catch (e) {
      print(e);
    }
  }

  Future<String?> login(String email, String password) async {
    Account auth = Account(client);
    try {
      var response = await auth.createSession(email: email, password: password);
      return response.$id;
    } catch (e) {
      print('Error in login ' + e.toString());
    }
  }

  Future<void> logout(String sessionId) async {
    Account auth = Account(client);
    await auth.deleteSession(sessionId: sessionId);
  }

  // create balance
  Future<void> createBalance(String email) async {
    print('Call to createBalance for => $email');
    Database db = Database(client);
    try {
      await db.createDocument(collectionId: balanceCollectionId, data: {
        'email': email,
        'balance': 0,
      }, write: [
        '*'
      ], read: [
        '*'
      ]);
    } catch (e) {
      print('Error in createBalance ' + e.toString());
    }
  }

  Future<String?> getBalanceDocId(String email) async {
    print('Call to getBalanceId for => $email');
    Database db = Database(client);
    try {
      DocumentList response = await db.listDocuments(
          collectionId: balanceCollectionId, filters: ['email=$email']);

      if (response.documents.length > 0) {
        return response.documents[0].$id;
      } else {
        print('No document found');
      }
    } catch (e) {
      print('Error getting balance document for ' + e.toString());
    }
  }

  Future<int?> getBalance(String id) async {
    print('Call to getBalance for => $id');
    Database db = Database(client);
    try {
      Document response = await db.getDocument(
          collectionId: balanceCollectionId, documentId: id);

      return response.data['balance'];
    } catch (e) {
      print('Error getting balance document for ' + e.toString());
    }
  }

  Future<String?> getTransactionDocId(String email) async {
    print('Call to getTransactionDocId for => $email');
    Database db = Database(client);
    try {
      DocumentList response = await db.listDocuments(
          collectionId: transactionCollectionId, filters: ['email=$email']);

      return response.documents[0].$id;
    } catch (e) {
      print('Error getting balance document for ' + e.toString());
    }
  }

  Future<List<Transaction>?> getTransaction(String id) async {
    print('Call to getTransaction for => $id');
    Database db = Database(client);
    try {
      Document response = await db.getDocument(
          collectionId: transactionCollectionId, documentId: id);

      print(response.data['transactions']);
      List<Transaction> trans = [];
      if (response.data['transactions'] != null)
        for (var t in response.data['transactions']) {
          if (t == null) {
            break;
          }
          trans.add(Transaction.fromJson(t));
        }

      return trans;
    } catch (e) {
      print('Error getting transactions document for ' + e.toString());
    }
  }

  // update balance
  Future<void> updateBalance(String id, int balance, String email) async {
    print('Call to updateBalance for => $id');
    Database db = Database(client);
    try {
      await db.updateDocument(
        collectionId: balanceCollectionId,
        documentId: id,
        data: {'balance': balance, 'email': email},
      );
    } catch (e) {
      print('Error updating balance document for ' + e.toString());
    }
  }

  // create transaction
  Future<void> createTransaction(String email) async {
    print('Call to createTransactions for => $email');
    Database db = Database(client);
    try {
      db.createDocument(collectionId: transactionCollectionId, data: {
        'email': email,
        'transactions': [],
      }, write: [
        '*'
      ], read: [
        '*'
      ]);
    } catch (e) {
      print('Error creating transactions document for ' + e.toString());
    }
  }

  // update transaction
  Future<void> updateTransaction(
      String id, List<Transaction> transactions, String email) async {
    print('Call to updateTransaction for => $id');
    Database db = Database(client);
    try {
      print(transactions.map((e) => e.toJson()).toList());
      await db.updateDocument(
        collectionId: transactionCollectionId,
        documentId: id,
        data: {
          'transactions': transactions.map((e) => e.toJson()).toList(),
          'email': email
        },
      );
    } catch (e) {
      print('Error updating balance document for ' + e.toString());
    }
  }
}
