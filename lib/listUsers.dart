import 'package:flutter/material.dart';

class ListViewBuilder extends StatelessWidget {
  final List<String> listUsers;

  ListViewBuilder(this.listUsers);

  @override
  Widget build(BuildContext context) {
    var numItems = listUsers.length;
    const _biggerFont = TextStyle(fontSize: 16.0);

    Widget _buildRow(int idx) {
      int ordem = idx + 1;
      return ListTile(
        leading: CircleAvatar(
          child: Text('$ordem'),
        ),
        title: Text(
          listUsers[idx] != null ? listUsers[idx] : "indisponível",
          style: _biggerFont,
        ),
      );
    }

    return ListView.builder(
      itemCount: numItems,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int i) {
        final index = i;
        return _buildRow(index);
      },
    );
  }
}
