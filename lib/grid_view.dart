import 'package:flutter/material.dart';
import 'package:mobigic_test/main.dart';

class GridViewScreen extends StatefulWidget {
  final List<String> listString;
  final int m;
  final int n;
  final List<List<String>> grid;

  const GridViewScreen(
      {Key? key, required this.listString, required this.m, required this.grid, required this.n})
      : super(key: key);

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  TextEditingController textEditingController = TextEditingController();
  late List<bool> isSearched;
  String searchOccurrence = "";
  List<int> x = [-1, -1, -1, 0, 0, 1, 1, 1];
  List<int> y = [-1, 0, 1, -1, 1, -1, 0, 1];

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
    if (text.trim().length == 1) {
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
    } else {
      patternSearch(widget.grid, text);
    }
  }

  void patternSearch(List<List<String>> grid, String word) {
    for (int row = 0; row < widget.m; row++) {
      for (int col = 0; col < widget.n; col++) {
        if (grid[row][col] == word[0] && search2D(grid, row, col, word)) {
          print("pattern found at $row, $col");
        }
      }
    }
    int patternFound = -1;
    for (var element in isSearched) {
      if (element) {
        patternFound = 0;
      }
    }
    if (patternFound == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Pattern could not be found",
          ),
        ),
      );
    }
  }

  bool search2D(List<List<String>> grid, int row, int col, String word) {
    if (grid[row][col].compareTo(word[0]) != 0) {
      return false;
    } else {
      mapped2Dto1DIndex(row, col);
    }
    int len = word.length;

    // Search word in all 8 directions
    // starting from (row, col)
    for (int dir = 0; dir < 8; dir++) {
      // Initialize starting point
      // for current direction
      int k, rd = row + x[dir], cd = col + y[dir];

      // First character is already checked,
      // match remaining characters
      for (k = 1; k < len; k++) {
        // If out of bound break
        if (rd >= widget.m || rd < 0 || cd >= widget.n || cd < 0) break;

        // If not matched, break
        if (grid[rd][cd].compareTo(word[k]) != 0) {
          break;
        } else {
          mapped2Dto1DIndex(rd, cd);
        }

        // Moving in particular direction
        rd += x[dir];
        cd += y[dir];
      }

      // If all character matched,
      // then value of must
      // be equal to length of word
      if (k == len) {
        return true;
      }
    }
    isSearched = List.generate(widget.listString.length, (index) => false);
    return false;
  }

  void mapped2Dto1DIndex(int rd, int cd) {
    isSearched[widget.m * rd + cd] = true;
  }
}
