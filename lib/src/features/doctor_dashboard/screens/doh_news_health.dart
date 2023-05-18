import 'package:bukmd_telemedicine/src/features/doctor_dashboard/application/news_health/news_health_provider.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/infrastructure/service/firestore_news_health.dart';
import 'package:bukmd_telemedicine/src/features/news_health_updates/models/philippines_news_model.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/error_page.dart';
import 'package:bukmd_telemedicine/src/shared/presentation/no_record.dart';
import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:bukmd_telemedicine/src/widgets/divider.dart';
import 'package:bukmd_telemedicine/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/loading_screen.dart';

final _newsHealthFirestore = NewsHealthFirestore();

class DohNewsHealth extends ConsumerStatefulWidget {
  const DohNewsHealth({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DohNewsHealthState();
}

class _DohNewsHealthState extends ConsumerState<DohNewsHealth> {
  final titleTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final urlTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  @override
  Widget build(BuildContext context) {
    final news = ref.watch(newsHealthProvider);
    return news.when(
        data: (data) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isForUpdate = false;
                  });
                  showDialog(
                      context: context,
                      builder: (context) {
                        return addOrUpdate(NewsApi());
                      });
                },
                backgroundColor: primaryColor,
                child: const Icon(Icons.add),
              ),
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return deleteAll();
                          });
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  'MANAGE NEWS HEALTH',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: primaryColor,
              ),
              body: data.isEmpty
                  ? noRecord()
                  : Scrollbar(
                      child: ListView.separated(
                        itemCount: data.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            horizontalDivider,
                        itemBuilder: (BuildContext context, int index) {
                          return listTile(index, data, context);
                        },
                      ),
                    ));
        },
        error: (e, st) {
          print(e);
          return const ErrorPage(isNoInternetError: false);
        },
        loading: () => const LoadingScreen());
  }

  listTile(int index, List<NewsApi> news, BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return updateDeleteDialog(
                      news[index].id!, context, news[index]);
                });
          },
          onTap: () => launchNewsUrl(news[index].url!),
          title: Text(
            news[index].title!,
            style: const TextStyle(color: Colors.green),
          ),
          subtitle: Text(news[index].date!),
        ),
      );

  deleteAll() {
    return AlertDialog(
      title: Text(
        'Delete all news?',
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'CANCEL',
            style: TextStyle(color: primaryColor),
          ),
        ),
        TextButton(
          onPressed: () {
            _newsHealthFirestore.deleteAllNewsHealth();
            Navigator.pop(context);
          },
          child: const Text(
            'YES',
            style: TextStyle(color: Colors.redAccent),
          ),
        )
      ],
    );
  }

  addOrUpdate(NewsApi data) {
    titleTextController.text = data.title ?? '';
    dateTextController.text = data.date ?? '';
    urlTextController.text = data.url ?? '';
    return AlertDialog(
      scrollable: true,
      actions: [
        Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLines: 3,
                    controller: titleTextController,
                    keyboardType: TextInputType.name,
                    cursorColor: primaryColor,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: isEmptyValidator,
                  ),
                  TextFormField(
                    controller: dateTextController,
                    keyboardType: TextInputType.name,
                    cursorColor: primaryColor,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: isEmptyValidator,
                  ),
                  TextFormField(
                    controller: urlTextController,
                    keyboardType: TextInputType.name,
                    cursorColor: primaryColor,
                    decoration: const InputDecoration(
                      labelText: 'Url',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(),
                    ),
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: isEmptyValidator,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final news = NewsApi(
                      date: dateTextController.text,
                      title: titleTextController.text,
                      url: urlTextController.text,
                      id: data.id);
                  isForUpdate
                      ? await _newsHealthFirestore.updateNews(news)
                      : await _newsHealthFirestore.addNews(news);
                  if (!mounted) return;
                  Navigator.pop(context);
                  snackBar(context, 'Succesfuly added!', Colors.green);
                  dateTextController.text = '';
                  titleTextController.text = '';
                  urlTextController.text = '';
                }
              },
              child: Text(
                isForUpdate ? 'Update' : 'Add',
                style: const TextStyle(color: Colors.white),
              ))
        ]),
      ],
    );
  }

  updateDeleteDialog(String id, BuildContext context, NewsApi data) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              isForUpdate = true;
            });
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) {
                  return addOrUpdate(data);
                });
          },
          child: const Text(
            'UPDATE',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () {
            _newsHealthFirestore.deleteNewsHealth(id);
            Navigator.pop(context);
          },
          child: const Text(
            'DELETE',
            style: TextStyle(color: Colors.redAccent),
          ),
        )
      ],
    );
  }
}

String? isEmptyValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "Don't leave this field empty";
  }
  return null;
}

Future<void> launchNewsUrl(String urlNews) async {
  final Uri url = Uri.parse(urlNews);

  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
