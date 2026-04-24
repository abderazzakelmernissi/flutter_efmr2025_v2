import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// Classe Account
class Account {
  String _login;
  String _password;

  // Constructeur
  Account(this._login, this._password);

  // Getters
  String get login => _login;
  String get password => _password;

  // Setters
  set login(String login) => _login = login;
  set password(String password) => _password = password;

  // Méthode toString
  String toString() {
    return '$_login | $_password';
  }

  // Méthode isWeakPassword
  bool isWeakPassword() {
    return _password.length <= 3;
  }
}

// Fonction pour parser les comptes depuis JSON
List<Account> accounts(String jsonString) {
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList
      .map((json) => Account(json['login'], json['password']))
      .toList();
}

// Écran principal des comptes
class AccountsScreen extends StatefulWidget {
  final List<Account> accounts;

  const AccountsScreen({Key? key, required this.accounts}) : super(key: key);

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Accounts'),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body:
          widget.accounts.isEmpty
              ? Center(child: Text('No accounts available'))
              : Container(
                color: Colors.grey[300],
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Conteneur principal pour l'affichage du compte
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Affichage du login
                            Text(
                              widget.accounts[currentIndex].login,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),

                            // Affichage du mot de passe masqué
                            Text(
                              widget.accounts[currentIndex].password,
                              style: TextStyle(fontSize: 16, letterSpacing: 2),
                            ),
                            SizedBox(height: 30),

                            // Image indiquant la force du mot de passe
                            Image.asset(
                              widget.accounts[currentIndex].isWeakPassword()
                                  ? 'assets/Weak.png'
                                  : 'assets/Strong.png',
                              width: 60,
                              height: 60,
                            ),
                            SizedBox(height: 20),

                            // Indicateur de position (1/3)
                            Text(
                              '${currentIndex + 1}/${widget.accounts.length}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Boutons de navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Bouton précédent
                        ElevatedButton(
                          onPressed:
                              currentIndex > 0
                                  ? () {
                                    setState(() {
                                      currentIndex--;
                                    });
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text('<'),
                        ),

                        // Bouton suivant
                        ElevatedButton(
                          onPressed:
                              currentIndex < widget.accounts.length - 1
                                  ? () {
                                    setState(() {
                                      currentIndex++;
                                    });
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text('>'),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Boutons d'action
                    Column(
                      children: [
                        // Bouton All Accounts
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AllAccountsScreen(
                                        accounts: widget.accounts,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text('All Accounts'),
                          ),
                        ),

                        SizedBox(height: 10),

                        // Bouton Statistics
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _showStatistics,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text('Statistics'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  void _showStatistics() {
    int totalAccounts = widget.accounts.length;
    int weakPasswords =
        widget.accounts.where((account) => account.isWeakPassword()).length;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Statistics'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You have'),
                SizedBox(height: 8),
                Text('• $totalAccounts account(s)'),
                Text('• $weakPasswords account(s) with weak password(s)'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }
}

// Écran affichant tous les comptes
class AllAccountsScreen extends StatelessWidget {
  final List<Account> accounts;

  const AllAccountsScreen({Key? key, required this.accounts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Accounts'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[300],
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[700],
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  accounts[index].login,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  accounts[index].password,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                trailing: Icon(
                  accounts[index].isWeakPassword()
                      ? Icons.security
                      : Icons.verified_user,
                  color:
                      accounts[index].isWeakPassword()
                          ? Colors.red
                          : Colors.green,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget principal de l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Manager',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: FutureBuilder<String>(
        future: rootBundle.loadString('assets/accounts.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Account> accountsList = accounts(snapshot.data!);
            return AccountsScreen(accounts: accountsList);
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error loading accounts: ${snapshot.error}'),
              ),
            );
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(MyApp());
}
