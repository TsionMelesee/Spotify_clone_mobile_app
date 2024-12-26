import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> trendingAlbums = [];
  bool showAll = false;
  bool isLoading = true;

  final String clientId = '769ea67eaf0344fdb27de3b978519b7c';
  final String clientSecret = '1101f37a87704d93a31113d701001937';

  int _selectedIndex = 0; // Tracks the selected index for navigation

  @override
  void initState() {
    super.initState();
    fetchTrendingAlbums();
  }

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization':
            'Basic ${base64Encode(utf8.encode("$clientId:$clientSecret"))}',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    } else {
      throw Exception('Failed to fetch access token');
    }
  }

  Future<void> fetchTrendingAlbums() async {
    try {
      final token = await getAccessToken();
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/browse/new-releases'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          trendingAlbums = json.decode(response.body)['albums']['items'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch albums');
      }
    } catch (error) {
      print('Error fetching trending albums: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleAlbumClick(Map<String, dynamic> album) {
    if (album['id'] == 'your-playlist') {
      Navigator.pushNamed(context, '/playlist');
    } else {
      Navigator.pushNamed(
        context,
        '/album/${album['id']}',
        arguments: album,
      );
    }
  }

  // Function to handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add your navigation logic based on the selected index
    if (index == 0) {
      // Home
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      // Search
      Navigator.pushReplacementNamed(context, '/search');
    } else if (index == 2) {
      // Library
      Navigator.pushReplacementNamed(context, '/library');
    } else if (index == 3) {
      // Premium
      Navigator.pushReplacementNamed(context, '/premium');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Clone'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1e1e1e), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your Playlist Section
              Text(
                'Your Playlist',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: () => handleAlbumClick(
                    {'id': 'your-playlist', 'name': 'Your Playlist'}),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Image.asset(
                    'assets/vinylrecord.jpg',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Trending Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAll = !showAll;
                      });
                    },
                    child: Text(
                      showAll ? 'Show Less' : 'Show All',
                      style: TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // Trending Albums
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Adjust based on screen size
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: showAll
                          ? trendingAlbums.length
                          : (trendingAlbums.length > 6
                              ? 6
                              : trendingAlbums.length),
                      itemBuilder: (context, index) {
                        final album = trendingAlbums[index];
                        return GestureDetector(
                          onTap: () => handleAlbumClick(album),
                          child: Column(
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(album['images'][0]['url']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                album['name'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Premium',
          ),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
