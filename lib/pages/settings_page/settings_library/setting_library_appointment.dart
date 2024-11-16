import 'package:ecjtu_helper/pages/settings_page/settings_library/setting_library_default_seat.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/library_json_util.dart';
import '../../../utils/shared_preferences_util.dart';

class SettingLibraryAppointmentPage extends StatefulWidget {
  const SettingLibraryAppointmentPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingLibraryAppointmentPageState();
  }
}

class _SettingLibraryAppointmentPageState
    extends State<SettingLibraryAppointmentPage> {
  String _defaultSeat = "";
  String _labName = "", _roomName = "", _devName = "";
  int _dateSelected = 3;

  bool _enableTime1 = false;
  TimeOfDay _startTime1 = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime1 = const TimeOfDay(hour: 22, minute: 0);

  bool _enableTime2 = false;
  TimeOfDay _startTime2 = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime2 = const TimeOfDay(hour: 22, minute: 0);

  bool _enableTime3 = false;
  TimeOfDay _startTime3 = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime3 = const TimeOfDay(hour: 22, minute: 0);

  @override
  void initState() {
    super.initState();
    readStringData("library_default_room_dev_id").then((defaultSeat) {
      setState(() {
        _defaultSeat = defaultSeat!;
      });
      getDetailInformation(_defaultSeat).then((value) {
        setState(() {
          _labName = value.$1;
          _roomName = value.$2;
          _devName = value.$3;
        });
      });
    });

    readIntData("library_default_appointment_date").then((defaultDate) {
      if (defaultDate != null) {
        setState(() {
          _dateSelected = defaultDate;
        });
      }
    });

    // time scale 1
    readBoolData("library_default_appointment_enable_time_1").then((enabled) {
      if (enabled != null) {
        setState(() {
          _enableTime1 = enabled;
        });
      }
    });
    readIntData("library_default_appointment_start_time_1_hour")
        .then((newHour) {
      int hour = 7, minute = 0;
      if (newHour != null) {
        hour = newHour;
      }
      readIntData("library_default_appointment_start_time_1_minute")
          .then((newMinute) {
        if (newMinute != null) {
          minute = newMinute;
        }
        _startTime1 = TimeOfDay(hour: hour, minute: minute);
      });
    });
    readIntData("library_default_appointment_end_time_1_hour").then((newHour) {
      int hour = 22, minute = 0;
      if (newHour != null) {
        hour = newHour;
      }
      readIntData("library_default_appointment_end_time_1_minute")
          .then((newMinute) {
        if (newMinute != null) {
          minute = newMinute;
        }
        _endTime1 = TimeOfDay(hour: hour, minute: minute);
      });
    });

    // time scale 2
    readBoolData("library_default_appointment_enable_time_2").then((enabled) {
      if (enabled != null) {
        setState(() {
          _enableTime2 = enabled;
        });
      }
    });
    readIntData("library_default_appointment_start_time_2_hour")
        .then((newHour) {
      int hour = 7, minute = 0;
      if (newHour != null) {
        hour = newHour;
      }
      readIntData("library_default_appointment_start_time_2_minute")
          .then((newMinute) {
        if (newMinute != null) {
          minute = newMinute;
        }
        _startTime2 = TimeOfDay(hour: hour, minute: minute);
      });
    });
    readIntData("library_default_appointment_end_time_2_hour").then((newHour) {
      int hour = 22, minute = 0;
      if (newHour != null) {
        hour = newHour;
      }
      readIntData("library_default_appointment_end_time_2_minute")
          .then((newMinute) {
        if (newMinute != null) {
          minute = newMinute;
        }
        _endTime2 = TimeOfDay(hour: hour, minute: minute);
      });
    });

    // time scale 3
    readBoolData("library_default_appointment_enable_time_3").then((enabled) {
      if (enabled != null) {
        setState(() {
          _enableTime3 = enabled;
        });
      }
    });
    readIntData("library_default_appointment_start_time_3_hour")
        .then((newHour) {
      int hour = 7, minute = 0;
      if (newHour != null) {
        hour = newHour;
      }
      readIntData("library_default_appointment_start_time_3_minute")
          .then((newMinute) {
        if (newMinute != null) {
          minute = newMinute;
        }
        _startTime3 = TimeOfDay(hour: hour, minute: minute);
      });
    });
    readIntData("library_default_appointment_end_time_3_hour").then((newHour) {
      int hour = 22, minute = 0;
      if (newHour != null) {
        hour = newHour;
      }
      readIntData("library_default_appointment_end_time_3_minute")
          .then((newMinute) {
        if (newMinute != null) {
          minute = newMinute;
        }
        _endTime3 = TimeOfDay(hour: hour, minute: minute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("图书馆快速预约设置"),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Column(
              children: [
                Expanded(flex: 1, child: Container()),
                defaultSeatWidget(_labName, _roomName, _devName),
                const SizedBox(
                  width: 400,
                  child: Divider(),
                ),
                Column(
                  children: [
                    const Text("默认预约时间", style: TextStyle(color: Colors.grey)),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: const Text("预约日期"),
                              ),
                              DropdownButton(
                                hint: const Text("请选择预约日期"),
                                value: _dateSelected,
                                onChanged: (newValue) {
                                  setState(() {
                                    _dateSelected = newValue!;
                                  });
                                },
                                items: dateList,
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Checkbox(
                                value: _enableTime1,
                                activeColor: Colors.blue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _enableTime1 = newValue!;
                                  });
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: const Text("预约时段 1"),
                              ),
                              Center(
                                child: SizedBox(
                                  width: 220,
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                          onPressed: _enableTime1
                                              ? () async {
                                                  TimeOfDay? selectedTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              _startTime1,
                                                          cancelText: "取消",
                                                          helpText:
                                                              "预约时段1 - 开始时间",
                                                          confirmText: "确认");
                                                  setState(() {
                                                    _startTime1 = selectedTime!;
                                                  });
                                                }
                                              : null,
                                          child: Text(
                                              timeOfDayToString(_startTime1))),
                                      if (_enableTime1) ...[
                                        const Text(
                                          " ~ ",
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ] else ...[
                                        const Text(
                                          " ~ ",
                                          style: TextStyle(
                                              fontSize: 24, color: Colors.grey),
                                        ),
                                      ],
                                      ElevatedButton(
                                        onPressed: _enableTime1
                                            ? () async {
                                                TimeOfDay? selectedTime =
                                                    await showTimePicker(
                                                        context: context,
                                                        initialTime: _endTime1,
                                                        cancelText: "取消",
                                                        helpText:
                                                            "预约时段1 - 结束时间",
                                                        confirmText: "确认");
                                                setState(() {
                                                  _endTime1 = selectedTime!;
                                                });
                                              }
                                            : null,
                                        child:
                                            Text(timeOfDayToString(_endTime1)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Checkbox(
                                value: _enableTime2,
                                activeColor: Colors.blue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _enableTime2 = newValue!;
                                  });
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: const Text("预约时段 2"),
                              ),
                              Center(
                                  child: SizedBox(
                                      width: 220,
                                      child: Row(children: [
                                        ElevatedButton(
                                            onPressed: _enableTime2
                                                ? () async {
                                                    TimeOfDay? selectedTime =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                _startTime2,
                                                            cancelText: "取消",
                                                            helpText:
                                                                "预约时段2 - 开始时间",
                                                            confirmText: "确认");
                                                    setState(() {
                                                      _startTime2 =
                                                          selectedTime!;
                                                    });
                                                  }
                                                : null,
                                            child: Text(timeOfDayToString(
                                                _startTime2))),
                                        if (_enableTime2) ...[
                                          const Text(
                                            " ~ ",
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ] else ...[
                                          const Text(
                                            " ~ ",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey),
                                          ),
                                        ],
                                        ElevatedButton(
                                          onPressed: _enableTime2
                                              ? () async {
                                                  TimeOfDay? selectedTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              _endTime2,
                                                          cancelText: "取消",
                                                          helpText:
                                                              "预约时段2 - 结束时间",
                                                          confirmText: "确认");
                                                  setState(() {
                                                    _endTime2 = selectedTime!;
                                                  });
                                                }
                                              : null,
                                          child: Text(
                                              timeOfDayToString(_endTime2)),
                                        ),
                                      ]))),
                            ])),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Checkbox(
                                value: _enableTime3,
                                activeColor: Colors.blue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _enableTime3 = newValue!;
                                  });
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: const Text("预约时段 3"),
                              ),
                              Center(
                                  child: SizedBox(
                                      width: 220,
                                      child: Row(children: [
                                        ElevatedButton(
                                            onPressed: _enableTime3
                                                ? () async {
                                                    TimeOfDay? selectedTime =
                                                        await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                _startTime3,
                                                            cancelText: "取消",
                                                            helpText:
                                                                "预约时段3 - 开始时间",
                                                            confirmText: "确认");
                                                    setState(() {
                                                      _startTime3 =
                                                          selectedTime!;
                                                    });
                                                  }
                                                : null,
                                            child: Text(timeOfDayToString(
                                                _startTime3))),
                                        if (_enableTime3) ...[
                                          const Text(
                                            " ~ ",
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ] else ...[
                                          const Text(
                                            " ~ ",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.grey),
                                          ),
                                        ],
                                        ElevatedButton(
                                          onPressed: _enableTime3
                                              ? () async {
                                                  TimeOfDay? selectedTime =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              _endTime3,
                                                          cancelText: "取消",
                                                          helpText:
                                                              "预约时段3 - 结束时间",
                                                          confirmText: "确认");
                                                  setState(() {
                                                    _endTime3 = selectedTime!;
                                                  });
                                                }
                                              : null,
                                          child: Text(
                                              timeOfDayToString(_endTime3)),
                                        ),
                                      ]))),
                            ])),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text("保存"),
                        onPressed: () async {
                          _checkTimeScaleLegalAndSave(
                            dateSelected: _dateSelected,
                            enableTime1: _enableTime1,
                            startTime1: _startTime1,
                            endTime1: _endTime1,
                            enableTime2: _enableTime2,
                            startTime2: _startTime2,
                            endTime2: _endTime2,
                            enableTime3: _enableTime3,
                            startTime3: _startTime3,
                            endTime3: _endTime3,
                          ).then((result) {
                            if (result) {
                              Fluttertoast.showToast(
                                  msg: "保存成功！",
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.green,
                                  fontSize: 18);
                              Navigator.pop(context);
                            }
                          });
                        },
                        style: const ButtonStyle(
                            minimumSize: WidgetStatePropertyAll(Size(140, 50))),
                      ),
                    )
                  ],
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkTimeScaleLegalAndSave({
    required int dateSelected,
    required bool enableTime1,
    required TimeOfDay startTime1,
    required TimeOfDay endTime1,
    required bool enableTime2,
    required TimeOfDay startTime2,
    required TimeOfDay endTime2,
    required bool enableTime3,
    required TimeOfDay startTime3,
    required TimeOfDay endTime3,
  }) async {
    List<(TimeOfDay start, TimeOfDay end)> timeScaleList = [];

    if (!(dateSelected >= 0 && dateSelected <= 3)) {
      Fluttertoast.showToast(msg: "预约日期非法", gravity: ToastGravity.BOTTOM);
      return false;
    }

    if (enableTime1) {
      if (!_isTimeScaleLegal(startTime1, endTime1)) {
        Fluttertoast.showToast(
            msg: "预约时段 1 的开始时间必须早于结束时间", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleInOpeningHours(startTime1, endTime1)) {
        Fluttertoast.showToast(
            msg: "预约时段 1 必须位于可预约时间 (07:00~22:00) 内",
            gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleLowerThan6Hour(startTime1, endTime1)) {
        Fluttertoast.showToast(
            msg: "预约时段 1 必须短于 6 小时", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleGreaterThan2Hour(startTime1, endTime1)) {
        Fluttertoast.showToast(
            msg: "预约时段 1 必须不短于 2 小时", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleMinuteMod5Equals0(startTime1, endTime1)) {
        Fluttertoast.showToast(
            msg: "预约时段 1 的开始时间和结束时间的分钟必须为 5 的倍数", gravity: ToastGravity.BOTTOM);
        return false;
      }
      timeScaleList.add((startTime1, endTime1));
    }

    if (enableTime2) {
      if (!_isTimeScaleLegal(startTime2, endTime2)) {
        Fluttertoast.showToast(
            msg: "预约时段 2 的开始时间必须早于结束时间", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleInOpeningHours(startTime2, endTime2)) {
        Fluttertoast.showToast(
            msg: "预约时段 2 必须位于可预约时间 (07:00~22:00) 内",
            gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleLowerThan6Hour(startTime2, endTime2)) {
        Fluttertoast.showToast(
            msg: "预约时段 2 必须短于 6 小时", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleGreaterThan2Hour(startTime2, endTime2)) {
        Fluttertoast.showToast(
            msg: "预约时段 2 必须不短于 2 小时", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleMinuteMod5Equals0(startTime2, endTime2)) {
        Fluttertoast.showToast(
            msg: "预约时段 2 的开始时间和结束时间的分钟必须为 5 的倍数", gravity: ToastGravity.BOTTOM);
        return false;
      }
      timeScaleList.add((startTime2, endTime2));
    }

    if (enableTime3) {
      if (!_isTimeScaleLegal(startTime3, endTime3)) {
        Fluttertoast.showToast(
            msg: "预约时段 3 的开始时间必须早于结束时间", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleInOpeningHours(startTime3, endTime3)) {
        Fluttertoast.showToast(
            msg: "预约时段 3 必须位于可预约时间 (07:00~22:00) 内",
            gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleLowerThan6Hour(startTime3, endTime3)) {
        Fluttertoast.showToast(
            msg: "预约时段 3 必须短于 6 小时", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleGreaterThan2Hour(startTime3, endTime3)) {
        Fluttertoast.showToast(
            msg: "预约时段 3 必须不短于 2 小时", gravity: ToastGravity.BOTTOM);
        return false;
      }
      if (!_isTimeScaleMinuteMod5Equals0(startTime3, endTime3)) {
        Fluttertoast.showToast(
            msg: "预约时段 3 的开始时间和结束时间的分钟必须为 5 的倍数", gravity: ToastGravity.BOTTOM);
        return false;
      }
      timeScaleList.add((startTime3, endTime3));
    }

    if (timeScaleList.length > 1) {
      if (!_isTimeScalesConflict(timeScaleList)) {
        Fluttertoast.showToast(msg: "预约时段之间有冲突", gravity: ToastGravity.BOTTOM);
        return false;
      }
    }

    await saveIntData("library_default_appointment_date", dateSelected);
    // save time scale 1
    await saveBoolData(
        "library_default_appointment_enable_time_1", enableTime1);
    await saveIntData(
        "library_default_appointment_start_time_1_hour", startTime1.hour);
    await saveIntData(
        "library_default_appointment_start_time_1_minute", startTime1.minute);
    await saveIntData(
        "library_default_appointment_end_time_1_hour", endTime1.hour);
    await saveIntData(
        "library_default_appointment_end_time_1_minute", endTime1.minute);
    // save time scale 2
    await saveBoolData(
        "library_default_appointment_enable_time_2", enableTime2);
    await saveIntData(
        "library_default_appointment_start_time_2_hour", startTime2.hour);
    await saveIntData(
        "library_default_appointment_start_time_2_minute", startTime2.minute);
    await saveIntData(
        "library_default_appointment_end_time_2_hour", endTime2.hour);
    await saveIntData(
        "library_default_appointment_end_time_2_minute", endTime2.minute);
    // save time scale 3
    await saveBoolData(
        "library_default_appointment_enable_time_3", enableTime3);
    await saveIntData(
        "library_default_appointment_start_time_3_hour", startTime3.hour);
    await saveIntData(
        "library_default_appointment_start_time_3_minute", startTime3.minute);
    await saveIntData(
        "library_default_appointment_end_time_3_hour", endTime3.hour);
    await saveIntData(
        "library_default_appointment_end_time_3_minute", endTime3.minute);

    return true;
  }

  bool _isTimeScaleLegal(TimeOfDay start, TimeOfDay end) {
    if (end.hour > start.hour) {
      return true;
    } else if (end.hour == start.hour) {
      return end.minute > start.minute;
    } else {
      return false;
    }
  }

  bool _isTimeScaleInOpeningHours(TimeOfDay start, TimeOfDay end) {
    return (start.hour >= 7 &&
        (end.hour < 22 || (end.hour == 22 && end.minute == 0)));
  }

  bool _isTimeScaleLowerThan6Hour(TimeOfDay start, TimeOfDay end) {
    if (end.minute >= start.minute) {
      return ((end.hour - start.hour) * 60 + (end.minute - start.minute)) <=
          360;
    } else {
      return ((end.hour - start.hour) * 60 - (start.minute - end.minute)) <=
          360;
    }
  }

  bool _isTimeScaleGreaterThan2Hour(TimeOfDay start, TimeOfDay end) {
    if (end.minute >= start.minute) {
      return ((end.hour - start.hour) * 60 + (end.minute - start.minute)) >=
          120;
    } else {
      return ((end.hour - start.hour) * 60 - (start.minute - end.minute)) >=
          120;
    }
  }

  bool _isTimeScaleMinuteMod5Equals0(TimeOfDay start, TimeOfDay end) {
    return (start.minute % 5 == 0 && end.minute % 5 == 0);
  }

  bool _isTimeScalesConflict(
      List<(TimeOfDay start, TimeOfDay end)> timeScaleList) {
    List<bool> timeLine = List.filled(1500, false);
    for (var (start, end) in timeScaleList) {
      for (int i = start.hour * 60 + start.minute;
          i < end.hour * 60 + end.minute;
          i++) {
        if (!timeLine[i]) {
          timeLine[i] = true;
        } else {
          return false;
        }
      }
    }
    return true;
  }
}

const List<DropdownMenuItem> dateList = [
  DropdownMenuItem(
    value: 0,
    child: Text("当天"),
  ),
  DropdownMenuItem(
    value: 1,
    child: Text("一天后"),
  ),
  DropdownMenuItem(
    value: 2,
    child: Text("两天后"),
  ),
  DropdownMenuItem(
    value: 3,
    child: Text("三天后"),
  ),
];

String timeOfDayToString(TimeOfDay time) {
  late String hour;
  if (time.hour < 10) {
    hour = '0${time.hour}';
  } else {
    hour = time.hour.toString();
  }

  late String minute;
  if (time.minute < 10) {
    minute = '0${time.minute}';
  } else {
    minute = time.minute.toString();
  }

  return "$hour : $minute";
}
