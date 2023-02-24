import 'package:flutter/material.dart';
import 'package:mobigic_test/main.dart';

class GridViewScreen extends StatefulWidget {
  final List<String> listString;
  final int m;

  const GridViewScreen({Key? key, required this.listString, required this.m}) : super(key: key);

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  TextEditingController textEditingController = TextEditingController();
  late List<bool> isSearched;
  String searchOccurrence = "";

  @override
  void initState() {
    super.initState();
    isSearched = List.generate(widget.listString.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: textEditingController,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      searchOccurrence = "";
                      isSearched.clear();
                      isSearched = List.generate(widget.listString.length, (index) => false);
                      getSearchedIndex(textEditingController.text);
                      setState(() {});
                    },
                    child: const Text("Search"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text("Enter M X N again"),
                  )
                ],
              ),
              Text("The Text Appeared for : $searchOccurrence"),
              Expanded(
                child: GridView.count(
                  crossAxisCount: widget.m,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(
                    widget.listString.length,
                    (index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: (isSearched[index]) ? Colors.greenAccent : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.listString[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getSearchedIndex(String text) {
    String t = text.replaceAll(' ', '');
    int count = 0;
    for (var element in t.runes) {
      for (int i = 0; i < widget.listString.length; i++) {
        if (widget.listString[i].compareTo(String.fromCharCode(element)) == 0) {
          count++;
          isSearched[i] = true;
        }
      }
    }
    searchOccurrence = count.toString();
  }
}
