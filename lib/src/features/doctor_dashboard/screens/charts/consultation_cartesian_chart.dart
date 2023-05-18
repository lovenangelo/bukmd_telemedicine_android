import 'dart:developer';

import 'package:bukmd_telemedicine/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../prescription/domain/entities/appointment_response.dart';
import '../../application/firestore_doctor_appointments_controller.dart';

class ConsultationCartesianChart extends ConsumerStatefulWidget {
  const ConsultationCartesianChart({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConsultationCartesianChartState();
}

class _ConsultationCartesianChartState
    extends ConsumerState<ConsultationCartesianChart> {
  late TooltipBehavior _tooltipBehavior;

  String dropDownValue = DateFormat('y').format(DateTime.now());

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<ChartData> chartData(List<AppointmentResult> appointments) {
    List<ChartData> chartData = [
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
      ChartData(null, null),
    ];
    List<String> monthList = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    List months = appointments
        .where((e) => DateFormat('y').format(e.date!) == dropDownValue)
        .map((e) => DateFormat('MMMM').format(e.date!))
        .toList();

    if (months.every((element) => element == null)) {
      months = [];
    }

    final counts = months.fold<Map<String, int>>({}, (map, element) {
      map[element.substring(0, 3)] = (map[element.substring(0, 3)] ?? 0) + 1;
      return map;
    });

    for (String month in monthList) {
      int index = monthList.indexOf(month);
      // log(month.substring(0, 3).toString());
      if (!counts.containsKey(month.substring(0, 3))) {
        chartData.insert(index, ChartData(month.substring(0, 3), 0));
      } else {
        counts.forEach(((key, value) {
          if (key == month.substring(0, 3)) {
            chartData.insert(index, ChartData(key, value.toDouble()));
          }
        }));
      }
    }
    return chartData;
  }

  int total(List<AppointmentResult> appointments) {
    int total = 0;
    List months = appointments
        .where((e) => DateFormat('y').format(e.date!) == dropDownValue)
        .map((e) => DateFormat('MMMM').format(e.date!))
        .toList();

    // log(months.toString());

    if (months.every((element) => element == null)) {
      months = [];
    }

    final counts = months.fold<Map<String, int>>({}, (map, element) {
      map[element!.substring(0, 3)] = (map[element.substring(0, 3)] ?? 0) + 1;
      return map;
    });

    counts.forEach(((key, value) {
      total += value;
    }));

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(appointmentRecordProvider(null)).when(data: (data) {
      if (data == null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [SfCartesianChart(), const Text('No data')],
          ),
        );
      }

      final values = chartData(data);
      final totalConsultations = total(data);
      return Column(
        children: [
          Center(
            child: SfCartesianChart(
                annotations: <CartesianChartAnnotation>[
                  CartesianChartAnnotation(
                      widget: Text('Total: $totalConsultations'),
                      // Coordinate unit type
                      coordinateUnit: CoordinateUnit.logicalPixel,
                      x: 300,
                      y: 200)
                ],
                backgroundColor: Colors.white,
                title: ChartTitle(
                    text: 'No. of consultations per month in $dropDownValue'),
                // legend: Legend(isVisible: true, position: LegendPosition.bottom),
                // Enables the tooltip for all the series in chart
                tooltipBehavior: _tooltipBehavior,
                // Initialize category axis
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  // Initialize line series
                  LineSeries<ChartData, String>(
                    // Enables the tooltip for individual series
                    enableTooltip: true,
                    dataSource: values,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Year: ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              DropdownButton(
                value: dropDownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: const [
                  DropdownMenuItem(value: '2022', child: Text('2022')),
                  DropdownMenuItem(value: '2023', child: Text('2023'))
                ],
                onChanged: (String? value) {
                  setState(() {
                    dropDownValue = value!;
                  });
                },
              ),
            ],
          ),
        ],
      );
    }, error: (st, e) {
      log(st.toString());
      log(e.toString());
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SfCartesianChart(),
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
  ChartData(this.x, this.y);
  String? x;
  double? y;
}
