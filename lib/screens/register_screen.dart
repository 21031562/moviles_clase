import 'package:flutter/material.dart';
import 'package:flutter_application_1/conf_nube/email_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final conEmail = TextEditingController();
  final conPassword = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    conEmail.dispose();
    conPassword.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading = true;
    setState(() {});

    final error = await EmailAuth().createUser(
      email: conEmail.text.trim(),
      password: conPassword.text,
    );

    if (!mounted) return;
    _isLoading = false;
    setState(() {});

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cuenta creada. Revisa tu correo para verificarla.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final txtEmail = TextFormField(
      controller: conEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingresa tu email';
        }
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
          return 'Email no válido';
        }
        return null;
      },
    );

    final txtPassword = TextFormField(
      controller: conPassword,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa una contraseña';
        }
        if (value.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
    );

    final btnRegistrar = ElevatedButton(
      onPressed: _isLoading ? null : _registrar,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add),
          SizedBox(width: 14),
          Text('Registrar'),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/foto.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  txtEmail,
                  Divider(height: 10, color: Colors.transparent),
                  txtPassword,
                  Divider(height: 20, color: Colors.transparent),
                  btnRegistrar,
                  if (_isLoading)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
