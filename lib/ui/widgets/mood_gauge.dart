import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MoodGauge extends StatelessWidget {
  final double mood;

  const MoodGauge({super.key, required this.mood});

  double mapMood(double x) => ((x + 1) / 2) * 5;

  @override
  Widget build(BuildContext context) {
    final pointerValue = mapMood(mood);

    return SizedBox(
      height: 200,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 5,
            startAngle: 180,
            endAngle: 0,
            showLabels: false,
            showTicks: false,
            radiusFactor: 0.95,
            canScaleToFit: true,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 1,
                color: Colors.red,
                startWidth: 40,
                endWidth: 40,
              ),
              GaugeRange(
                startValue: 1,
                endValue: 2,
                color: Colors.orange,
                startWidth: 40,
                endWidth: 40,
              ),
              GaugeRange(
                startValue: 2,
                endValue: 3,
                color: Colors.yellow,
                startWidth: 40,
                endWidth: 40,
              ),
              GaugeRange(
                startValue: 3,
                endValue: 4,
                color: Colors.lightGreen,
                startWidth: 40,
                endWidth: 40,
              ),
              GaugeRange(
                startValue: 4,
                endValue: 5,
                color: Colors.green,
                startWidth: 40,
                endWidth: 40,
              ),
            ],

            pointers: <GaugePointer>[
              NeedlePointer(
                value: pointerValue,
                enableAnimation: true,
                animationDuration: 500,
                needleColor: Colors.black,
                needleLength: 0.75,
                needleStartWidth: 0,
                needleEndWidth: 3,
                knobStyle: const KnobStyle(
                  knobRadius: 0.05,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
