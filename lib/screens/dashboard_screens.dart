import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/menu_circular.dart';

class DashboardScreens extends StatelessWidget {
  const DashboardScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), leading: Container()),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Uriel Alejandro Martinez Martinez'),
              accountEmail: Text('21031562@itcelaya.edu.mx'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/jake.jpg'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              trailing: Icon(Icons.arrow_forward_outlined),
              onTap: () {
                Navigator.pop(context);
              },
              subtitle: Text('Página principal del dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Lista de notas'),
              trailing: Icon(Icons.arrow_forward_outlined),
              onTap: () {
                Navigator.pushNamed(context, '/note');
              },
              subtitle: Text('Accede a tus notas guardadas'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Lista de notas en la nube'),
              trailing: Icon(Icons.arrow_forward_outlined),
              onTap: () {
                Navigator.pushNamed(context, '/notesNube');
              },
              subtitle: Text('Accede a tus notas guardadas en la nube'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              trailing: Icon(Icons.arrow_forward_outlined),
              onTap: () {
                //Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
              subtitle: Text('Salir de la aplicación'),
            ),
          ],
        ),
      ),
      floatingActionButton: MenuCircular(),
    );
  }
}
