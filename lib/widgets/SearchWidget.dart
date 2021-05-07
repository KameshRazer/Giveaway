import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  TextEditingController SearchText = new TextEditingController();
  // SearchWidget(this.SearchText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      child: TextField(
        controller: SearchText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              width: 0,
              color: Color(0xFFfb3132),
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          suffixIcon: GestureDetector(
            onTap: () {
              print(SearchText.text);
            },
            child: Icon(
              Icons.search,
              color: Color(0xFFfb3132),
            ),
          ),
          fillColor: Color(0xFFFAFAFA),
          prefixIcon: Icon(
            Icons.sort,
            color: Color(0xFFfb3132),
          ),
          hintStyle: new TextStyle(color: Color(0xFFd0cece), fontSize: 18),
          hintText: "What would your like to get?",
        ),
      ),
    );
  }
}
