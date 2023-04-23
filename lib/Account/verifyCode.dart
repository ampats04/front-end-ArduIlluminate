import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyCode extends StatefulWidget {
  final String email;

  VerifyCode({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isButtonDisabled = true;

  void _verifyCode() {
    // Ari ra mag add nya if naa na backend
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification Successful'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Verification Failed. Please enter a valid 6-digit code.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Code'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 25),
                const Text(
                  'Enter the 6-digit code sent to your email address to reset your password.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: '6-Digit Code',
                      labelStyle: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 6) {
                        return 'Please enter a valid 6-digit code';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _isButtonDisabled = !_formKey.currentState!.validate();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () {
                          _verifyCode();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: _isButtonDisabled
                        ? Colors.grey
                        : const Color(0xFF0047FF),
                  ),
                  child: const Text(
                    'Verify Code',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
