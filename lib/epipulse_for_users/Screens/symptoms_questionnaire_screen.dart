import 'package:flutter/material.dart';
import 'symptom_result_screen.dart';

class SymptomsQuestionnaireScreen extends StatefulWidget {
  const SymptomsQuestionnaireScreen({Key? key}) : super(key: key);

  @override
  State<SymptomsQuestionnaireScreen> createState() => _SymptomsQuestionnaireScreenState();
}

class _SymptomsQuestionnaireScreenState extends State<SymptomsQuestionnaireScreen> {
  final Map<String, bool> symptoms = {
    'Diarrhea': false,
    'Abdominal pain': false,
    'Nausea': false,
    'Headache': false,
    'Fever': false,
    'Vomiting': false,
    'Dehydration': false,
    'Dizziness': false,
    'Frequent urination': false,
    'Dark-colored urine': false,
  };

  double duration = 1;
  double intensity = 1;
  int familyAffected = 0;

  void calculateSeverityAndNavigate() {
    int symptomCount = symptoms.values.where((v) => v).length;
    List<String> selectedSymptoms = symptoms.entries.where((e) => e.value).map((e) => e.key).toList();
    
    // Critical symptoms that increase severity
    Set<String> criticalSymptoms = {'Fever', 'Vomiting', 'Dehydration'};
    bool hasCriticalSymptom = selectedSymptoms.any((s) => criticalSymptoms.contains(s));
    
    String severity;
    if (symptomCount >= 5 || hasCriticalSymptom) {
      severity = "High";
    } else if (symptomCount >= 3) {
      severity = "Medium";
    } else {
      severity = "Low";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SymptomResultScreen(
          severity: severity,
          selectedSymptoms: selectedSymptoms,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Symptom Checker"), backgroundColor: Colors.teal[700]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("I'm Feeling Unwell"),
            ),
            const SizedBox(height: 16),
            const Text("Select Symptoms:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: symptoms.keys.map((symptom) {
                IconData iconData;
                switch (symptom) {
                  case 'Fever': iconData = Icons.thermostat; break;
                  case 'Diarrhea': iconData = Icons.wc; break;
                  case 'Abdominal pain': iconData = Icons.sick; break;
                  case 'Nausea': iconData = Icons.sick; break;
                  case 'Headache': iconData = Icons.sick; break;
                  case 'Vomiting': iconData = Icons.sick; break;
                  case 'Dehydration': iconData = Icons.water_drop; break;
                  case 'Dizziness': iconData = Icons.rotate_right; break;
                  case 'Frequent urination': iconData = Icons.wc; break;
                  case 'Dark-colored urine': iconData = Icons.water_drop; break;
                  default: iconData = Icons.medical_services;
                }
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(iconData, size: 18), const SizedBox(width: 4), Text(symptom)],
                  ),
                  selected: symptoms[symptom]!,
                  onSelected: (selected) {
                    setState(() {
                      symptoms[symptom] = selected;
                    });
                  },
                  selectedColor: Colors.teal[200],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text("Duration (in days): ${duration.toInt()}"),
            Slider(
              value: duration,
              min: 1,
              max: 10,
              divisions: 9,
              label: duration.round().toString(),
              onChanged: (value) => setState(() => duration = value),
            ),
            Text("Intensity: ${intensity.toInt()} / 10"),
            Slider(
              value: intensity,
              min: 1,
              max: 10,
              divisions: 9,
              label: intensity.round().toString(),
              onChanged: (value) => setState(() => intensity = value),
            ),
            const Text("Family Members Affected:"),
            Row(
              children: [
                IconButton(onPressed: () => setState(() { if (familyAffected > 0) familyAffected--; }), icon: const Icon(Icons.remove)),
                Text('$familyAffected'),
                IconButton(onPressed: () => setState(() => familyAffected++), icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: calculateSeverityAndNavigate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
} 