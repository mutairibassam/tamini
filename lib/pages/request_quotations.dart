import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:tamini_app/common/quotation_service.dart';
import 'package:tamini_app/components/birth_date_picker.dart';
import 'package:tamini_app/components/custom_text_field.dart';
import 'package:tamini_app/components/quotations/quotation_description_panel.dart';
import 'package:tamini_app/components/quotations/quotation_service_cost.dart';

class RequestQuotations extends StatefulWidget {
  const RequestQuotations({
    super.key,
  });

  @override
  State<RequestQuotations> createState() => _RequestQuotationsState();
}

class _RequestQuotationsState extends State<RequestQuotations> {
  String? uid;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;
    uid = user?.uid;
    phoneNumber = user?.phoneNumber;
    birthDateController.text = formatDate(initialDate);
  }

  DateTime initialDate = DateTime.now();
  DateTime initialDateForTest = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController nationalIdNumberController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController carSerialNumberController = TextEditingController();
  QuotationService quotationService = QuotationService();

  String formatDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}"; // Format date as you need
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request_Quotations'.i18n()), // Use the i18n() method to get the translated string
      ),
      body: Center(
        child: ListView(
          children: [
            const QuotationDescriptionPanel(),
            const QuotationServiceCost(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomTextField(
                    controller: nationalIdNumberController,
                    labelText: 'Governemnt_ID/Iqama_ID'.i18n(),
                    hintText: 'enter_Governemnt_ID/Iqama_ID'.i18n(),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomTextField(
                    prefixIcon: BirthDatePicker(
                      onDateChanged: (newDate) {
                        setState(() {
                          initialDate = newDate;
                          birthDateController.text = formatDate(initialDate);
                        });
                      },
                    ),
                    controller: birthDateController,
                    labelText: 'birth_date'.i18n(),
                    hintText: 'enter_birth_date'.i18n(),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomTextField(
                    controller: carSerialNumberController,
                    labelText: 'vehicle_serial_number'.i18n(),
                    hintText: 'enter_vehicle_serial_number'.i18n(),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(221, 0, 167, 117)),
                    ),
                    onPressed: () {
                      if (birthDateController.text != formatDate(initialDateForTest) &&
                          nationalIdNumberController.text.isNotEmpty &&
                          birthDateController.text.isNotEmpty &&
                          carSerialNumberController.text.isNotEmpty) {
                        quotationService.requestQuotation(
                            context,
                            nationalIdNumberController.text,
                            birthDateController.text,
                            carSerialNumberController.text,
                            uid!,
                            phoneNumber!,
                            'request_added'.i18n());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please_ensure_all_fields_are_filled_out_carefully'.i18n())));
                      }
                    },
                    child: Text(
                      'request_for_quotation'.i18n(),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
