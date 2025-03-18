import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Sample notifications list
  final List<Map<String, String>> notifications = [
    {
      "title": "Order Shipped",
      "message": "Your order #12345 has been shipped. Track your order now!",
    },
    {
      "title": "Limited Time Offer!",
      "message": "Get 20% off on all fresh vegetables. Hurry, offer ends soon!",
    },
    {
      "title": "Cart Reminder",
      "message": "You have items in your cart. Complete your purchase today!",
    },
    {
      "title": "New Arrivals",
      "message": "Fresh organic fruits just arrived. Check them out now!",
    },
    {
      "title": "Payment Successful",
      "message": "Your payment of ₹599 was successful. Thank you for shopping!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.green, // Change color as needed
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.green),
              title: Text(
                notifications[index]["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notifications[index]["message"]!),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    notifications.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
