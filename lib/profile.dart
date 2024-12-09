import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:swifty_companion/customWidgets/row.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onButtonPressed(int index) {
    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

final List<ChartData> chartData = [
            ChartData('Steve',  60),
            ChartData('Jack',   50),
            ChartData('Others', 80),
            ChartData('saife',  39),
            ChartData('David',  90),
            ChartData('David',  54),
            ChartData('David',  66),
        ];

    final screenSize = MediaQuery.sizeOf(context);
    const String level = '14.05';
    const String login = 'skasmi';
    const String fullName = 'saifeddine kasmi';
    const String wallet = '1400 ₳';
    const String email = 'skasmi@student.1337.ma';
    const String mobile = '+212661189840';

    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/backV2.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'mytwo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {}),
            ),
            body: Center(
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: screenSize.width * 95 / 100,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(164, 255, 255, 255),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 53,
                                backgroundColor: Color(0xFF2B8BA1),
                                child: CircleAvatar(
                                  maxRadius: 50,
                                  backgroundImage:
                                      NetworkImage('assets/images/skasmi.jpeg'),
                                ),
                              ),
                              Text(
                                login,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'mytwo',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              fullName,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: '_2',
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'wallet: $wallet',
                              style: TextStyle(
                                fontFamily: '_2',
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'email: $email',
                              style: TextStyle(
                                fontFamily: '_2',
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'mobile: $mobile',
                              style: TextStyle(
                                fontFamily: '_2',
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: screenSize.width * 60 / 100,
                              child: LinearPercentIndicator(
                                animation: true,
                                lineHeight: 18.0,
                                animationDuration: 2000,
                                percent: 0.5,
                                barRadius: const Radius.circular(3),
                                center: const Text(
                                  "Level  $level% ",
                                  style: TextStyle(
                                      fontFamily: 'mytwo',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                progressColor:
                                    const Color.fromARGB(255, 245, 189, 57),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(
                              Iconsax.d_cube_scan,
                              color: Colors.black,
                              size: 20,
                            ),
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                              Colors.amber,
                            )),
                            onPressed: () => _onButtonPressed(0),
                            label: const Text(
                              'Projects',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'mytwo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(
                              Iconsax.keyboard,
                              color: Colors.black,
                              size: 20,
                            ),
                            style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                              Colors.amber,
                            )),
                            onPressed: () => _onButtonPressed(1),
                            label: const Text(
                              'Skills',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'mytwo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                          });
                        },
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    MyRow(
                                      projectName: 'libft',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'get_next_line',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'ft_printf',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'born2beroot',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'inception',
                                      projectValue: '0%',
                                      icon: Icon(Icons.close),
                                      iconColor: Color(0xFFD8636F),
                                      textColor: Color(0xFFD8636F),
                                    ),
                                    MyRow(
                                      projectName: 'minitalk',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'so_long',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'push_swap',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'ExamRank02',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'minishell',
                                      projectValue: '101%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'philosophers',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'ExamRank03',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'cub3d',
                                      projectValue: '105%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'NetPractice',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'ExamRank04',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'CPP Module 08',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'CPP Module 09',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'webserv',
                                      projectValue: '125%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'ft_transcendence',
                                      projectValue: '100%',
                                      icon: Icon(Icons.check),
                                      iconColor: Color(0xFF5cb85c),
                                      textColor: Color(0xFF5cb85c),
                                    ),
                                    MyRow(
                                      projectName: 'swifty-companion',
                                      projectValue: 'in_progress',
                                      icon: Icon(
                                        Iconsax.timer,
                                        size: 14,
                                      ),
                                      iconColor:
                                          Color.fromARGB(255, 255, 170, 22),
                                      textColor:
                                          Color.fromARGB(255, 255, 170, 22),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(164, 255, 255, 255),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child:  Center(
                              child: SfCircularChart(
                            title: const ChartTitle(text: 'charts of skills', textStyle: TextStyle(color: Colors.black,fontFamily: 'mytwo', fontWeight: FontWeight.bold,)),    
                        series: <CircularSeries>[
                            // Renders radial bar chart
                            RadialBarSeries<ChartData, String>(
                                cornerStyle: CornerStyle.bothCurve,
                                useSeriesColor: true,
                                dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontFamily: 'mytwo', fontSize: 10)),
                                trackOpacity: 0.1,
                                gap: '4%',
                                
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                        ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}

  class ChartData {
      ChartData(this.x, this.y);
        final String x;
        final double y;
    }