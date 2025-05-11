import 'package:flutter/material.dart';

class SymptomResultScreen extends StatelessWidget {
  final String severity;
  final List<String> selectedSymptoms;

  const SymptomResultScreen({
    Key? key, 
    required this.severity,
    required this.selectedSymptoms,
  }) : super(key: key);

  String _getIllnessGuess() {
    if (severity == "High") {
      return "Severe Waterborne Infection";
    } else if (severity == "Medium") {
      return "Moderate Waterborne Infection";
    } else {
      return "Mild Waterborne Infection";
    }
  }

  List<String> _getTips() {
    List<String> tips = [];
    
    if (selectedSymptoms.contains('Diarrhea') || selectedSymptoms.contains('Nausea')) {
      tips.add("• Use ORS (Oral Rehydration Solution)");
      tips.add("• Eat a bland diet (BRAT: Bananas, Rice, Applesauce, Toast)");
      tips.add("• Avoid outside food and dairy products");
    }
    
    if (selectedSymptoms.contains('Fever')) {
      tips.add("• Take paracetamol if prescribed");
      tips.add("• Rest well and stay hydrated");
      tips.add("• Monitor temperature regularly");
    }
    
    if (selectedSymptoms.contains('Dehydration')) {
      tips.add("• Drink water every 10-15 minutes");
      tips.add("• Use homemade ORS (1 liter water + 6 tsp sugar + 1/2 tsp salt)");
      tips.add("• Avoid caffeinated drinks");
    }
    
    if (selectedSymptoms.contains('Vomiting')) {
      tips.add("• Sip water slowly");
      tips.add("• Avoid solid food for a few hours");
      tips.add("• Rest in a comfortable position");
    }

    // Add general tips
    tips.add("• Maintain good hygiene");
    tips.add("• Wash hands frequently");
    tips.add("• Use clean water for drinking and cooking");

    return tips;
  }

  @override
  Widget build(BuildContext context) {
    String illnessGuess = _getIllnessGuess();
    List<String> tips = _getTips();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Result"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Severity Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: severity == "High" ? Colors.red[100] :
                       severity == "Medium" ? Colors.orange[100] :
                       Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    severity == "High" ? Icons.warning :
                    severity == "Medium" ? Icons.info :
                    Icons.check_circle,
                    color: severity == "High" ? Colors.red :
                           severity == "Medium" ? Colors.orange :
                           Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Severity: $severity",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "You may be experiencing symptoms similar to: $illnessGuess",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tips & Self-care Section
            const Text(
              "Tips & Self-care:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(tip),
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Request Help Button
            if (severity == "High")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/map');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Request Help",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 