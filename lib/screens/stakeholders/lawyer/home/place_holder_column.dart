import 'package:flutter/material.dart';

import 'place_holder_card.dart';

class PlaceholderCardsColumn extends StatelessWidget {
  const PlaceholderCardsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlaceholderCard(
            title: 'Card 1',
            description: 'Description 1',
          ),
          PlaceholderCard(
            title: 'Card 2',
            description: 'Description 2',
          ),
          PlaceholderCard(
            title: 'Card 3',
            description: 'Description 3',
          ),
        ],
      ),
    );
  }
}
