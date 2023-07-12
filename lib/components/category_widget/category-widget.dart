import 'package:flutter/material.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // setState(() {
        //   FFAppState().sizecon1 = true;
        //   FFAppState().homecat = '2030';
        //   FFAppState().selectedsize = '';
        //   FFAppState().subcat = '';
        //   FFAppState().search = '';
        //   FFAppState().selectedcats = [];
        //   FFAppState().selectedcatsids = [];
        // });
        // await Navigator.push(
        //   context,
        //   PageTransition(
        //       type: PageTransitionType.fade,
        //       duration: Duration(milliseconds: 1000),
        //       reverseDuration: Duration(milliseconds: 500),
        //       child: ShowCaseWidget(
        //         builder: Builder(
        //           builder: (context) => NavBarPage(initialPage: 'Home'),
        //         ),
        //       )),
        // );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.asset(
                  'assets/images/WLanding.jpg',
                ).image,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0x80000000),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_alarm,
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ملابس نسائيه",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
