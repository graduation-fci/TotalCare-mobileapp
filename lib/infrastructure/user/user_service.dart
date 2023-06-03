import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../my_config.dart';
import '../shared/storage.dart';
import '/models/medication.dart';

class UserService {
  Storage storage = Storage();
  String? errorMsg;

  Future<Map<String, dynamic>> getUserData() async {
    final url = Uri.parse(Config.patientProfile);
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final response = await http.get(headers: {
      'Authorization': 'JWT $token',
    }, url);
    final responseBody = json.decode(response.body);
    return responseBody;
  }

  Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    final uploadImageUrl = Uri.parse(Config.userImage);
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    final request = http.MultipartRequest('POST', uploadImageUrl);
    request.headers['Authorization'] = 'JWT $token';
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse('image/*'),
      ),
    );

    final uploadResponse = await request.send();
    final uploadResponseBody = await uploadResponse.stream.bytesToString();
    final parsedResponse = jsonDecode(uploadResponseBody);
    return parsedResponse;
  }

  Future<Map<String, dynamic>> addUserImage(int id) async {
    final profileUrl = Uri.parse(Config.patientProfile);

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.patch(
      profileUrl,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
      body: json.encode(
        {'image_file': id},
      ),
    );
    final responseBody = json.decode(response.body);

    return responseBody;
  }

  Future<void> deleteUserImage(int id) async {
    final url = Uri.parse('${Config.userImage}$id/');
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });
    await http.delete(
      headers: {'Authorization': 'JWT $token'},
      url,
    );
  }

  Future<Map<String, dynamic>> addMedicationProfile(Medication med) async {
    final url = Uri.parse(Config.userMedications);
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
      body: json.encode(
        {
          "title": med.title,
          "medicines": med.medicineIds,
        },
      ),
    );

    final responseData = json.decode(response.body);
    // log('$responseData');
    return responseData;
  }

  Future<Map<String, dynamic>> editMedicationProfile(
      Medication med, int id) async {
    final url = Uri.parse('${Config.userMedications}$id/');
    Map<String, dynamic>? body;
    if (med.title.isNotEmpty && med.medicineIds.isNotEmpty) {
      body = {"title": med.title, "medicines": med.medicineIds};
    } else if (med.title.isEmpty && med.medicineIds.isNotEmpty) {
      body = {"medicines": med.medicineIds};
    } else if (med.medicineIds.isEmpty && med.title.isNotEmpty) {
      body = {"title": med.title};
    }

    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.patch(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
      body: json.encode(body),
    );

    final responseData = json.decode(response.body);
    // log('$responseData');
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }

  Future<Map<String, dynamic>> getMedications() async {
    final url = Uri.parse(Config.userMedications);
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );

    final responseData = json.decode(response.body);
    // log('$responseData');
    if (responseData['details'] == null) {
      return responseData;
    }
    return responseData;
  }

  Future<void> deleteMedication(int id) async {
    final url = Uri.parse('${Config.userMedications}$id/');
    String? token;
    await storage.getToken().then((value) {
      token = value;
    });

    final response = await http.delete(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "JWT $token",
      },
    );
  }
}
