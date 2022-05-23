import 'dart:io' show InternetAddress;
import 'dart:convert' as convert ;
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart' show Request, Response;
import 'package:shelf/shelf_io.dart'  show serve;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'dart:async';
import 'package:http/http.dart' as HttpHeaders;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode,jsonEncode ;
import 'dart:io' as io;
import 'package:image/image.dart';
import 'package:http_status_code/http_status_code.dart';

void main() async {

//Initialize Router
Router router = Router();

final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'p455w0rd',
      db: 'bookshop'));


/*******GET BOOKS************/
router.get('/api/v1/books', (Request request) async {

      try {  
  var results = await conn.query('select * from bookshop AS bookshop');
  var row;
  var books = <Map>[]; // creates an empty List<Map>
  for (row in results) {
    books.add({
      "ISBN": row[0],
      "name": row[1],
      "author": row[2],
      "publication_date": row[3],
      "description": row[4],
      "coverpage": row[5],
      "trade_price":row[6],
      "retail_price": row[7],
      "quantity": row[8]
    });
    }

  Map<String, dynamic> x = new Map();
  x = {
    "status": "Success",
    "books" : books,
    "message": "Successfully! All records has been fetched."
  };
	String json = jsonEncode(x);
  print(json);

  return Response.ok(
    json, 
    headers:  {'Content-Type': 'application/json'},
    encoding: convert.Encoding.getByName('utf-8')
  );
      }
  catch(e) { 

      Map<String, dynamic> x2 = new Map();                                                              
      x2 = {
      "status": "Failed",
      "Error": e.toString(),
      "message": "Failed to add book to bookshop! "
      };
      
      String json2 = jsonEncode(x2);
      print(e); 
      return Response.ok(
      json2,
      headers:  {'Content-Type': 'application/json'},
      encoding: convert.Encoding.getByName('utf-8')
      ); 
   } 
});
 
/****************POST BOOKS***********************/
	router.post('/api/v1/books', (Request request) async{
	print (request.url.queryParameters);

  	final ISBN = request.url.queryParameters["ISBN"];
	  final name = request.url.queryParameters["name"] ?? '-';
    final author = request.url.queryParameters["author"] ?? '-';
    final publicationdate = request.url.queryParameters["publication_date"] ?? '-';
    final description = request.url.queryParameters["description"] ?? '-';
    final coverpage = request.url.queryParameters["coverpage"] ?? '-';
    final tradeprice = request.url.queryParameters["trade_price"] ?? '-';
    final retailprice = request.url.queryParameters["retail_price"] ?? '-';
    final quantity = request.url.queryParameters["quantity"] ?? '-';

    try {  
    var result = await conn.query(
    'insert into bookshop (ISBN,name, author, publicationdate, description, coverpage,tradeprice, retailprice, quantity) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [ISBN, name, author, publicationdate, description, coverpage, tradeprice, retailprice, quantity]);
    print('Inserted row IBSN=${result.insertId}');

    Map<String, dynamic> x = new Map();                                                              
    x = {
      "status": "Success",
      "books" : 
      {
        "ISBN": ISBN,
        "name": name,
        "author": author,
        "publication_date": publicationdate,
        "description": description,
        "coverpage": coverpage,
        "trade_price": tradeprice,
        "retail_price": retailprice,
        "quantity": quantity
      },
      "message": "New Book Added Successfully! "
    };
      String json = jsonEncode(x);
      print(json);

      return Response.ok(
      json,
      headers:  {'Content-Type': 'application/json'},
      encoding: convert.Encoding.getByName('utf-8')
      );
   }  
   catch(e) { 

      Map<String, dynamic> x2 = new Map();                                                              
      x2 = {
      "status": "Failed",
      "Error": e.toString(),
      "message": "Failed to add book to bookshop! "
      };
      
      String json2 = jsonEncode(x2);
      print(e); 
      return Response.ok(
      json2,
      headers:  {'Content-Type': 'application/json'},
      encoding: convert.Encoding.getByName('utf-8')
      ); 
   } 
});


/*********************GET ISBN***************************/
router.get('/api/v1/books/<ISBN>', (Request request, String ISBN) async {
  try{
  var row;
  var results2 = await conn.query('select * from bookshop where ISBN = ? ORDER BY ISBN', ['$ISBN'] );
  print(results2);
  Map<String, dynamic> x = new Map();                                                              

  for(row in results2) {
    print(row);
    x = {
      "status": "Success",
      "books" : 
      {
        "ISBN": row[0],
        "name": row[1],
        "author": row[2],
        "publication_date": row[3],
        "description": row[4],
        "coverpage": row[5],
        "trade_price":row[6],
        "retail_price": row[7],
        "quantity": row[8]
      },
      "message": "Records fetched Successfully!"
    };
  }

	String json = jsonEncode(x);
  print(json);

  return Response.ok(
      json, 
      headers:  {
        'Content-Type': 'application/json'
      }, encoding: convert.Encoding.getByName('utf-8'));
  }
      catch(e) { 

      Map<String, dynamic> x2 = new Map();                                                              
      x2 = {
      "status": "Failed",
      "Error": e.toString(),
      "message": "Failed to add book to bookshop! "
      };
      
      String json2 = jsonEncode(x2);
      print(e); 
      return Response.ok(
      json2,
      headers:  {'Content-Type': 'application/json'},
      encoding: convert.Encoding.getByName('utf-8')
      ); 
   } 
});



/***********************PUT ISBN************************/
router.put('/api/v1/books/<ISBN>', (Request request, String ISBN) async {
  try{
  print(request.url.queryParameters);
  final name = request.url.queryParameters["name"] ?? '';
  final author = request.url.queryParameters["author"] ?? '';
  final publicationdate = request.url.queryParameters["publicationdate"] ?? '';
  final description = request.url.queryParameters["description"] ?? '';
  final coverpage = request.url.queryParameters["coverpage"] ?? '';
  final tradeprice = request.url.queryParameters["tradeprice"] ?? '';
  final retailprice = request.url.queryParameters["retailprice"] ?? '';
  final quantity = request.url.queryParameters["quantity"] ?? '';

  if (!name.isEmpty){
    var r = await conn.query('UPDATE bookshop SET name=? WHERE ISBN = ?', [name,'$ISBN']);
  }if (author != ""){
    var r = await conn.query('UPDATE bookshop SET author=? WHERE ISBN = ?', [author,'$ISBN']);
  }if (publicationdate != ""){
    var r = await conn.query('UPDATE bookshop SET publicationdate=? WHERE ISBN = ?', [publicationdate,'$ISBN']);
  }if (description != ""){
    var r = await conn.query('UPDATE bookshop SET description=? WHERE ISBN = ?', [description,'$ISBN']);
  }if (coverpage != ""){
    var r = await conn.query('UPDATE bookshop SET coverpage=? WHERE ISBN = ?', [coverpage,'$ISBN']);
  }if (tradeprice != ""){
    var r = await conn.query('UPDATE bookshop SET tradeprice=? WHERE ISBN = ?', [tradeprice,'$ISBN']);
  }if (retailprice != ""){
    var r = await conn.query('UPDATE bookshop SET retailprice=? WHERE ISBN = ?', [retailprice,'$ISBN']);
  }if (quantity != ""){
    var r = await conn.query('UPDATE bookshop SET quantity=? WHERE ISBN = ?', [quantity,'$ISBN']);
  }

  var results2 = await conn.query('select * from bookshop where ISBN = ?', ['$ISBN']);
  print(results2);
  
  var row;
  Map<String, dynamic> x = new Map();                                                              
  
  for(row in results2) {
    print(row);
    x = {
      "status": "Success",
      "books" : 
      {
        "ISBN": row[0],
        "name": row[1],
        "author": row[2],
        "publication_date": row[3],
        "description": row[4],
        "coverpage": row[5],
        "trade_price":row[6],
        "retail_price": row[7],
        "quantity": row[8]
      },
      "message": "Records fetched Successfully!"
    };
  }
  return Response.ok(
    jsonEncode(x),
    headers: {
      'Content-Type': 'application/json'
      },
    encoding: convert.Encoding.getByName('utf-8')
    );
  }
    catch(e) { 

      Map<String, dynamic> x2 = new Map();                                                              
      x2 = {
      "status": "Failed",
      "Error": e.toString(),
      "message": "Failed to add book to bookshop! "
      };
      
      String json2 = jsonEncode(x2);
      print(e); 
      return Response.ok(
      json2,
      headers:  {'Content-Type': 'application/json'},
      encoding: convert.Encoding.getByName('utf-8')
      ); 
   } 
});

/*************CALL SERVER**************/
  final server = await serve(
    router,
    InternetAddress.anyIPv4,
    8080,
  );
  print('Serving at http://${server.address.host}:${server.port}');
}