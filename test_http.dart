import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final email = '30409260104446@sci.asu.edu.eg';
  final url = Uri.parse('http://localhost:3000/api/users/' + Uri.encodeComponent(email) + '/enrollments');
  print('Requesting: ' + url.toString());
  
  try {
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    print('Status: ' + response.statusCode.toString());
    print('Body length: ' + response.body.length.toString());
  } catch (e) {
    print('Error: ' + e.toString());
  }
}
