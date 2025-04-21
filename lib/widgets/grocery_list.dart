import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/categories.dart';
import 'package:flutter_challenge/models/category.dart';
import 'package:flutter_challenge/models/grocery_item.dart';
import 'package:flutter_challenge/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // this list will be used to store the grocery items
  List<GroceryItem> _groceryItems = [];

  bool _isLoading = true;

  String? _error;

  @override
  Widget build(BuildContext context) {
    // i made this variable to display a message when the list is empty and to display the list when it is not empty
    Widget content = const Center(
      child: Text(
        'No items added yet!',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryItems[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);
            },
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          );
        },
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: content,
    );
  }

  void _removeItem(GroceryItem item) {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final uri = Uri.parse(
      'https://flutter-test-dcb77-default-rtdb.firebaseio.com/shopping-list/${item.id}.json',
    );
    http.delete(uri).then((response) {
      if (response.statusCode >= 400) {
        setState(() {
          _groceryItems.insert(index, item);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete item. Please try again later.'),
            ),
          );
        });
      }
    });
  }

  void _loadData() async {
    final uri = Uri.parse(
      'https://flutter-test-dcb77-default-rtdb.firebaseio.com/shopping-list.json',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 400) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to fetch data. Please try again later';
        });
        return;
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> loadedData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (var item in loadedData.entries) {
        final Category category =
            categories.entries
                .firstWhere(
                  (element) => element.value.name == item.value['category'],
                )
                .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
        setState(() {
          _groceryItems = loadedItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Something went wrong. Please try again later';
      });
    }
  }

  _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) => const NewItem()),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }
}
