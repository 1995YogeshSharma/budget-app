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

    // auth = Account(client);
    // db = Database(client);
  }

  Future<User> signup(String email, String password) async {
    Account auth = Account(client);
    print("CLIENT IS ");
    print(client);
    User user =
        await auth.create(email: email, password: password, name: email);
    return user;
  }

  Future<Session> login(String email, String password) async {
    Account auth = Account(client);
    Session session =
        await auth.createSession(email: email, password: password);
    return session;
  }

  // create balance
  createBalance(String email) async {
    Database db = Database(client);
    db.createDocument(collectionId: balanceCollectionId, data: {
      'email': email,
      'balance': 0,
    }).then((response) {
      print('Document created for ' + email.toString());
    }).catchError((error) {
      print('Error creating document for ' + error.toString());
    });
  }

  // get balance
  getBalance(String email) async {
    Database db = Database(client);
    db.listDocuments(collectionId: balanceCollectionId, filters: [
      {'email': email},
    ]).then((response) {
      print('Document found for ' + email.toString());
      print(response.documents[0].data['id']);
      print(response.documents[0].data['balance']);
      return [
        response.documents[0].data['id'],
        response.documents[0].data['balance']
      ];
    }).catchError((error) {
      print('Error getting document for ' + error.toString());
    });
  }

  // update balance
  updateBalance(String id, int balance) async {
    Database db = Database(client);
    db
        .updateDocument(
            collectionId: balanceCollectionId,
            documentId: id,
            data: {'balance': balance})
        .then((response) {})
        .catchError((error) {
          print('Error updating document for ' + error.toString());
        });
  }

  // create transaction
  createTransaction(String email) async {
    Database db = Database(client);
    db.createDocument(collectionId: transactionCollectionId, data: {
      'email': email,
      'transactions': [],
    }).then((response) {
      print('Document created for ' + email.toString());
    }).catchError((error) {
      print('Error creating document for ' + error.toString());
    });
  }

  // get transaction
  getTransaction(String email) async {
    Database db = Database(client);
    db.listDocuments(collectionId: transactionCollectionId, filters: [
      {'email': email},
    ]).then((response) {
      print('Document found for ' + email.toString());
      print(response.documents[0].data['id']);
      print(response.documents[0].data['transactions']);
      return [
        response.documents[0].data['id'],
        response.documents[0].data['transactions'].map((transaction) {
          return Transaction.fromJson(transaction);
        }).toList()
      ];
    }).catchError((error) {
      print('Error getting document for ' + error.toString());
    });
  }

  // update transaction
  updateTransaction(String id, List<Transaction> transactions) async {
    Database db = Database(client);
    db
        .updateDocument(
            collectionId: transactionCollectionId,
            documentId: id,
            data: {
              'transactions': transactions.map((t) => t.toJson()).toList()
            })
        .then((response) {})
        .catchError((error) {
          print('Error updating document for ' + error.toString());
        });
  }
}

