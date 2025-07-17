import 'package:flutter/material.dart';

class HomePage extends StatelessWidget { // won't change/not dynamic
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // top nav bar with title
        title: const Text('Homepage'),
        centerTitle: true,
      ),

      // main screen, includes buttons for different screens
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        // maybe add subtitle area here for welcome message later
        child: Center(
          child: Wrap(
            spacing: 20, // horizontal spacing
            runSpacing: 20, // vertical spacing
            children: [

              // weekly schedule
              SizedBox(
                // height and width for now
                width: 130,
                height: 130,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/weekly'); // navs to page, will be implemented later
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // makes rounded corners
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    elevation: 4, // drop shadow
                  ),
                  child: const Text('Weekly\nSchedule', textAlign: TextAlign.center),
                ),
              ),

              // todo list
              SizedBox(
                width: 130,
                height: 130,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/todo'); // nav to page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    elevation: 4,
                  ),
                  child: const Text('To-Do\nList', textAlign: TextAlign.center),
                ),
              ),

              // settings
              SizedBox(
                width: 130,
                height: 130,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings'); // nav to page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    elevation: 4,
                  ),
                  child: const Text('Settings', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}