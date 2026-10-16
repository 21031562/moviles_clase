import 'package:firebase_auth/firebase_auth.dart';

class EmailAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Regresa null si el usuario se creó correctamente, o el mensaje de error.
  Future<String?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Ese email ya está registrado';
        case 'invalid-email':
          return 'Email no válido';
        case 'weak-password':
          return 'La contraseña es muy débil';
        case 'operation-not-allowed':
          return 'El registro con email no está habilitado en Firebase';
        case 'network-request-failed':
          return 'Sin conexión a internet';
        default:
          return e.message ?? 'Error al registrar';
      }
    } catch (e) {
      return 'Error al registrar: $e';
    }
  }

  /// Regresa null si el inicio de sesión fue correcto, o el mensaje de error.
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        return 'Verifica tu email antes de iniciar sesión';
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'Email no válido';
        case 'user-disabled':
          return 'Esta cuenta está deshabilitada';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email o contraseña incorrectos';
        case 'too-many-requests':
          return 'Demasiados intentos, intenta más tarde';
        case 'network-request-failed':
          return 'Sin conexión a internet';
        default:
          return e.message ?? 'Error al iniciar sesión';
      }
    } catch (e) {
      return 'Error al iniciar sesión: $e';
    }
  }
}
