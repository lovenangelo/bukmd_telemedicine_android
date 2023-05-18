import 'dart:async';

import 'package:bukmd_telemedicine/src/features/news_health_updates/application/buksu_announcements_state.dart';
import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/no_record.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/loading_screen.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/domain/buksu_announcements/buksu_announcements_model.dart';
import '../application/news_health.dart';

class NewsHealthScreen extends ConsumerStatefulWidget {
  const NewsHealthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewsHealthScreenState();
}

class _NewsHealthScreenState extends ConsumerState<NewsHealthScreen> {
  Future<void> launchNewsUrl(String urlNews) async {
    final Uri url = Uri.parse(urlNews);

    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      snackBar(context, 'Could not launch url', primaryColor,
          const Icon(Icons.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    BuksuAnnouncements? buksuAnnouncement;
    final showBuksuAnnouncement = ref.watch(showBuksuAnnouncementProvider);
    return ref.watch(newsProvider).when(data: (data) {
      if (data?.bukSuAnnouncementsApi != null && showBuksuAnnouncement) {
        buksuAnnouncement =
            BuksuAnnouncements.fromJson(data!.bukSuAnnouncementsApi!);
        Future(() async {
          showBuksuAnnouncementDialog(context, buksuAnnouncement!);
          ref.read(showBuksuAnnouncementProvider.notifier).setFalse();
        });
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              const Text('News Health', style: TextStyle(color: Colors.white)),
          backgroundColor: primaryColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: primaryColor,
                onRefresh: () async {
                  ref.read(showBuksuAnnouncementProvider.notifier).setFalse();
                  ref.invalidate(newsProvider);
                },
                child: Scrollbar(
                  child: Column(
                    children: [
                      FittedBox(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration:
                              const BoxDecoration(color: Colors.yellowAccent),
                          child: const Text(
                            "These news are retrieved from the Department of Health's latest press release.",
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount:
                              data!.newsApi.isEmpty ? 1 : data.newsApi.length,
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemBuilder: ((context, index) {
                            return data.newsApi.isEmpty
                                ? Center(child: noRecord())
                                : philippinesNewsBuildCard(index, data.newsApi);
                          }),
                          separatorBuilder: (context, index) {
                            return horizontalDivider;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }, error: (e, st) {
      return const ErrorPage(isNoInternetError: false);
    }, loading: () {
      return const LoadingScreen();
    });
  }

  philippinesNewsBuildCard(int index, List<NewsApi> news) {
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Material(
              elevation: 3,
              child: SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      GestureDetector(
                        onTap: () async {
                          return launchNewsUrl(news[index].url!);
                        },
                        child: Linkify(
                          text: news[index].title!,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.green),
                          linkStyle: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(news[index].date!,
                              style: const TextStyle(
                                color: Colors.grey,
                              )),
                        ],
                      )
                    ]),
              ))
        ]));
  }

  void showBuksuAnnouncementDialog(
      BuildContext context, BuksuAnnouncements buksuAnnouncement) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              'BukSU Medical Clinic Announcement',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            )),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  horizontalDivider,
                  Center(
                    child: Text(
                      buksuAnnouncement.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date: ${buksuAnnouncement.date}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Location: ${buksuAnnouncement.location}',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Additional information:',
                  ),
                  Text(
                    buksuAnnouncement.description,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'okay',
                    style: TextStyle(color: primaryColor),
                  )),
            ],
          );
        });
  }
}
