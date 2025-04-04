import 'dart:io';

import 'package:backend/src/core/files/file_generate.dart';
import 'package:backend/src/core/files/file_manager.dart';

class CronGenerator extends FileGenerator {
  @override
  Future<void> generate(
    FileManager fileManager,
    Directory directory, {
    Map<String, dynamic> variables = const {},
  }) async {
    final libConfigCronCronConfiguration = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}cron${Platform.pathSeparator}cron_configuration.dart');
    await libConfigCronCronConfiguration.create(recursive: true);
    await libConfigCronCronConfiguration
        .writeAsString(_libConfigCronCronConfigurationContent);

    final libConfigCronCronExpression = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}cron${Platform.pathSeparator}cron_expression.dart');
    await libConfigCronCronExpression.create(recursive: true);
    await libConfigCronCronExpression
        .writeAsString(_libConfigCronCronExpressionContent);

    final libConfigCronCronJob = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}cron${Platform.pathSeparator}cron_job.dart');
    await libConfigCronCronJob.create(recursive: true);
    await libConfigCronCronJob.writeAsString(_libConfigCronCronJobContent);

    final libConfigCronScheduler = File(
        '${directory.path}${Platform.pathSeparator}lib${Platform.pathSeparator}config${Platform.pathSeparator}cron${Platform.pathSeparator}scheduler.dart');
    await libConfigCronScheduler.create(recursive: true);
    await libConfigCronScheduler.writeAsString(_libConfigCronSchedulerContent);
  }
}

const _libConfigCronCronConfigurationContent =
    '''import 'scheduler.dart';
import 'package:vaden/vaden.dart';

@Configuration()
class CronConfiguration {
  @Bean()
  CronScheduler cronScheduler() {
    return CronScheduler();
  }
}
''';

const _libConfigCronCronExpressionContent = r'''class CronExpression {
  final Set<int> minutes;
  final Set<int> hours;
  final Set<int> daysOfMonth;
  final Set<int> months;
  final Set<int> daysOfWeek;

  CronExpression._({
    required this.minutes,
    required this.hours,
    required this.daysOfMonth,
    required this.months,
    required this.daysOfWeek,
  });

  factory CronExpression(String expression) {
    final parts = expression.trim().split(RegExp(r'\s+'));
    if (parts.length != 5) {
      throw FormatException('Cron format not valid');
    }
    final minutes = _parseField(parts[0], 0, 59);
    final hours = _parseField(parts[1], 0, 23);
    final daysOfMonth = _parseField(parts[2], 1, 31);
    final months = _parseField(parts[3], 1, 12);
    final daysOfWeek = _parseField(parts[4], 0, 6);

    return CronExpression._(
      minutes: minutes,
      hours: hours,
      daysOfMonth: daysOfMonth,
      months: months,
      daysOfWeek: daysOfWeek,
    );
  }

  static Set<int> _parseField(String field, int min, int max) {
    final result = <int>{};

    if (field == '*') {
      return {for (int i = min; i <= max; i++) i};
    }

    for (final cronbyte in field.split(',').map((t) => t.trim())) {
      if (cronbyte.contains('/')) {
        result.addAll(_parseStepCron(cronbyte, min, max));
      }
      final newMin = _resetRange(field, min, max)['min']!;
      final newMax = _resetRange(field, min, max)['max']!;
      result.addAll({for (int i = newMin; i <= newMax; i++) i});
    }
    return result;
  }

  static Set<int> _parseStepCron(String cronbyte, int min, int max) {
    final parts = cronbyte.split('/');
    final rangePart = parts[0];
    final step = int.tryParse(parts[1]);

    if (parts.length != 2 || step == null || step <= 0) {
      throw FormatException('Cron format not valid. (At $cronbyte)');
    }

    final rangeStart = _resetRange(rangePart, min, max)['min']!;
    final rangeEnd = _resetRange(rangePart, min, max)['max']!;
    final result = <int>{};
    for (int i = rangeStart; i <= rangeEnd; i += step) {
      if (i >= min && i <= max) {
        result.add(i);
      }
    }
    return result;
  }

  static Map<String, int> _resetRange(String rangebyte, int min, int max) {
    if (rangebyte == '*') {
      return {'min': min, 'max': max};
    }

    if (rangebyte.contains('-')) {
      final bounds = rangebyte.split('-');
      final newMin = int.tryParse(bounds[0]);
      final newMax = int.tryParse(bounds[1]);
      if (bounds.length != 2 ||
          newMin == null ||
          newMin < min ||
          newMax == null ||
          newMax > max) {
        throw FormatException('Cron format not valid. (At $rangebyte)');
      }
      if (newMin < min || newMin >= newMax) {
        throw FormatException('Value $newMin must be between $min and $newMax');
      }
      if (newMax <= newMin || newMax > max) {
        throw FormatException('Value $newMax must be between $newMin and $max');
      }
      return {'min': newMin, 'max': newMax};
    }

    final value = int.tryParse(rangebyte);
    if (value == null) {
      throw FormatException('Cron format not valid');
    }
    if (value < min || value > max) {
      throw FormatException('Value $value must be between $min and $max');
    }
    return {'min': value, 'max': value};
  }

  DateTime getNextDateTime(DateTime from) {
    DateTime next = DateTime(
      from.year,
      from.month,
      from.day,
      from.hour,
      from.minute,
    ).add(Duration(minutes: 1));

    return next //
        .map((dt) => months.contains(dt.month) ? dt : _nextMonth(dt))
        .map(_nextDays)
        .map(_nextHours)
        .map(_nextMinutes);
  }

  DateTime _nextMonth(DateTime next) {
    int nextMonth = months.firstWhere(
      (m) => m > next.month,
      orElse: () => months.first,
    );
    int year = next.year;
    if (nextMonth <= next.month) {
      year++;
    }
    return DateTime(
      year,
      nextMonth,
      daysOfMonth.first,
      hours.first,
      minutes.first,
    );
  }

  DateTime _daysRemainingInMonth(DateTime next) {
    if (daysOfMonth.contains(next.day)) {
      return next;
    }

    final lastDayOfMonth =
        DateTime(
          next.year,
          next.month + 1,
          1,
        ).subtract(const Duration(days: 1)).day;
    final validDaysInMonth =
        daysOfMonth.where((d) => d > next.day && d <= lastDayOfMonth).toList();

    if (validDaysInMonth.isEmpty) {
      return _nextMonth(next);
    }

    return next.copyWith(
      day: validDaysInMonth[1],
      hour: hours.first,
      minute: minutes.first,
    );
  }

  DateTime _nextDays(DateTime next) {
    next = _daysRemainingInMonth(next);
    while (true) {
      if (daysOfWeek.contains(next.weekday % 7)) {
        return next;
      }
      next = _daysRemainingInMonth(next.add(Duration(days: 1)));
    }
  }

  DateTime _nextHours(DateTime next) {
    if (hours.contains(next.hour)) {
      return next;
    }

    int nextHour = hours.firstWhere((h) => h > next.hour, orElse: () => -1);
    if (nextHour == -1 || next.hour >= hours.last) {
      next = next.add(Duration(days: 1));
      next = next.copyWith(hour: hours.first, minute: minutes.first);
      return _nextDays(next);
    }

    return next.copyWith(hour: nextHour, minute: minutes.first);
  }

  DateTime _nextMinutes(DateTime next) {
    if (minutes.contains(next.minute)) {
      return next;
    }

    int nextMinute = minutes.firstWhere(
      (m) => m > next.minute,
      orElse: () => -1,
    );
    if (nextMinute == -1 || next.minute >= minutes.last) {
      next = next.add(Duration(hours: 1));
      next = next.copyWith(minute: minutes.first);
      return _nextHours(next);
    }
    return next.copyWith(minute: nextMinute);
  }
}

extension _DateTimeMapExtension on DateTime {
  T map<T>(T Function(DateTime) transform) => transform(this);
}
''';

const _libConfigCronCronJobContent = r'''import 'dart:async';
import 'cron_expression.dart';

typedef CronCallback = FutureOr<void> Function();

class CronJob {
  final String id;
  final CronCallback callback;
  final int maxRetries;
  final Duration retryBackoff;

  Timer? _timer;
  bool _isPaused = false;
  int _currentRetryAttempts = 0;

  late final CronExpression? _parsedExpression;
  late final Duration? _interval;

  CronJob({
    required String cron,
    required this.id,
    required this.callback,
    this.maxRetries = 0,
    this.retryBackoff = const Duration(seconds: 1),
  }) : _parsedExpression = CronExpression(cron),
       _interval = null;

  CronJob.interval({
    required Duration interval,
    required this.id,
    required this.callback,
    this.maxRetries = 0,
    this.retryBackoff = const Duration(seconds: 1),
  }) : _parsedExpression = null,
       _interval = interval;

  void start() {
    if (_isPaused) return;
    if (_interval != null) {
      _scheduleNextInterval();
    }
    if (_parsedExpression != null) {
      _scheduleNextCron();
    }
  }

  void _scheduleNextInterval() {
    if (_isPaused) return;
    _timer = Timer(_interval!, () async {
      await _executeCallback();
      if (!_isPaused) {
        _scheduleNextInterval();
      }
    });
  }

  void _scheduleNextCron() {
    if (_isPaused) return;
    final now = DateTime.now();

    final duration = _parsedExpression!.getNextDateTime(now).difference(now);

    _timer = Timer(duration, () async {
      await _executeCallback();
      if (!_isPaused) {
        _scheduleNextCron();
      }
    });
  }

  Future<void> _executeCallback() async {
    if (_isPaused) return;
    try {
      await callback();
      _currentRetryAttempts = 0;
    } catch (e) {
      print('Error on job "$id": $e');
      if (_currentRetryAttempts < maxRetries) {
        _currentRetryAttempts++;
        final backoffDelay = retryBackoff * (1 << (_currentRetryAttempts - 1));
        print(
          'Retrying in ${backoffDelay.inSeconds} seconds (RetryAttempts $_currentRetryAttempts of $maxRetries)',
        );
        Timer(backoffDelay, () async {
          await _executeCallback();
        });
      } else {
        print('Job "$id" failed after $maxRetries attempts.');
        _currentRetryAttempts = 0;
      }
    }
  }

  void pause() {
    _isPaused = true;
    _timer?.cancel();
    print('Pause job "$id".');
  }

  void resume() {
    if (!_isPaused) return;
    _isPaused = false;
    print('Resume job "$id".');
    start();
  }

  void stop() {
    _timer?.cancel();
    _isPaused = false;
  }

  bool get isRunning => _timer?.isActive ?? false;
  bool get isPaused => _isPaused;
}
''';

const _libConfigCronSchedulerContent = r'''import 'cron_job.dart';

class CronScheduler {
  final Map<String, CronJob> _jobs = {};

  void addJob(CronJob job) {
    if (_jobs.containsKey(job.id)) {
      throw Exception('Job ${job.id} already exists.');
    }
    _jobs[job.id] = job;
    job.start();
  }

  void removeJob(String id) {
    final job = _jobs.remove(id);
    job?.stop();
  }

  void stopAll() {
    for (final job in _jobs.values) {
      job.stop();
    }
    _jobs.clear();
  }

  bool isJobRunning(String id) => _jobs[id]?.isRunning ?? false;
  List<String> get activeJobs => _jobs.keys.toList();

  void pauseJob(String id) {
    _jobs[id]?.pause();
  }

  void resumeJob(String id) {
    _jobs[id]?.resume();
  }

  void pauseAll() {
    for (final job in _jobs.values) {
      job.pause();
    }
  }

  void resumeAll() {
    for (final job in _jobs.values) {
      job.resume();
    }
  }
}
''';
