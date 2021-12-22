import 'package:budget_tracker/item_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget{
  final List<Item> items;

  const SpendingChart({
    Key? key,
    required this.items
  }) :super(key:key);

  @override
  Widget build(BuildContext context){
    final spending = <String, double>{};
    for (var item in items) {
      spending.update(
        item.category,
        (value)=> value + item.price,
        ifAbsent: () => item.price,
      );
    }
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 360.0,
        child: Column(
          children: [
            Expanded(
              child: PieChart(
              PieChartData(
                sections: spending.map((category, amountSpent) => MapEntry(category,
                PieChartSectionData(
                  color: getCategoryColor(category),
                  radius: 100.0,
                  title: '${amountSpent.toStringAsFixed(2)} ₺',
                  value: amountSpent,
                ),
                ))
                .values
                .toList(),
                sectionsSpace: 0,
              ),
            ), 
            ),
            const SizedBox(height: 20.0,),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: spending.keys.map((category) => _Indicator(
                color: getCategoryColor(category),
                text: category,
              ))
              .toList(),
            )
          ],
        )
          
      ),
    );
  }

  getCategoryColor(String category) {
    switch (category) {
      case 'Entertainment':
        return Colors.red[400]!;
      case 'Bill':
        return Colors.green[400]!;
      case 'Personel':
        return Colors.blue[400]!;
      case 'Transportation':
        return Colors.purple[400]!;
      case 'Food':
        return Colors.orange[400]!;
      default:
        return Colors.brown[400]!;
    }

  }
}

class _Indicator extends StatelessWidget{
  final Color color;
  final String text;

  const _Indicator({
    Key? key,
    required this.color,
    required this.text,
  }):super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 16.0,
          width: 16.0,
          color: color,
        ),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ],
    );
  }}