import 'dart:convert';

import 'package:contacts_app/models/contact_model.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://a0ee2656-2c7b-4a74-a8bd-0b8c85411745.mock.pstmn.io/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'json'
        }));
  }

  static Future<List<ContactModel>> getContacts({required String url}) async {
    var contacts = await dio!.get(url);
    print('contacts=${contacts.data}');
    List<ContactModel> contactList = (json.decode(contacts.data) as List).map((i) =>
        ContactModel.fromJson(i)).toList();
    return contactList;
  }

  static Future<Response> postData(String url, {dynamic data}) async {
    return await dio!.post(url, data: data);
  }

  static Future<Response> putData(String url, {dynamic data}) async {
    return await dio!.put(url, data: data);
  }
}