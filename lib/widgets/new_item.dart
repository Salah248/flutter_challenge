import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/categories.dart';
import 'package:flutter_challenge/models/category.dart';
import 'package:flutter_challenge/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 0;
  var _selectedCategory = categories[Categories.fruit]!;
  // this variable will be used to show a loading indicator when the user is adding a new item
  bool _isLoading = false;

  void _saveItem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final uri = Uri.parse(
        'https://flutter-test-dcb77-default-rtdb.firebaseio.com/shopping-list.json',
      );
      http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': _enteredName,
              'quantity': _enteredQuantity,
              'category': _selectedCategory.name,
            }),
          )
          .then((response) {
            if (response.statusCode == 200 && context.mounted) {
              Navigator.of(context).pop(
                GroceryItem(
                  id: json.decode(response.body)['name'],
                  name: _enteredName,
                  quantity: _enteredQuantity,
                  category: _selectedCategory,
                ),
              );
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 20,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                onSaved: (newValue) {
                  // Save the name of the item
                  _enteredName = newValue!;
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 20) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) {
                        // Save the quantity of the item
                        _enteredQuantity = int.parse(newValue!);
                      },
                      initialValue: '1',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Please enter a valid Quantity, greater than 0';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              _formKey.currentState?.reset();
                            },
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _isLoading ? null : _saveItem(context),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text('Add Item'),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
