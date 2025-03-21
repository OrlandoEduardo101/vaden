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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Stack(
                  children: [
                    Center(
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
                            'VADEN Generator',
                            style: GoogleFonts.anekBangla(
                              color: VadenColors.txtSecondary,
                              fontSize: 32,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 48,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: InternationWidget(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 250),
              Center(
                child: SizedBox(
                  width: 760,
                  child: Column(
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
                      Container(
                        height: 1,
                        width: 156,
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
                      ),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 32,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              VadenButtonExtension.outlined(
                                title: 'Apoia-se',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://apoia.se/vaden',
                                  );
                                },
                                icon: null,
                                width: 360,
                                height: 80,
                                borderColor: VadenColors.stkWhite,
                              ),
                              VadenButtonExtension.outlined(
                                title: 'Generator',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://t.me/flutterando',
                                  );
                                },
                                icon: null,
                                width: 360,
                                height: 80,
                                borderColor: VadenColors.stkWhite,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              VadenButtonExtension.outlined(
                                title: 'Discord',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://discord.flutterando.com.br',
                                  );
                                },
                                icon: null,
                                width: 360,
                                height: 80,
                                borderColor: VadenColors.stkWhite,
                              ),
                              VadenButtonExtension.outlined(
                                title: 'Linkedin',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://www.linkedin.com/company/theflutterando/',
                                  );
                                },
                                icon: null,
                                width: 360,
                                height: 80,
                                borderColor: VadenColors.stkWhite,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              VadenButtonExtension.outlined(
                                title: 'Flutterando',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://www.youtube.com/@FlutterandoTV',
                                  );
                                },
                                icon: null,
                                width: 360,
                                height: 80,
                                borderColor: VadenColors.stkWhite,
                              ),
                              VadenButtonExtension.outlined(
                                title: 'Telegram',
                                onPressed: () {
                                  urlLauncherService.launch(
                                    'https://t.me/flutterando',
                                  );
                                },
                                icon: null,
                                width: 360,
                                height: 80,
                                borderColor: VadenColors.stkWhite,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 250),
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
    );
  }
}
