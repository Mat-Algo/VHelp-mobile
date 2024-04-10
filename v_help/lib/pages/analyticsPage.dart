import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StudentMessMealPreferencesPage extends StatelessWidget {
  const StudentMessMealPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Mess and Meal Preferences',
      home: DashboardPage(),
    );
  }
}



class Student {
  String mess;
  String messtype;
  String name;
  String regno;

  Student({required this.mess, required this.messtype, required this.name, required this.regno});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      mess: json['mess'],
      messtype: json['messtype'],
      name: json['name'],
      regno: json['regno'],
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Student> students;

  @override
  void initState() {
    super.initState();
    students = _loadStudents();
  }

  List<Student> _loadStudents() {
    final rawData = [
  { "mess":"srrc",
    "messtype":"Veg",
    "name": "Daniel Wood",
    "regno": "21BCE0084"
  },
  {
    "mess": "srrc",
    "messtype": "Non Veg",
    "name": "Luna Ward",
    "regno": "21BCE0085"
  },
  {
    "mess": "srrc",
    "messtype": "Special",
    "name": "Sophia Baker",
    "regno": "21BCE0086"
  },
  {
    "mess": "zenith",
    "messtype": "Veg",
    "name": "William Martinez",
    "regno": "21BCE0087"
  },
  {
    "mess": "srrc",
    "messtype": "Non Veg",
    "name": "Ava Taylor",
    "regno": "21BCE0088"
  },
  {
    "mess": "zenith",
    "messtype": "Veg",
    "name": "Liam Nelson",
    "regno": "21BCE0089"
  },
  {
    "mess": "srrc",
    "messtype": "Non Veg",
    "name": "Mia Peterson",
    "regno": "21BCE0090"
  },
  {
    "mess": "zenith",
    "messtype": "Veg",
    "name": "Benjamin Cooper",
    "regno": "21BCE0091"
  },
  {
    "mess": "srrc",
    "messtype": "Non Veg",
    "name": "Evelyn Wright",
    "regno": "21BCE0092"
  },
  {
    "mess": "zenith",
    "messtype": "Special",
    "name": "Logan Hill",
    "regno": "21BCE0093"
  },
  {
    "mess": "srrc",
    "messtype": "Veg",
    "name": "Chloe Brooks",
    "regno": "21BCE0094"
  }
];

    return rawData.map((json) => Student.fromJson(json)).toList();
  }

  Map<String, int> getMessDistribution() {
    Map<String, int> messDistribution = {};
    for (var student in students) {
      messDistribution[student.mess] = (messDistribution[student.mess] ?? 0) + 1;
    }
    return messDistribution;
  }

  Map<String, int> getMealTypeDistribution() {
    Map<String, int> mealTypeDistribution = {};
    for (var student in students) {
      mealTypeDistribution[student.messtype] = (mealTypeDistribution[student.messtype] ?? 0) + 1;
    }
    return mealTypeDistribution;
  }

  AxisTitles getAxisTitles(List<String> labels) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (double value, TitleMeta meta) {
          final index = value.toInt();
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 8.0,
            child: Text(index >= 0 && index < labels.length ? labels[index] : ''),
          );
        },
        reservedSize: 40,
      ),
    );
  }

  List<BarChartGroupData> getChartData(List<String> labels, Map<String, int> distribution) {
    List<BarChartGroupData> chartData = [];
    int barIndex = 0;
    distribution.forEach((key, value) {
      labels.add(key);
      chartData.add(
        BarChartGroupData(
          x: barIndex++,
          barRods: [
            BarChartRodData(
              toY: value.toDouble(),
              color: barIndex % 2 == 0 ? Colors.lightBlueAccent : Colors.orangeAccent,
            )
          ],
        ),
      );
    });
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    List<String> messLabels = [];
    List<String> mealTypeLabels = [];
    var messChartData = getChartData(messLabels, getMessDistribution());
    var mealTypeChartData = getChartData(mealTypeLabels, getMealTypeDistribution());

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Mess and Meal Preferences'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Mess Distribution', style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250.0,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: getAxisTitles(messLabels),
                      leftTitles: getAxisTitles(List.generate(10, (index) => index.toString())), // Example Y-axis labels
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: messChartData,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Meal Type Distribution', style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250.0,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: getAxisTitles(mealTypeLabels),
                      leftTitles: getAxisTitles(List.generate(10, (index) => index.toString())), // Example Y-axis labels
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: mealTypeChartData,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}