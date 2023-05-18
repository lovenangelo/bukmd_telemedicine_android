import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../theme/theme.dart';
import '../../../prescription/domain/entities/appointment_response.dart';
import '../../application/firestore_doctor_appointments_controller.dart';

class CollegesPieChart extends ConsumerStatefulWidget {
  const CollegesPieChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CollegesPieChartState();
}

class _CollegesPieChartState extends ConsumerState<CollegesPieChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<ChartData> chartData(List<AppointmentResult> appointments) {
    List<ChartData> chartData = [];

    final colleges = appointments.map((e) {
      return e.college;
    }).toList();
    // log(months.toString());

    final counts = colleges.fold<Map<String, int>>({}, (map, element) {
      map[element ?? 'other'] = (map[element ?? 'other'] ?? 0) + 1;
      return map;
    });

    counts.forEach(((key, value) {
      chartData.add(ChartData(key, value.toDouble()));
    }));

    // log(counts.toString());
    // log(counts.length.toString());
    // log(chartData.toString());
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(appointmentRecordProvider(null)).when(data: (data) {
      if (data == null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [SfCircularChart(), const Text('No data')],
          ),
        );
      }
      final values = chartData(data);

      // final totalConsultations = total(data);
      return SfCircularChart(
        tooltipBehavior: _tooltipBehavior,
        legend: Legend(isVisible: true),
        title: ChartTitle(text: 'No. of student consultations per colleges'),
        backgroundColor: Colors.white,
        series: <CircularSeries>[
          // Render pie chart
          PieSeries<ChartData, String>(
            dataSource: values.isNotEmpty ? values : [ChartData('No data', 1)],
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            dataLabelSettings: DataLabelSettings(isVisible: values.isNotEmpty),
          ),
        ],
      );
    }, error: (e, st) {
      log(st.toString());
      log(e.toString());
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SfCircularChart(),
            const Text('Cannot retrieve data at the moment.')
          ],
        ),
      );
    }, loading: () {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: primaryColor,
          ),
        ],
      );
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
