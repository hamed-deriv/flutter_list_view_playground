import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<String> data = [];

  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late Tween<double> tween;

  final ScrollController scrollController = ScrollController();

  bool isOpen = true;
  int counter = 0;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    tween = Tween<double>(begin: 0.05, end: 1);

    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    scaleAnimation = tween.animate(scaleAnimation);

    controller
      ..addListener(() => setState(() {}))
      ..reverse();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Banner Playground')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: Container(color: Colors.red)),
              Padding(
                padding: const EdgeInsets.all(64),
                child: TextButton(
                  child: const Text('ADD ITEM'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) => Colors.black,
                    ),
                  ),
                  onPressed: () {
                    data.add('item ${counter++}');
                    setState(() {});
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 500,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 86),
                    child: ListView.builder(
                      itemCount: data.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Align(
                        heightFactor: scaleAnimation.value,
                        child: Dismissible(
                          key: UniqueKey(),
                          child: Card(
                            child: Material(
                              elevation: 10,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(data[index]),
                                ),
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            data.removeAt(index);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: const Text('EXPAND'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) => Colors.black,
                    ),
                  ),
                  onPressed: () {
                    isOpen = !isOpen;

                    isOpen ? controller.reverse() : controller.forward();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
