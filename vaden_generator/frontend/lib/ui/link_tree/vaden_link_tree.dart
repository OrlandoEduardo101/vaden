import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/localization.dart';

import '../../data/services/url_launcher_service.dart';
import '../core/ui/ui.dart';
import '../widgets/internation/internation_widget.dart';

class VadenLinkTree extends StatefulWidget {
  const VadenLinkTree({super.key});

  @override
  State<VadenLinkTree> createState() => _VadenLinkTreeState();
}

class _VadenLinkTreeState extends State<VadenLinkTree> {
  final urlLauncherService = UrlLauncherService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Localizations.localeOf(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            VadenColors.blackGradientStart,
            VadenColors.blackGradientEnd,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 48,
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              VadenImage.vadenLogo,
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'VADEN',
                              style: GoogleFonts.anekBangla(
                                color: VadenColors.txtSecondary,
                                fontSize: 32,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (size.width > 760) ...[
                        Positioned(
                          right: 48,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: InternationWidget(),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 760),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 32,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Our_channels'.i18n(),
                                style: GoogleFonts.anekBangla(
                                  color: VadenColors.txtSecondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final textSpan = TextSpan(
                                    text: 'Our_channels'.i18n(),
                                    style: GoogleFonts.anekBangla(
                                      color: VadenColors.txtSecondary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  );
                                  final textPainter = TextPainter(
                                    text: textSpan,
                                    textDirection: TextDirection.ltr,
                                  )..layout();
                                  return Container(
                                    height: 1,
                                    width: textPainter.width,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          VadenColors.gradientStart,
                                          VadenColors.gradientEnd,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Wrap(
                            spacing: 32,
                            runSpacing: 32,
                            children: [
                              VadenButton(
                                style: VadenButtonStyle.outlinedWhite,
                                label: 'Apoia-se',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://apoia.se/vaden',
                                  );
                                },
                                width: 360,
                                height: 80,
                              ),
                              VadenButton(
                                style: VadenButtonStyle.outlinedWhite,
                                label: 'Generator',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://start.vaden.dev/',
                                  );
                                },
                                width: 360,
                                height: 80,
                              ),
                              VadenButton(
                                style: VadenButtonStyle.outlinedWhite,
                                label: 'Discord',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://discord.vaden.dev',
                                  );
                                },
                                width: 360,
                                height: 80,
                              ),
                              VadenButton(
                                style: VadenButtonStyle.outlinedWhite,
                                label: 'Linkedin',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://www.linkedin.com/company/vaden1/',
                                  );
                                },
                                width: 360,
                                height: 80,
                              ),
                              VadenButton(
                                style: VadenButtonStyle.outlinedWhite,
                                label: 'GitHub',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://github.com/Flutterando/vaden',
                                  );
                                },
                                width: 360,
                                height: 80,
                              ),
                              VadenButton(
                                style: VadenButtonStyle.outlinedWhite,
                                label: 'Documentation',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://doc.vaden.dev',
                                  );
                                },
                                width: 360,
                                height: 80,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${'Community_made'.i18n()}  ',
                            style: GoogleFonts.anekBangla(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: VadenColors.secondaryColor,
                            ),
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              VadenImage.flutterandoLogo,
                              width: 120,
                              height: 24,
                            ),
                            onTap: () {
                              context.go('/linktree');
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${'Copyright'.i18n()} ',
                            style: GoogleFonts.anekBangla(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: VadenColors.txtSupport2,
                            ),
                          ),
                          SvgPicture.asset(
                            VadenImage.copyrightIcon,
                            width: 120,
                            height: 24,
                          ),
                          Text(
                            ' 2025',
                            style: GoogleFonts.anekBangla(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: VadenColors.txtSupport2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
