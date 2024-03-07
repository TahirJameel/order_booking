import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
          child: Column(
            children: [
              Image.asset('assets/images/soft-touch_black.png', scale: 2),
              const SizedBox(height: 50),
              Text(
                'SoftTouch Technologies has been delivering top notch software solutions and it services to our clients for more than 20 years we offer our services in multiple countries around the world.',
                style: GoogleFonts.exo(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SoftTouch Website Link
                  CupertinoButton(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Icon(Iconsax.global_search),
                      const SizedBox(width: 10),
                      Text('Website', style: GoogleFonts.exo()),
                    ]),
                    onPressed: () {},
                  ),

                  // SoftTouch Gmail Link
                  CupertinoButton(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Icon(Iconsax.direct),
                      const SizedBox(width: 10),
                      Text('Gmail', style: GoogleFonts.exo()),
                    ]),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Whatsapp Icon
                  CupertinoButton(
                    color: Colors.green,
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/icons/whatsapp.png',
                      scale: 90,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),

                  // Facebook Icon
                  CupertinoButton(
                    color: Colors.lightBlue,
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/icons/facebook.png',
                      scale: 90,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),

                  // Youtube Icon
                  CupertinoButton(
                    color: Colors.red[400],
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/icons/youtube.png',
                      scale: 90,
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),

                  // LinkedIn Icon
                  CupertinoButton(
                    color: Colors.blue,
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/icons/linkedin.png',
                      scale: 90,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
