import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class AppWrite {
  Client client = Client();
  AppWrite() {
    client
        .setEndpoint('http://localhost:1111/v1') // Your Appwrite Endpoint
        .setProject('615d24b79c735') // Your project ID
        .setSelfSigned();
    // Register User
  }

  signup(String email, String password) async {
    Account account = Account(client);
    User user =
        await account.create(email: email, password: password, name: email);
    return user;
  }

  login(String email, String password) async {
    Account account = Account(client);
    Session session =
        await account.createSession(email: email, password: password);
    return session;
  }

  createDocumentForNewUser(String email) async {
    Database database = Database(client);

    database.createDocument(collectionId: '617ddfb859893', data: {
      'balance': 0,
      'userId': email,
    }, write: [
      '*'
    ]).then((response) {
      print(response);
    }).catchError((error) {
      print('Error creating document in balances');
      print(error);
    });

    database.createDocument(collectionId: '617ddfa27af1b', data: {
      'transactions': [],
      'userId': email,
    }, write: [
      '*'
    ]).then((response) {
      print(response);
    }).catchError((error) {
      print('Error creating document in transactions');
      print(error);
    });
  }

  updateTransactions(String email, List<String> transactions) async {
    Database database = Database(client);
    database.updateDocument(
        collectionId: '617ddfa27af1b',
        documentId: email,
        data: {
          'transactions': transactions,
        },
        write: [
          '*'
        ]).then((response) {
      print(response);
    }).catchError((error) {
      print('Error updating document in transactions');
      print(error);
    });
  }

  updateBalance(String email, int balance) async {
    Database database = Database(client);
    database.updateDocument(
        collectionId: '617ddfb859893',
        documentId: email,
        data: {
          'balance': balance,
        },
        write: [
          '*'
        ]).then((response) {
      print(response);
    }).catchError((error) {
      print('Error updating document in balances');
      print(error);
    });
  }

  getTransactions(String email) async {
    Database database = Database(client);
    Document document = await database.getDocument(
        collectionId: '617ddfa27af1b', documentId: email);
    return document.data['transactions'];
  }

  getBalance(String email) async {
    Database database = Database(client);
    Document document = await database.getDocument(
        collectionId: '617ddfb859893', documentId: email);
    return document.data['balance'];
  }
}
