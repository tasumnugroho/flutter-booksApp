import 'dart:convert';
import 'package:book_apps_nugro/models/book_list_response.dart';
import 'package:book_apps_nugro/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookListResponse? bookList;
  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    print("test1 fetch");
    try {
      var response = await http.get(url);
      print("test2 fetch");
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonBookList = jsonDecode(response.body);
        bookList = BookListResponse.fromJson(jsonBookList);
        setState(() {});
      }
      print("$fetchBookApi");
    } catch (e, s) {
      print(e);
      print(s);
    } finally {
      print('selesai');
    }
    // var response = await http.get(url);

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBookApi();
  }

  @override
  Widget build(BuildContext context) {
    print("test1 build");
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Catalogue"),
      ),
      body: Container(
        child: bookList == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bookList!.books!.length,
                itemBuilder: (context, index) {
                  final currentBook = bookList!.books![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailBookPage(
                            isbn: currentBook.isbn13!,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.network(
                          currentBook.image!,
                          height: 100,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(currentBook.title!),
                                Text(currentBook.subtitle!),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(currentBook.price!),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
    print("test2 build");
  }
  // print("book value $bookList");
}
