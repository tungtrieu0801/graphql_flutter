import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter(); // for cache
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GraphQL Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GraphQL Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> characters = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: characters.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Image(
                  image: NetworkImage(
                    characters[index]['image'],
                  ),
                ),
                title: Text(
                  characters[index]['name'],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(characters[index]['status']),
                    Text(characters[index]['gender']),
                    Text(characters[index]['species']),
                    Text(
                      characters[index]['location']?['dimension'] ?? 'Unknown',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void fetchData() async {
    HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql(
          """query {
            characters() {
              results {
                name
                image 
                status
                species
                gender
                location {
                  dimension  
                }
              }
            }
          }""",
        ),
      ),
    );

    setState(() {
      characters = queryResult.data!['characters']['results'];
      _loading = false; // Đặt `_loading` thành `false` khi dữ liệu đã được tải xong.
    });
  }
}
