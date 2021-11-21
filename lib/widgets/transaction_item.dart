import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        // leading: Container(
        //   height: 60,
        //   width: 60,
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).primaryColor,
        //     shape: BoxShape.circle,
        //   ),
        leading: CircleAvatar(
          radius: 35,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${transaction.amount.toStringAsFixed(1)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                )
              ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle:  Text(
          DateFormat.yMMMd().format(
            transaction.date,
          )
        ),
        trailing: MediaQuery.of(context).size.width > 460
          ? FlatButton.icon(
              textColor: Theme.of(context).errorColor,
              onPressed: () => deleteTx(transaction.id), 
              icon: const Icon(Icons.delete), 
              label: const Text('Delete'))

          : IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () => deleteTx(transaction.id),
            ),
      ),
    );
  }
}