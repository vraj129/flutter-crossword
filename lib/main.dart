import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobigic_test/grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController rowController = TextEditingController();
  TextEditingController columnController = TextEditingController();
  int m = -1;
  int n = -1;
  int i = 0;
  int j = 0;

  TextEditingController valueController = TextEditingController();
  bool stopInsert = false;
  List<String> listString = [];
  List<List<String>> grid = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobigic Test"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
            right: 24,
          ),
          child: (m == -1 && n == -1)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Enter The M x N of 2D grid : ',
                    ),
                    TextField(
                      controller: rowController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextField(
                      controller: columnController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (rowController.text.isNotEmpty && columnController.text.isNotEmpty) {
                          m = int.tryParse(rowController.text)!;
                          n = int.tryParse(columnController.text)!;
                          if ((m > 0 || m <= 5)) {
                            if (n != m) {
                              m = -1;
                              n = -1;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "The matrix has to be square matrix",
                                  ),
                                ),
                              );
                            } else {
                              grid = List.generate(m, (index) => List.filled(m, "2"));
                              for (int i = 0; i < m; i++) {
                                for (int j = 0; j < n; j++) {
                                  print(grid[i][j]);
                                }
                              }
                              setState(() {});
                            }
                          } else {
                            m = -1;
                            n = -1;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "M value should be between 1 and 5 and N value should be between 1 and 10",
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (!stopInsert)
                          ? Text(
                              "Please enter for position ${getPosition()}",
                            )
                          : const Text("You inserted all values thx"),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: valueController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]+")),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!stopInsert) {
                            if (valueController.text.isNotEmpty) {
                              if (i < m) {
                                grid[i][j] = valueController.text;
                                j++;
                                if (j == n) {
                                  j = 0;
                                  i++;
                                  if (i == m) {
                                    stopInsert = true;
                                  }
                                }
                                listString.add(valueController.text);
                                valueController.text = "";
                                setState(() {});
                              }
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GridViewScreen(
                                  listString: listString,
                                  m: m,
                                  grid: grid,
                                  n: n,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          (!stopInsert) ? "Insert" : "Next",
                        ),
                      ),
                      const Text(
                        "Insert the value you want to put it in the grid",
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String getPosition() {
    return "$i $j";
  }
}
