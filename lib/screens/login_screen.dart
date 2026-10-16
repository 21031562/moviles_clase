import 'package:flutter/material.dart';
import 'package:flutter_application_1/conf_nube/email_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading = true;
    setState(() {});

    final error = await EmailAuth().signIn(
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

    Navigator.pushNamed(context, "/dash");
  }

  @override
  Widget build(BuildContext context) {
    final txtUser = TextFormField(
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
          return 'Ingresa tu contraseña';
        }
        return null;
      },
    );

    final loading = Positioned(
      top: 480,
      child: CircularProgressIndicator(color: Colors.white),
    );

    final btnLogin = ElevatedButton(
      onPressed: _isLoading ? null : _login,
      child: Row(
        children: [
          Icon(Icons.login),
          SizedBox(width: 14),
          Text('Iniciar Sesión'),
        ],
      ),
    );

    final btnRegistrar = TextButton(
      onPressed: () => Navigator.pushNamed(context, "/register"),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      child: Text('¿No tienes cuenta? Regístrate'),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/foto.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 80,
              child: Image.asset('assets/nasa.png', height: 180, width: 180),
            ),
            Positioned(
              width: 300,
              bottom: 300,
              child: Container(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      txtUser,
                      Divider(height: 10, color: Colors.transparent),
                      txtPassword,
                      Divider(height: 10, color: Colors.transparent),
                      btnLogin,
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            Positioned(bottom: 240, child: btnRegistrar),
            _isLoading ? loading : Container(),
          ],
        ),
      ),
    );
  }
}
