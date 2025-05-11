import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveAlertsScreen extends StatefulWidget {
  const LiveAlertsScreen({Key? key}) : super(key: key);

  @override
  State<LiveAlertsScreen> createState() => _LiveAlertsScreenState();
}

class _LiveAlertsScreenState extends State<LiveAlertsScreen> {
  String villageName = "Your Village";
  String selectedTab = 'All';
  List<Map<String, dynamic>> alerts = [
    {
      "type": "water",
      "title": "Unsafe Water Warning",
      "message": "Turbidity levels exceed safe limits in your area.",
      "timestamp": "2 mins ago",
      "severity": "Critical",
      "details": "Water samples from the main supply show high turbidity. Avoid drinking tap water until further notice.",
    },
    {
      "type": "health",
      "title": "Cholera Alert",
      "message": "3 suspected cholera cases reported today.",
      "timestamp": "Today at 9:20 AM",
      "severity": "Medium",
      "details": "Local health authorities are investigating 3 suspected cases of cholera. Practice good hygiene and report symptoms immediately.",
    },
    {
      "type": "vector",
      "title": "Dengue Mosquito Cluster",
      "message": "High mosquito density detected around your location.",
      "timestamp": "Yesterday at 5:00 PM",
      "severity": "Low",
      "details": "Mosquito traps have detected increased activity. Use repellents and remove standing water.",
    },
    {
      "type": "weather",
      "title": "Heatwave Warning",
      "message": "Temperatures expected to exceed 42°C today.",
      "timestamp": "Today at 7:00 AM",
      "severity": "Critical",
      "details": "Stay indoors during peak hours. Drink plenty of water and check on vulnerable neighbors.",
    },
  ];

  final Map<String, IconData> typeIcons = {
    'health': Icons.coronavirus,
    'water': Icons.water_drop,
    'weather': Icons.wb_sunny,
    'vector': Icons.bug_report,
  };

  final Map<String, Color> severityColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'Critical': Colors.red,
  };

  List<String> tabs = ['All', 'Health', 'Water', 'Weather', 'Vector'];

  List<Map<String, dynamic>> get filteredAlerts {
    if (selectedTab == 'All') return alerts;
    return alerts.where((a) => a['type'].toString().toLowerCase() == selectedTab.toLowerCase()).toList();
  }

  void _refreshAlerts() {
    // TODO: Implement real backend fetch
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAlerts,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 16, right: 16),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  villageName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Text('Real-time updates for your area', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final tab = tabs[i];
                return ChoiceChip(
                  label: Text(tab),
                  selected: selectedTab == tab,
                  onSelected: (_) => setState(() => selectedTab = tab),
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: selectedTab == tab ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Alerts List
          Expanded(
            child: filteredAlerts.isEmpty
                ? const Center(child: Text('No alerts for this category.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAlerts.length,
                    itemBuilder: (context, i) {
                      final alert = filteredAlerts[i];
                      return _AlertCard(
                        alert: alert,
                        icon: typeIcons[alert['type']] ?? Icons.warning,
                        color: severityColors[alert['severity']] ?? Colors.grey,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatefulWidget {
  final Map<String, dynamic> alert;
  final IconData icon;
  final Color color;
  const _AlertCard({required this.alert, required this.icon, required this.color});

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final alert = widget.alert;
    final isCritical = alert['severity'] == 'Critical';
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => expanded = !expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: widget.color.withOpacity(0.15),
                    child: Icon(widget.icon, color: widget.color, size: 28),
                    radius: 24,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alert['severity'],
                                style: TextStyle(
                                  color: widget.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(alert['timestamp'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(alert['message'], style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.chevron_right, color: Colors.grey),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: 12),
                Text(alert['details'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.black87)),
                if (alert['severity'] == 'Critical')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        if (alert['type'] == 'health')
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.local_hospital),
                              label: const Text('Call Doctor'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () {
                                // TODO: Implement call doctor
                              },
                            ),
                          ),
                        if (alert['type'] == 'water' || alert['type'] == 'weather')
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.info),
                              label: const Text('View Tips'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                              onPressed: () {
                                // TODO: Show tips modal
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 