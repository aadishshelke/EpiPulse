import 'package:flutter/material.dart';
import 'report_issue_screen.dart';

class WaterQualityScreen extends StatefulWidget {
  const WaterQualityScreen({Key? key}) : super(key: key);

  @override
  State<WaterQualityScreen> createState() => _WaterQualityScreenState();
}

class _WaterQualityScreenState extends State<WaterQualityScreen> {
  // Mock sensor data
  double ph = 7.2;
  double turbidity = 2.5;
  double tds = 350;
  String villageName = "Your Village";

  @override
  Widget build(BuildContext context) {
    bool phUnsafe = ph < 6.5 || ph > 8.5;
    bool turbidityUnsafe = turbidity >= 5;
    bool tdsUnsafe = tds >= 500;
    bool isUnsafe = phUnsafe || turbidityUnsafe || tdsUnsafe;

    List<Map<String, dynamic>> sensors = [
      {
        'label': 'pH Level',
        'icon': Icons.science,
        'value': ph,
        'unit': '',
        'safe': !phUnsafe,
        'min': 0,
        'max': 14,
        'safeRange': '6.5–8.5',
      },
      {
        'label': 'Turbidity',
        'icon': Icons.opacity,
        'value': turbidity,
        'unit': 'NTU',
        'safe': !turbidityUnsafe,
        'min': 0,
        'max': 10,
        'safeRange': '<5',
      },
      {
        'label': 'TDS',
        'icon': Icons.water_drop,
        'value': tds,
        'unit': 'ppm',
        'safe': !tdsUnsafe,
        'min': 0,
        'max': 1000,
        'safeRange': '<500',
      },
    ];

    List<Map<String, dynamic>> tips = [
      {'icon': Icons.local_fire_department, 'text': 'Boil water for 10+ minutes'},
      {'icon': Icons.medical_services, 'text': 'Use chlorine tablets'},
      {'icon': Icons.filter_alt, 'text': 'Use clean cloth for filtering'},
      {'icon': Icons.hourglass_bottom, 'text': 'Let water settle before using'},
      {'icon': Icons.water, 'text': 'Use RO/filter if available'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Quality'),
        actions: [
          IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: () {}, // TODO: Implement location reselect
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {}, // TODO: Implement refresh
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Live status for $villageName',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              if (isUnsafe)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.warning, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '⚠️ UNSAFE WATER DETECTED\nReal-time data shows potential contamination in your area.',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sensors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, i) {
                    final s = sensors[i];
                    final color = s['safe'] ? Colors.green : Colors.red;
                    return Container(
                      width: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(s['icon'], color: color, size: 32),
                          const SizedBox(height: 8),
                          Text(s['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('${s['value']} ${s['unit']}', style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Safe: ${s['safeRange']}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (isUnsafe) ...[
                const SizedBox(height: 24),
                const Text('Water Purification Tips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tips.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final t = tips[i];
                      return Card(
                        color: Colors.blue[50],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Icon(t['icon'], color: Colors.blue),
                              const SizedBox(width: 8),
                              SizedBox(width: 100, child: Text(t['text'], style: const TextStyle(fontSize: 13))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
          // Sticky Report Water Issue Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Report Water Issue'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportIssueScreen()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 