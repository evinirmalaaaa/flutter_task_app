import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_app/config.dart';
import 'package:flutter_task_app/pages/home_screen.dart';
import 'package:intl/intl.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(2, 2),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(spacing: 5, children: [
              Badge(
                backgroundColor: Colors.deepPurple.withOpacity(0.3),
                textColor: Colors.deepPurple,
                padding: const EdgeInsets.all(10),
                label: Text(
                  'UI/UX Design',
                  style: font,
                ),
              ),
              Badge(
                backgroundColor: Colors.red.withOpacity(0.3),
                textColor: Colors.red,
                padding: const EdgeInsets.all(10),
                label: Text(
                  'High',
                  style: font,
                ),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Create a\nLanding Page',
              style: font.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: Stack(
                children: [
                  const Positioned(
                      left: 0,
                      child: MemberImage(
                        size: 40,
                      )),
                  const Positioned(
                      left: 22,
                      child: MemberImage(
                        size: 40,
                      )),
                  Positioned(
                      left: 44,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Colors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Text(
                            '+2',
                            style: font.copyWith(
                                fontSize: 16, color: Colors.white),
                          )),
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/images/bottom_navbar/calendar.svg'),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  DateFormat('E, d MMM y').format(DateTime.now()),
                  style: font.copyWith(color: Colors.black38),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
