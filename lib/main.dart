// **************بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيم***************
//this is an easy App that displays HunterxHunter main caracters images, The user click a button and choose which caracter he want to display.
//Gon and Kilua images are fetched from web and Leoreo and kuarapika images are from App assets
//Copyright
//12/02/2024

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

int buildnumer = 4;
//history : error of network absence issues while using error builder from network image
//problem error catching (socket exception and others) by using head request and future builder
//exeption XMLHttpRequest error to be handled for chrome (check if chrome always needs connectivity)
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("HxH characters"),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: const DisplayImage(),
      ),
    ),
  );
}

class DisplayImage extends StatefulWidget {
  const DisplayImage({Key? key}) : super(key: key);

  @override
  State<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends State<DisplayImage> {
  String characterName = '';
  String imageUrl = '';
  final List<String> characters = ['Gon', 'Kilua', 'Kurapika', 'Leoreo'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) => Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        setState(() => characterName = characters[index]),
                    child: Text(characters[index]),
                  ),
                  const Text('')
                ],
              ),
            ),
          ),
        ),
        //the image is shown here
        Expanded(child: ChosenCharacterImage(characterName: characterName)),
        Text('build : $buildnumer')
      ],
    );
  }

//  Widget chosenCharacterImage(String characterName) {}
}

class ChosenCharacterImage extends StatelessWidget {
  final String characterName;

  const ChosenCharacterImage({super.key, required this.characterName});

  @override
  Widget build(BuildContext context) {
    String imageUrl = '';
    switch (characterName) {
      case 'Gon':
        imageUrl =
            'https://m.media-amazon.com/images/M/MV5BNjNkODU2ZGMtODdhOC00MTU0LTllNzItYzhjNWViOTMzNzFmXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_QL75_UX500_CR0,0,500,281_.jpg';
        break;
      case 'Kilua':
        imageUrl = 'https://media.tenor.com/6cu5bNft-XMAAAAe/killua-anime.png';
        break;
      case 'Kurapika':
        return const Image(image: AssetImage('images/Kurapika.png'));
      case 'Leoreo':
        return const Image(image: AssetImage('images/Leoreo.png'));
      default:
        return const Text('\n\n\nChoose your character to display his image');
    }

    return FutureBuilder(
      future: loadImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error: No internet connection'));
        } else {
          return Image(image: NetworkImage(imageUrl));
        }
      },
    );
  }

  Future testURL(String url) async {
    return await http.head(Uri.parse(url));
  }

  Future<http.Response> loadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to load image: $e');
    } on SocketException catch (e) {
      throw Exception('Failed to load image: $e');
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }
}
//Failed to fetch