//   var row;
//   // Insert some data
//   // var result = await conn.query(
//   // 'insert into bookshop (name, author, publicationdate, description, coverpage, tradeprice, retailprice, quantity) values (?, ?, ?, ?, ?, ?, ?, ?)',
//   // ['Bob', 'bob@bob.com', 'adcc','Bob', 'bob@bob.com', 'adcc','Bob', 'bob@bob.com']);
//   // print('Inserted row id=${result.insertId}');

// var getid = await conn.query(
//   // 'select * from bookshop where ISBN = ?', ['1']);
//   'select * from bookshop AS bookshop');
//   //  "SELECT JSON_OBJECT('ibsn', ibsn, 'name', name,'author', author) FROM bookshop");
//   print(" ");
//   print(" ");
//   print(" ");
//   print(results);
//   print(" ");
//   print(" ");
//   print(" ");
//   print(" ");


// var books = <Map>[]; // creates an empty List<Map>
// for (row in results) {
//   print(row[0]);
//   books.add({
//     "ISBN": row[0],
//     "name": row[1],
//     "author": row[2],
//     "publication-date": row[3],
//     "description": row[4],
//     "picture": row[5],
//     "Trade-price":row[6],
//     "retail-price": row[7],
//     "quantity": row[8]
//    });
//   }

//   Map<String, dynamic> x = new Map();
//   x = {
//     "status": "success",
//     "books" : books,
//     "message": "Successfully! All records has been fetched."
//   };
// 	String json = jsonEncode(x);
//   print(json);
/* json.dart */


/* json.dart */

/* image.dart */

// import 'dart:io' as io;
// import 'dart:convert' as convert;
// import 'package:image/image.dart';

// main() {

// 	////////////////////ENCODE IMAGE////////////////////
// 	final bytes = io.File('mus.jpeg',height: 10,    width: 10, ).readAsBytesSync();
// 	String img64 = convert.base64Encode(bytes);
// 	// String img64r = img64.substring(0, 100);
// 	// print(img64.substring(0, 100));
// 	print(img64); 

// 	///////////////// Decoding base64 data into an image file
// 	// final decodedBytes = convert.base64Decode(img64);
// 	// var file = io.File("decodedbird4.jpg");
// 	// file.writeAsBytesSync(decodedBytes);
// }




/* post.dart */

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
  
main() async {

	String domain = 'voyagebucket-matchhobby-8080.codio-box.uk';
  String path = '/api/v2/books';
  Uri uri = Uri.https(domain, path);

	Map<String, String> headers = {
		'Accept': 'application/json',
		'Content-type': 'application/json'
	};

	Map<String, dynamic> body = {
		'ISBN': 'Item One',
	};
	
	http.Response response = await http.post(
		uri,
		headers: headers,
		body: convert.jsonEncode(body),
		encoding: convert.Encoding.getByName('utf-8')
	);
 
	print('Response status: ${response.statusCode}');
	print('Response body: ${response.body}');

}
