import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController controller;
  bool isLoading = false;
  late List<String> autoCompleteData;

  Future autoComplete() async {
    setState(() {
      isLoading = true;
    });

    final String stringData = await rootBundle.loadString('assets/data.json');
    // convert List<String> into Map<String, dynamic>
    final List<dynamic> json = jsonDecode(stringData);

    // convert List<dynamic> into String
    final List<String> jsonStringData = json.cast<String>();
    setState(() {
      isLoading = false;
      autoCompleteData = jsonStringData;
    });
  }

  @override
  void initState() {
    autoComplete();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: const Text('Auto Colplete'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    } else {
                      return autoCompleteData.where(
                        (name) => name.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            ),
                      );
                    }
                  },
                  onSelected: (slectedData) {
                    print(slectedData);
                  },
                  optionsViewBuilder:
                      (context, Function(String) onSelected, options) {
                    return Material(
                      elevation: 3,
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option.toString(),
                              ),
                              subtitle: SubstringHighlight(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent),
                                text: option.toString(),
                                term: controller.text,
                              ),
                              onTap: () {
                                onSelected(option.toString());
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: options.length),
                    );
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    this.controller = controller;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xff112435),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Color(0xff112470),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xff112435),
                            )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff112435),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
