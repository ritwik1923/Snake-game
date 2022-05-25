import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridMake extends StatefulWidget {
  const GridMake({Key? key}) : super(key: key);

  @override
  State<GridMake> createState() => _GridMakeState();
}

int per_col = 20;
int lines = 15;

class _GridMakeState extends State<GridMake> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.amberAccent,
              width: 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("hi"),
                  Text("rwk"),
                ],
              ),
            ),
            Container(
              height: 25 * 15,
              width: 500,
              color: Colors.pink,
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: per_col),
                  itemCount: lines * per_col,
                  itemBuilder: (BuildContext ctx, index) {
                    // debugPrint("fa: $fa");
                    return Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
