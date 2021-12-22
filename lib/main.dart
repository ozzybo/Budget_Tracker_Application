import 'package:budget_tracker/budget_repository.dart';
import 'package:budget_tracker/failure_model.dart';
import 'package:budget_tracker/item_model.dart';
import 'package:budget_tracker/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where is My Money - Lightning Software',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BudgetScreen(),
    );
  }
}

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;
  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepository().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.code,
            color: Colors.white,),
           onPressed: (){
             _showMyDialog();
           },
           )
          ],
        title: const Text('Where is My Money ?', textAlign: TextAlign.center,),
      
      ),
      body: RefreshIndicator(onRefresh: () async{

        _futureItems  = BudgetRepository().getItems();
        setState(() {
          
        });

      },
      child: FutureBuilder<List<Item>>(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final items = snapshot.data!;
            return ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) return SpendingChart(items: items);
                  final item = items[index - 1];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 2.0,
                          color: getCategoryColor(item.category),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0)
                        ]),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                          '${item.category} - ${DateFormat.yMd().format(item.date)}'),
                          trailing: Text('- ${item.price.toStringAsFixed(2)} ₺'),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            return Center(child: Text(failure.message));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),) 
      
    );
  }

  getCategoryColor(String category) {
    switch (category) {
      case 'Entertainment':
        return Colors.blue[400]!;
      case 'Bill':
        return Colors.red[400]!;
      case 'Personel':
        return Colors.pink[400]!;
      case 'Transportation':
        return Colors.purple[400]!;
      case 'Food':
        return Colors.orange[400]!;
      default:
        return Colors.brown[400]!;
    }
  }
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('WMM App',textAlign: TextAlign.center,),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Where is my money application is designed for you to keep track of the money you spend.', textAlign: TextAlign.center,),
              Text('\nCoded by Ozzy',textAlign: TextAlign.center,)
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Kapat',textAlign: TextAlign.center,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
