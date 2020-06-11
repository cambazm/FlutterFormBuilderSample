import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:frombuilderapp/data.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
          // labelStyle: TextStyle(color: Colors.purple),
          border: OutlineInputBorder(
            gapPadding: 10,
            borderSide: BorderSide(color: Colors.purple),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
      GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);
  var genderOptions = ['Erkek', 'Kadin', 'Belirtmek istemiyorum'];
  final requiredErrorTextInfo = 'Zorunlu Alan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FormBuilder Sample"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              // autovalidate: true,
              readOnly: false,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    attribute: "name_surname",
                    decoration: InputDecoration(
                      labelText: "Isim Soyisim",
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: requiredErrorTextInfo,
                      ),
                    ],
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    attribute: "email",
                    decoration: InputDecoration(
                      labelText: "E-Posta",
                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.required(
                        errorText: requiredErrorTextInfo,
                      ),
                      FormBuilderValidators.email(errorText: 'Gecerli bir e-posta giriniz'),
                    ],
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    attribute: "date",
                    onChanged: _onChanged,
                    inputType: InputType.date,
                    decoration: InputDecoration(
                      labelText: "Dogum Tarihi",
                    ),
                    validators: [
                      FormBuilderValidators.required(
                        errorText: requiredErrorTextInfo,
                      ),
                    ],
                    //initialValue: DateTime.now().subtract(new Duration(days: 18*365)),
                    // readonly: true,
                  ),
                  SizedBox(height: 10),
                  FormBuilderCheckbox(
                    attribute: 'accept_terms',
                    initialValue: false,
                    onChanged: _onChanged,
                    leadingInput: true,
                    label: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Kosullari kabul ediyorum',
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print("Navigate to relevant screen");
                              },
                          ),
                        ],
                      ),
                    ),
                    validators: [
                      FormBuilderValidators.required(
                        errorText:
                            "Devam etmek icin kosullari kabul etmelisiniz",
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    attribute: "",
                    decoration: InputDecoration(
                      labelText: "Sayi",
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(
                        errorText: requiredErrorTextInfo,
                      ),
                      FormBuilderValidators.numeric(errorText: 'Gecerli bir sayi giriniz'),
                      FormBuilderValidators.max(100, errorText: 'Sayi 100''den buyuk olamaz'),
                      FormBuilderValidators.min(0, errorText: 'Sayi negatif olamaz'),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  FormBuilderDropdown(
                    attribute: "gender",
                    decoration: InputDecoration(
                      labelText: "Cinsiyet",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 20,
                        ),
                      ),
                    ),
                    // initialValue: 'Male',
                    hint: Text('Cinsiyet seciniz'),
                    items: genderOptions
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text('$gender'),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTypeAhead(
                    decoration: InputDecoration(
                      labelText: "Ulke",
                    ),
                    attribute: 'country',
                    onChanged: _onChanged,
                    itemBuilder: (context, country) {
                      return ListTile(
                        title: Text(country),
                      );
                    },
                    controller: TextEditingController(text: ''),
                    initialValue: "Turkey",
                    suggestionsCallback: (query) {
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return allCountries.where((country) {
                          return country.toLowerCase().contains(lowercaseQuery);
                        }).toList(growable: false)
                          ..sort((a, b) => a
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(
                                  b.toLowerCase().indexOf(lowercaseQuery)));
                      } else {
                        return allCountries;
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  FormBuilderRadio(
                    decoration: InputDecoration(labelText: 'Addres Seciniz'),
                    attribute: "address",
                    options: [
                      FormBuilderFieldOption(
                        value: 1,
                        child: Text('Adres 1'),
                      ),
                      FormBuilderFieldOption(
                        value: 2,
                        child: Text('Adres 2'),
                      ),
                      FormBuilderFieldOption(
                        value: 3,
                        child: Text('Adres 2'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FormBuilderChoiceChip(
                    attribute: 'delivery_time_choice',
                    decoration: InputDecoration(
                      labelText: 'Teslimat zamani seciniz',
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: '09:00-11:00', child: Text('09:00-11:00')),
                      FormBuilderFieldOption(
                          value: '11:00-13:00', child: Text('11:00-13:00')),
                      FormBuilderFieldOption(
                          value: '13:00-15:00', child: Text('13:00-15:00')),
                      FormBuilderFieldOption(
                          value: '15:00-17:00', child: Text('15:00-17:00')),
                      FormBuilderFieldOption(
                          value: '17:00-19:00', child: Text('17:00-19:00')),
                      FormBuilderFieldOption(
                          value: '19:00-21:00', child: Text('19:00-21:00')),
                    ],
                    validators: [
                      FormBuilderValidators.required(
                        errorText: requiredErrorTextInfo,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  FormBuilderSwitch(
                    label: Text('Temassiz teslimat'),
                    attribute: "contactless_delivery",
                    initialValue: false,
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 10),
                  FormBuilderCheckbox(
                    label: Text('Zili calma'),
                    attribute: "dont_ring",
                    initialValue: false,
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 10),
                  /*FormBuilderPhoneField(
                    attribute: 'phone_number',

                    initialValue: "0",
                    cursorColor: Colors.black,
                    // style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Cep telefonu",

                    ),
                    onChanged: _onChanged,
                    validators: [
                      FormBuilderValidators.numeric(
                          errorText: 'Hatali Cep Telefonu Numarasi'),
                      FormBuilderValidators.required(
                          errorText: 'Lutfen Cep Telefonu Bilgisini Giriniz')
                    ],
                  ),*/
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    attribute: "phone",
                    decoration: InputDecoration(
                      labelText: "Cep Telefonu Numarasi",
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(
                        errorText: requiredErrorTextInfo,
                      ),
                      FormBuilderValidators.numeric(errorText: 'Gecerli bir sayi giriniz'),
                      FormBuilderValidators.maxLength(10, errorText: 'Telefon 10 karakterden olusmaktadir'),
                      FormBuilderValidators.minLength(10, errorText: 'Telefon 10 karakterden olusmaktadir'),
                      //FormBuilderValidators.pattern('\b5\d{9}\b', errorText: 'Cep telefonu 5 ile baslar ve 10 karakterden olusmaktadir'),
                    ],
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Devam",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                      } else {
                        print(_fbKey.currentState.value);
                        print("validation failed");
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Sifirla",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      _fbKey.currentState.reset();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
