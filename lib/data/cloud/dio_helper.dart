import 'dart:convert';

import 'package:contacts_app/data/cloud/constants.dart';
import 'package:contacts_app/models/contact_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: ApiConstants.baseUrl,
        headers: {
          ApiConstants.contentTypeKey: ApiConstants.contentTypeValue,
        }));
  }

  static Future<List<ContactModel>> getContacts({required String url}) async {
    var response = await dio!.get(url);
    if (response.statusCode == 200) {
      List<ContactModel> contactList = response.data
          .map<ContactModel>((contactJson) =>
              ContactModel.fromJson(contactJson as Map<String, dynamic>))
          .toList();
      return contactList;
    }
    throw Exception(response.statusMessage);
  }

  static Future<ContactModel> getContactById(
      {required String url, required String id}) async {
    var response = await dio!.get('$url$id');
    if (response.statusCode == 200) {
      ContactModel contact =
          ContactModel.fromJson(response.data as Map<String, dynamic>);
      return contact;
    }
    throw Exception(response.statusMessage);
  }

  static Future<ContactModel> addContact(
      {required String url, required dynamic data}) async {
    var response = await dio!.post(url, data: data);
    debugPrint(response.statusMessage);
    if (response.statusCode == 201) {
      ContactModel contact =
          ContactModel.fromJson(response.data as Map<String, dynamic>);
      return contact;
    }
    throw Exception(response.statusMessage);
  }

  static Future<ContactModel> updateContacts(
      {required String url, required String id, required dynamic data}) async {
    var response = await dio!.put('$url$id', data: data);
    if (response.statusCode == 200) {
      ContactModel contact = ContactModel.fromJson(
          response.data as Map<String, dynamic>);
      return contact;
    }
    throw Exception(response.statusMessage);
  }

  static Future<String> deleteContact({
    required String url,
    required String id,
  }) async {
    var response = await dio!.delete('$url$id');
    if (response.statusCode == 200) {
      return 'Contact has been deleted.';
    }
    throw Exception('Server Error ... Contact not deleted!');
  }
}
