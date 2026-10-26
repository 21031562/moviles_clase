import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/popular_model.dart';
import 'package:flutter_application_1/network/api_popular.dart';

class ApiPopularScreen extends StatefulWidget {
  const ApiPopularScreen({super.key});

  @override
  State<ApiPopularScreen> createState() => _ApiPopularScreenState();
}

class _ApiPopularScreenState extends State<ApiPopularScreen> {
  late final ApiPopular apiPopular;
  late final Future<List<PopularModel>> _popularFuture;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    _popularFuture = apiPopular.getAllPopular().then(
      (popular) => popular ?? <PopularModel>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Popular Movies")),
      body: FutureBuilder<List<PopularModel>>(
        future: _popularFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];

                return _popularItem(movie);
              },
            );
          } else {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }

  Widget _popularItem(PopularModel pelicula) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(
            child: pelicula.posterPath.isNotEmpty
                ? FadeInImage.assetNetwork(
                    // Reemplaza esta ruta por el recurso de placeholder de tu proyecto.
                    placeholder: 'assets/loading.gif',
                    image:
                        'https://image.tmdb.org/t/p/w500${pelicula.posterPath}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 400),
                    imageErrorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.movie)),
                  )
                : const Center(child: Icon(Icons.movie)),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              pelicula.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
