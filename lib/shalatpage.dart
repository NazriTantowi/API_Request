import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ShalatPage extends StatelessWidget {
  const ShalatPage({Key? key});

  Future<List<Map<String, dynamic>>> _fetchPrayerTimes() async {
    final response = await http.get(Uri.parse(
        'https://prayertimes.api.abdus.dev/api/diyanet/prayertimes?location_id=9541'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Map<String, dynamic>> todayData = [];

      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      for (final prayerTime in data) {
        final date = DateTime.parse(prayerTime['date']);
        final formattedPrayerDate = DateFormat('yyyy-MM-dd').format(date);

        if (formattedPrayerDate == formattedDate) {
          todayData.add(prayerTime);
          break; // Assuming there's only one entry for today in the API data
        }
      }

      return todayData;
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPrayerTimes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final prayerTimes = snapshot.data ?? [];
            if (prayerTimes.isEmpty) {
              return const Center(child: Text('No data available for today.'));
            }

            final prayerTime = prayerTimes[0]; // Get the only data available for today
            final date = DateTime.parse(prayerTime['date']);
            final formattedDate = DateFormat('yyyy-MM-dd').format(date);

            return ListTile(
              title: Text('Date: $formattedDate'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fajr: ${prayerTime['fajr']}',),
                  Text('Sunrise: ${prayerTime['sun']}'),
                  Text('Dhuhr: ${prayerTime['dhuhr']}'),
                  Text('Asr: ${prayerTime['asr']}'),
                  Text('Maghrib: ${prayerTime['maghrib']}'),
                  Text('Isha: ${prayerTime['isha']}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
