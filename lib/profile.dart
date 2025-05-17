import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:swifty_companion/api/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({required this.userData, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late PageController _pageController;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  List<dynamic> _projects = [];
  List<dynamic> _skills = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    getConnectivity();
    _pageController = PageController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = widget.userData['id'];

      // Load projects and skills in parallel
      final results = await Future.wait([
        ApiService.getUserProjects(userId),
        ApiService.getUserSkills(userId),
      ]);

      setState(() {
        _projects = results[0];
        _skills = results[1];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load user data: $e';
        _isLoading = false;
      });
    }
  }

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          showDialogBox();
          setState(() {
            isAlertSet = true;
          });
        }
      },
    );
  }

  void _onButtonPressed(int index) {
    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    subscription.cancel();
    super.dispose();
  }

  double _calculateLevelPercentage() {
    if (_skills.isEmpty) {
      return 0.0;
    }

    try {
      final cursusUser = _skills.firstWhere(
        (skill) => skill['cursus']['slug'] == '42cursus',
        orElse: () => _skills.first,
      );

      final double level = cursusUser['level']?.toDouble() ?? 0.0;
      final int levelInt = level.toInt();
      final double percentage = level - levelInt;

      return percentage;
    } catch (e) {
      debugPrint('Error calculating level percentage: $e');
      return 0.0;
    }
  }

  // Get users full level example "14.05"
  String _getUserLevel() {
    if (_skills.isEmpty) {
      return '0.00';
    }

    try {
      final cursusUser = _skills.firstWhere(
        (skill) => skill['cursus']['slug'] == '42cursus',
        orElse: () => _skills.first,
      );

      // Format level to two decimal places
      final double level = cursusUser['level']?.toDouble() ?? 0.0;
      return level.toStringAsFixed(2);
    } catch (e) {
      debugPrint('Error getting user level: $e');
      return '0.00';
    }
  }

  // Get list of skills for chart
  List<ChartData> _getSkillsData() {
    if (_skills.isEmpty) {
      return [];
    }

    try {
      final cursusUser = _skills.firstWhere(
        (skill) => skill['cursus']['slug'] == '42cursus',
        orElse: () => _skills.first,
      );

      // Extract skills and create chart data
      final List<dynamic> skills = cursusUser['skills'] ?? [];

      // Sort skills by level to display higher levels first
      skills.sort((b, a) {
        final levelA = (a['level'] as num?)?.toDouble() ?? 0.0;
        final levelB = (b['level'] as num?)?.toDouble() ?? 0.0;
        return levelB.compareTo(levelA);
      });

      return skills
          .map((skill) => ChartData(
                skill['name']?.toString() ?? 'Unknown',
                (skill['level'] as num?)?.toDouble() ?? 0.0,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting skills data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    // Extract user data
    final String displayName = widget.userData['displayname'] ?? 'Unknown User';
    final String login = widget.userData['login'] ?? '';
    final String email = widget.userData['email'] ?? 'No email';
    final String wallet = '${widget.userData['wallet']} ₳';
    final String imageUrl = widget.userData['image']['link'] ?? '';

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backV2.png"),
          fit: BoxFit.cover,
        ),
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
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF7941D),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Error loading data',
                            style: TextStyle(
                              color: Color.fromARGB(255, 232, 0, 0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_error!),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadUserData,
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
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
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 53,
                                    backgroundColor: const Color(0xFF2B8BA1),
                                    child: CircleAvatar(
                                      maxRadius: 50,
                                      backgroundImage: imageUrl.isNotEmpty
                                          ? NetworkImage(imageUrl)
                                          : null,
                                      child: imageUrl.isEmpty
                                          ? Text(login.isNotEmpty
                                              ? login[0].toUpperCase()
                                              : 'U')
                                          : null,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  // Wrap in Expanded
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0, right: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          displayName.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontFamily: 'mytwo',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'wallet : $wallet',
                                          style: const TextStyle(
                                            fontFamily: 'mytwo',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        // Email with Tooltip for longer emails
                                        Tooltip(
                                          message: email,
                                          child: Text(
                                            'email : $email',
                                            style: const TextStyle(
                                              fontFamily: 'mytwo',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        LinearPercentIndicator(
                                          width: screenSize.width * 60 / 100,
                                          animation: true,
                                          lineHeight: 18.0,
                                          animationDuration: 2000,
                                          percent: _calculateLevelPercentage(),
                                          barRadius: const Radius.circular(3),
                                          center: Text(
                                            "Level  ${_getUserLevel()} ",
                                            style: const TextStyle(
                                                fontFamily: 'mytwo',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          progressColor: const Color.fromARGB(
                                              255, 245, 189, 57),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                  setState(() {});
                                },
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: _projects.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'No projects found',
                                              style: TextStyle(
                                                fontFamily: 'mytwo',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children:
                                                    _projects.map((project) {
                                                  final projectName =
                                                      project['project']
                                                              ['name'] ??
                                                          'Unknown Project';
                                                  final finalMark =
                                                      project['final_mark']
                                                              ?.toString() ??
                                                          '-';
                                                  final status =
                                                      project['status'] ??
                                                          'unknown';
                                                  final validated =
                                                      project['validated?'] ??
                                                          false;

                                                  Icon statusIcon;
                                                  Color statusColor;
                                                  String displayMark;

                                                  if (status == 'finished') {
                                                    if (validated) {
                                                      statusIcon = const Icon(
                                                          Icons.check);
                                                      statusColor = const Color(
                                                          0xFF5cb85c);
                                                      displayMark =
                                                          '$finalMark%';
                                                    } else {
                                                      statusIcon = const Icon(
                                                          Icons.close);
                                                      statusColor = const Color(
                                                          0xFFD8636F);
                                                      displayMark =
                                                          '$finalMark%';
                                                    }
                                                  } else if (status ==
                                                      'in_progress') {
                                                    statusIcon = const Icon(
                                                        Iconsax.timer,
                                                        size: 14);
                                                    statusColor =
                                                        const Color.fromARGB(
                                                            255, 255, 170, 22);
                                                    displayMark = 'in_progress';
                                                  } else {
                                                    statusIcon = const Icon(
                                                        Icons.help_outline);
                                                    statusColor = Colors.grey;
                                                    displayMark = status;
                                                  }

                                                  return MyRow(
                                                    projectName: projectName,
                                                    projectValue: displayMark,
                                                    icon: statusIcon,
                                                    iconColor: statusColor,
                                                    textColor: statusColor,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: _getSkillsData().isEmpty
                                          ? const Center(
                                              child: Text(
                                                'No skills data available',
                                                style: TextStyle(
                                                  fontFamily: 'mytwo',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Skills Overview',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'mytwo',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SfCartesianChart(
                                                    primaryXAxis:
                                                        const CategoryAxis(
                                                      labelStyle: TextStyle(
                                                        fontFamily: 'mytwo',
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      labelRotation: 0,
                                                      labelAlignment:
                                                          LabelAlignment.center,
                                                      labelPosition:
                                                          ChartDataLabelPosition
                                                              .outside,
                                                      maximumLabels: 10,
                                                    ),
                                                    primaryYAxis:
                                                        const NumericAxis(
                                                      labelStyle: TextStyle(
                                                        fontFamily: 'mytwo',
                                                        fontSize: 10,
                                                      ),
                                                      title: AxisTitle(
                                                        text: 'Level',
                                                        textStyle: TextStyle(
                                                          fontFamily: 'mytwo',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    series: <CartesianSeries<
                                                        ChartData, String>>[
                                                      BarSeries<ChartData,
                                                          String>(
                                                        dataSource:
                                                            _getSkillsData(),
                                                        xValueMapper: (ChartData data,  _) => data.x,
                                                        yValueMapper: (ChartData data, _) => data.y, name: 'Skills',
                                                        color: const Color(
                                                            0xFFF7941D),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        dataLabelSettings:
                                                            const DataLabelSettings(
                                                          isVisible: true,
                                                          labelAlignment:
                                                              ChartDataLabelAlignment
                                                                  .top,
                                                          textStyle: TextStyle(
                                                            fontFamily: 'mytwo',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
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
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  void showDialogBox() {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          'No Connection',
          style: TextStyle(fontFamily: 'mytwo'),
        ),
        content: const Text('Please check your internet connectivity'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Ok');
              setState(() {
                isAlertSet = false;
              });
            },
            child: const Text(
              'Ok',
              style: TextStyle(fontFamily: 'mytwo'),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

// Modified MyRow widget to prevent text overflow
class MyRow extends StatelessWidget {
  final String projectName;
  final String projectValue;
  final Icon icon;
  final Color iconColor;
  final Color textColor;

  const MyRow({
    super.key,
    required this.projectName,
    required this.projectValue,
    required this.icon,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey.shade300),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // Project name with expansion and tooltip for long names
            Expanded(
              flex: 7, // Give more space to project name
              child: Tooltip(
                message: projectName, // Show full name on long press
                child: Text(
                  projectName,
                  style: const TextStyle(
                    fontFamily: 'mytwo',
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Score/status with icon
            Expanded(
              flex: 3, // Less space for score
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      projectValue,
                      style: TextStyle(
                        fontFamily: 'mytwo',
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconTheme(
                    data: IconThemeData(
                      color: iconColor,
                      size: 18,
                    ),
                    child: icon,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
