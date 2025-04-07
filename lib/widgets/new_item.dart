import 'package:flutter/material.dart';
import 'package:flutter_challenge/data/categories.dart';
import 'package:flutter_challenge/models/category.dart';
import 'package:flutter_challenge/models/grocery_item.dart';

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
                    onPressed: () {
                      _formKey.currentState?.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pop(
                          context,
                          // Pass the Data of the new item to the previous screen
                          GroceryItem(
                            id: DateTime.now().toString(),
                            name: _enteredName,
                            quantity: _enteredQuantity,
                            category: _selectedCategory,
                          ),
                        );
                      }
                    },
                    child: const Text('Add Item'),
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
