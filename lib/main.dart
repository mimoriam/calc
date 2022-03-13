import 'package:flutter/material.dart';

/// Third-party FOSS packages:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        FormBuilderLocalizations.delegate,
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  double? result;
  String err = "";
  String re = r'[\d\(\)\+\-\*\/\.]';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: "calc_field",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.match(context, re),
                        ]),
                        decoration: InputDecoration(
                          labelText: "Please enter your equation here",
                          icon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        // keyboardType: TextInputType.number,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: result == null ? const Text("") : Text("Answer: ${result.toString()}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: err == "" ? const Text("") : const Text("Error!"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _formKey.currentState?.save();
                            if (_formKey.currentState!.validate()) {
                              try {
                                Parser p = Parser();
                                Expression exp = p.parse(_formKey.currentState!.fields['calc_field']!.value);
                                ContextModel cm = ContextModel();
                                double eval = exp.evaluate(EvaluationType.REAL, cm);
                                setState(() {
                                  result = eval;
                                  err = "";
                                });
                              } catch (e) {
                                setState(() {
                                  err = "Error!";
                                });
                              }
                            } else {
                              // print("validation failed");
                            }
                          },
                          child: const Text("Calculate"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
