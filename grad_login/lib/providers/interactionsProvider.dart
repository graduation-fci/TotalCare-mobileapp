import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../infrastructure/medicine/interactions_service.dart';
import '../models/drug.dart';
import '../models/simple_medicine.dart';

import '../app_state.dart';
import '../models/exam.dart';
import '../my_config.dart';

class InteractionsProvider with ChangeNotifier {
  AppState appState = AppState.init;
  String? errorMessage;
  Map<String, dynamic>? response;
  InteractionsService interactionsService = InteractionsService();
  int currentPage = 1;

  List<Exam> _exams = [];

  List<Exam> get exams {
    return [..._exams];
  }

  Future<void> getInteractions() async {
    final Map<String, dynamic> person = {
      'name': 'John Doe',
      'age': 30,
      'address': {'street': '123 Main St', 'city': 'Anytown', 'state': 'CA'}
    };

    // Encoding the object as JSON
    final String jsonString = jsonEncode(person);
    print(jsonString);

    // Decoding the JSON string back to a Dart object
    final Map<String, dynamic> decodedPerson = jsonDecode(jsonString);
    print(decodedPerson);
    String jsonData =
        '[{"name": "5-fluorouracil -ebewe 250mg/5ml i.v. vial","name_ar": "5-فلورويوراسيل ايبوي 250مجم/5مل فيال وريد","drug": [{"id": 315,"name": "fluorouracil injection"}],"medicine_images": [{"id": 39,"image": "http://127.0.0.1:8001/media/medicines/images/drug_XOI3Btu.jpg"}]},{"name": "abimol 150mg/5ml 125ml syrup","name_ar": "ابيمول 150مجم/5مل 125 مل شراب","drug": [{"id": 315,"name": "ginkgo biloba"}],"medicine_images": [{"id": 39,"image": "http://127.0.0.1:8001/media/medicines/images/drug_XOI3Btu.jpg"}]},{"name": "abimol 300mg 5 rectal supp.","name_ar": "ابيمول 300مجم لبوس 5 اقماع شرجية","drug": [{"id": 315,"name": "levetiracetam"}],"medicine_images": [{"id": 39,"image": "http://127.0.0.1:8001/media/medicines/images/drug_XOI3Btu.jpg"}]}]';

    // List<SimpleMedicine> jsonList =
    //     json.decode(jsonData);
    // List<SimpleMedicine> medicineList = medicineListFromJson(jsonData);

    // for (Map<String, dynamic> jsonMap in jsonList) {
    //   SimpleMedicine medicine = SimpleMedicine.fromJson(jsonMap);
    //   medicineList.add(medicine);
    // }

    // medicineList.map((e) => log('$e[name]')).toList();
    log('${json.decode(jsonData)}');
    appState = AppState.loading;
    notifyListeners();
    final responseData =
        await interactionsService.medicineInteraction(json.decode(jsonData));
    if (responseData['detail'] != null) {
      errorMessage = responseData['detail'];
      // print(responseData['detail']);
      appState = AppState.error;
    } else {
      response = responseData;
      List<Exam> loadedData = [];

      log("$responseData");
      // _exams = _exams + loadedData;
      // currentPage += 1;
      // log('$response');
      appState = AppState.done;
    }
    notifyListeners();
  }

  Future<void> getSingleExam() async {
    const dynamic apiEndPoint = Config.apiUrl;
    final examsEndPoint = Uri.parse(apiEndPoint + '/exam/exams/');

    await http.get(examsEndPoint);
  }
}
