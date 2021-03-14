import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.account_circle,
                color: primaryColor,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Faça login para acessar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                    color: primaryColor
                  ),
                ),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.of(context).pushNamed('/login');
                },
                color: primaryColor,
                textColor: Colors.white,
                child: const Text(
                  'LOGIN'
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
