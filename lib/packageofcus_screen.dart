import 'package:capstones/session_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:capstones/user_screen/package.dart';

class PackageOfCustomScreen extends StatelessWidget {
  String _getIdFromToken(String token) {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    String? id = decodedToken['id'];
    return id ?? '';
  }

  Future<List<Package>> fetchAllDataFromAPI() async {
    try {
      final FlutterSecureStorage storage = const FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      if (token != null) {
        String cid = _getIdFromToken(token);
        List<Package> allPackages = [];
        await _fetchPackagesRecursive(token, cid, allPackages, 1); // Bắt đầu từ trang đầu tiên
        return allPackages;
      } else {
        throw Exception('Token is null');
      }
    } catch (e) {
      throw Exception('Error fetching data from API: $e');
    }
  }

  Future<void> _fetchPackagesRecursive(String token, String cid, List<Package> allPackages, int pageIndex) async {
    Uri uri = Uri.parse(
        'http://localhost:5066/api/Customer/packages/$cid?pageIndex=$pageIndex&pageSize=10');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];

      if (data.isNotEmpty) {
        data.forEach((packageData) {
          Package package = Package.fromJson(packageData);
          allPackages.add(package);
        });
        // Gọi đệ quy để lấy trang tiếp theo
        await _fetchPackagesRecursive(token, cid, allPackages, pageIndex + 1); 
      }
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void _viewPackageDetails(BuildContext context, Package package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Danh sách bài tập',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Package>>(
        future: fetchAllDataFromAPI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          } else {
            List<Package>? packages = snapshot.data;
            if (packages != null && packages.isNotEmpty) {
              return ListView.builder(
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.yellow,
                    elevation: 5,
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        packages[index].packageName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Days: ${packages[index].numberOfDays}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Sessions: ${packages[index].numberOfSessions}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      trailing: packages[index].numberOfSessions > 0
                          ? ElevatedButton(
                              onPressed: () => _viewPackageDetails(context, packages[index]),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                textStyle: TextStyle(color: Colors.white),
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Xem'),
                            )
                          : null,
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'Không có bài tập nào được tìm thấy.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
