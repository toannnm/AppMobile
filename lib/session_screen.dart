import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late List<bool> _isExpandedList;
  List<String> _sessions = [];
  late DateTime selectedDate = DateTime.now();
  String selectedLocation =
      'Cơ sở 1: 139 Nguyễn Hữu Cảnh, P22, Quận Bình Thạnh, Tp.Hồ Chí Minh'; 

  bool _isAnyTileExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpandedList = [];
    _sessions = generateSessions(10);
    _isExpandedList = List<bool>.filled(_sessions.length, false);
  }

  List<String> generateSessions(int count) {
    List<String> sessions = [];
    for (int i = 0; i < count; i++) {
      sessions.add('Session ${i + 1}');
    }
    return sessions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _page(),
    );
  }

  Widget _page() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 50),
            _buildButtonList(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: _welcomeText(),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  Widget _welcomeText() {
    return Text(
      'Chương trình tập',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildButtonList() {
    return Column(
      children: List.generate(
        _sessions.length,
            (index) => Column(
          children: [
            _buildButtonContainer(index),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonContainer(int index) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth * 0.9,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpandedList[index] ? null : 125,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ExpansionTile(
              initiallyExpanded: _isExpandedList[index],
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        child: Text(
                          '1.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        _sessions[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.help, color: Colors.black),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Yêu cầu thay đổi lịch và địa điểm tập"),
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Lịch tập hiện tại: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: selectedDate,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (pickedDate != null && pickedDate != selectedDate) {
                                              setState(() {
                                                selectedDate = pickedDate; // Cập nhật ngày đã chọn
                                              });
                                            }
                                          },
                                          child: Text("Chọn ngày tập mới"),
                                        ),
                                        SizedBox(height: 20),
                                        Text("Chọn địa điểm tập mới"),
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: selectedLocation,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: TextStyle(color: Colors.black),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedLocation = newValue!;
                                              });
                                            },
                                            items: <String>[
                                              'Cơ sở 1: 139 Nguyễn Hữu Cảnh, P22, Quận Bình Thạnh, Tp.Hồ Chí Minh',
                                              'Cơ sở 2: 25B Nguyễn Bỉnh Khiêm, P Bến Nghé, Quận 1, Tp.Hồ Chí Minh',
                                              'Cơ sở 3: 138 Yersin và 83 Lê Thị Hồng Gấm, P Nguyễn Thái Bình, Quận 1, Tp.Hồ Chí Minh'
                                            ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool? confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Xác nhận thay đổi lịch'),
                                            content: Text('Bạn có chắc chắn muốn thay đổi lịch không?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(true),
                                                child: Text('Có'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: Text('Không'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirm == true) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Yêu cầu thành công'),
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.green),
                                                  SizedBox(width: 10),
                                                  Text('Chúng tôi đã tiếp nhận yêu cầu.'),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        Future.delayed(Duration(seconds: 1), () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    child: Text('Thay đổi'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Fullbody Workout - Trainer name',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${DateFormat('dd/MM/yyyy').format(DateTime.now())} - branchname',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              onExpansionChanged: (value) {
                setState(() {
                  _isExpandedList[index] = value;
                  if (value) {
                    _isAnyTileExpanded = true;
                  } else {
                    _isAnyTileExpanded = _isExpandedList.contains(true);
                  }
                  if (_isAnyTileExpanded) {
                    _isExpandedList = List<bool>.filled(_sessions.length, false);
                    _isExpandedList[index] = true;
                  }
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: List.generate(
                      3,
                          (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 120.0),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Session item ${index + 1}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
