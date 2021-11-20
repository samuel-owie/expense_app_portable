// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
  }

class MyApp extends StatelessWidget{
  
  @override
  Widget build(BuildContext context){

    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.green,
        errorColor: Colors.red,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            ),
          button: TextStyle(
            color: Colors.white,
          )
          ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              )
            ),
          ),
        //colorScheme.secondary: Colors.amber
      ),
      home: MyHomePage(),
      );
  }
}

class MyHomePage extends StatefulWidget{
  
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now()
    //   ),
    //   Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.99,
    //   date: DateTime.now()
    //   ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTranscations {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
      title: txTitle, 
      amount: txAmount, 
      date: chosenDate,
      id: DateTime.now().toString()
      );

      setState(() {
      _userTransactions.add(newTx);
      });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
          );
      }
      );
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id ==id);
    });
  }

  @override
  Widget build(BuildContext context){
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
        title: Text('Personal Expenses'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _startAddNewTransaction(context), 
            icon: Icon(Icons.add))

        ],
      );

      final txListWidget = Container(
                height: (MediaQuery.of(context).size.height - 
                                appBar.preferredSize.height - 
                                MediaQuery.of(context).padding.top)* .70,
                child: TransactionList(_userTransactions, _deleteTransaction)
                );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
        
            // first segment of app 
            //second way of
              if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    }, 
                    //onChanged: onChanged,
                  ),
                ],
              ),
              
              if (!isLandscape) Container(
                height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height - 
                                MediaQuery.of(context).padding.top) * 0.3,
                child: Chart(_recentTranscations)
                ),

              if (!isLandscape) txListWidget,

              if(isLandscape) _showChart ?
              Container(
                height: (MediaQuery.of(context).size.height -
                                appBar.preferredSize.height - 
                                MediaQuery.of(context).padding.top) * 0.7,
                child: Chart(_recentTranscations)
                )
              :txListWidget, 
        
        
        
            
            // one way of controlling the dimension contents can occupy in the screen.
            /*
            Card(
              color: Colors.blue,
              child: Container(
                width: double.infinity,
                child: Text('Chart!'),),
              elevation: 5,
              ),
            */
            
             // second segment of app 
            
          ],
        
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),

      );
    }
}