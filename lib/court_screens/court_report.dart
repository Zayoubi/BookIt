import 'package:final_project/court_screens/court_owner_home.dart';
import 'package:final_project/users_screens/court_owner.dart';
import 'package:flutter/material.dart';

class ReservationReportPage extends StatelessWidget {
  const ReservationReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_)=>const CourtOwner(),
                ));
          },
        ),
        title: const Text('Reservation Reports'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportCard(
                title: 'Total Reservations',
                value: '120',
                icon: Icons.calendar_today,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Most Booked Time Slot',
                value: '6 PM - 7 PM',
                icon: Icons.access_time,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Most Active Player',
                value: 'John Doe (15 bookings)',
                icon: Icons.person,
                color: Colors.purple,
              ),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Revenue Generated',
                value: '\$3000',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Monthly Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildMonthlyBreakdown(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBreakdown() {
    return Column(
      children: const [
        _MonthlyStat(month: 'January', reservations: 25),
        _MonthlyStat(month: 'February', reservations: 18),
        _MonthlyStat(month: 'March', reservations: 30),
        _MonthlyStat(month: 'April', reservations: 22),
        _MonthlyStat(month: 'May', reservations: 25),
        _MonthlyStat(month: 'June', reservations: 35),
        _MonthlyStat(month: 'July', reservations: 40),
      ],
    );
  }
}

class _MonthlyStat extends StatelessWidget {
  final String month;
  final int reservations;

  const _MonthlyStat({
    required this.month,
    required this.reservations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '$reservations reservations',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
