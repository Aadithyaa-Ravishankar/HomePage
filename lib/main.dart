import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wikofpppwglxphlbogrt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indpa29mcHBwd2dseHBobGJvZ3J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5MDAxNDgsImV4cCI6MjA1NjQ3NjE0OH0.OfcIem2a9IbvFnxdLeajJzkCVtu_enb5NN3JWShtl0A',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  String? profilePhoto, username, oneLine;
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchEvents();
  }

  Future<void> fetchUserData() async {
    final response = await supabase
        .from('users')
        .select('profile_photo, username, one_line')
        .eq('email', 'aadithyaars10@gmail.com')
        .single();

    setState(() {
      profilePhoto = response['profile_photo'];
      username = response['username'];
      oneLine = response['one_line'];
    });
  }

  Future<void> fetchEvents() async {
    final response = await supabase.from('events').select('poster, event_name, description');
    setState(() {
      events = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: profilePhoto != null
                  ? NetworkImage(profilePhoto!)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username ?? 'Loading...', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(oneLine ?? 'Loading...', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )
          ],
        ),
        actions: [
          Transform.translate(
            offset: const Offset(-10, 0), // Move left by 10 pixels
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.mail, size: 36),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Your events', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          event['poster'],
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event['event_name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(
                              event['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('See more', style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures equal spacing
        showSelectedLabels: false, // Hide labels
        showUnselectedLabels: false, // Hide labels
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home.svg', width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/search.svg', width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/add.svg', width: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/profile.svg', width: 30),
            label: '',
          ),
        ],
      ),

    );
  }
}
