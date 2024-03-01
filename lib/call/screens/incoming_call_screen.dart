import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedoc/call/repository/call_repository.dart';
import 'package:emedoc/call/screens/call_screen.dart';
import 'package:emedoc/models/emergency_model.dart';
import 'package:emedoc/utils/colors.dart';
import 'package:flutter/material.dart';

class IncomingCallScreen extends StatelessWidget {
  final Widget widget;
  final String hospitalUid;
  const IncomingCallScreen({
    super.key,
    required this.widget,
    required this.hospitalUid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: callStream(hospitalUid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          EmergencyModel emergency = EmergencyModel.fromMap(
              snapshot.data!.data() as Map<String, dynamic>);

          if (emergency.callId != 'Not Yet Provided') {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call From Hospital',
                      style: TextStyle(
                        fontSize: 30,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Text(
                    //   call.callerName,
                    //   style: const TextStyle(
                    //     fontSize: 25,
                    //     color: textColor,
                    //     fontWeight: FontWeight.w900,
                    //   ),
                    // ),
                    // const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  channelId: emergency.callId,
                                  hospitalUid: hospitalUid,
                                  patientUid: emergency.patientUid,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return widget;
      },
    );
  }
}
