import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {

  final String text;
  final IconData iconData;
  const EmptyCard({this.text, this.iconData});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Center(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                iconData,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 16.0,),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white
                ),
              ),
            ],
          )
      )
    );
  }
}
