import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/helpers/crash_logger.dart';

/// Represents a single loading task
class LoadingTask {
  final String name;
  final Future<dynamic> Function() loader;
  final String? errorMessage;

  const LoadingTask({
    required this.name,
    required this.loader,
    this.errorMessage,
  });
}

/// Result of loading operation
class LoadingResult {
  final bool isSuccess;
  final Map<String, dynamic> data;
  final String? errorMessage;
  final LoadingTask? failedTask;

  LoadingResult.success(this.data)
    : isSuccess = true,
      errorMessage = null,
      failedTask = null;

  LoadingResult.failure({required this.errorMessage, this.failedTask})
    : isSuccess = false,
      data = {};
}

class LoadingScreen extends StatefulWidget {
  /// List of loading tasks to execute
  final List<LoadingTask>? tasks;

  /// Callback when all tasks complete successfully
  final Function(Map<String, dynamic> data)? onSuccess;

  /// Callback when any task fails
  final Function(String errorMessage, LoadingTask? failedTask)? onError;

  /// Optional: Navigate to this route on success
  final String? successRoute;

  /// Optional: Arguments to pass to success route
  final dynamic successRouteArguments;

  /// Optional: Custom loading message
  final String? loadingMessage;

  /// Whether to execute tasks sequentially (true) or in parallel (false)
  final bool sequential;

  const LoadingScreen({
    super.key,
    this.tasks,
    this.onSuccess,
    this.onError,
    this.successRoute,
    this.successRouteArguments,
    this.loadingMessage,
    this.sequential = true,
  });

  static String keyName = '/loading';

  // Static map to store completers for receiving data from pushReplacementNamed
  static final Map<String, Completer<Map<String, dynamic>?>> _completers = {};
  static int _completerIdCounter = 0;

  /// Helper method to navigate to loading screen
  static Future<Map<String, dynamic>?> navigate(
    BuildContext context, {
    required List<LoadingTask> tasks,
    bool replaceCurrentRoute = false,
    String? successRoute,
    dynamic successRouteArguments,
    String? loadingMessage,
    bool sequential = true,
    Function(Map<String, dynamic> data)? onSuccess,
    Function(String errorMessage, LoadingTask? failedTask)? onError,
  }) {
    if (replaceCurrentRoute) {
      // Use Completer to receive data from onSuccess callback
      final completerId =
          '${DateTime.now().millisecondsSinceEpoch}_${_completerIdCounter++}';
      final completer = Completer<Map<String, dynamic>?>();
      _completers[completerId] = completer;

      // Wrap onSuccess to complete the completer
      Function(Map<String, dynamic> data)? wrappedOnSuccess;
      if (onSuccess != null) {
        wrappedOnSuccess = (data) {
          onSuccess(data);
          final c = _completers.remove(completerId);
          c?.complete(data);
        };
      } else {
        wrappedOnSuccess = (data) {
          final c = _completers.remove(completerId);
          c?.complete(data);
        };
      }

      // Wrap onError to complete with error data
      Function(String errorMessage, LoadingTask? failedTask)? wrappedOnError;
      if (onError != null) {
        wrappedOnError = (errorMessage, failedTask) {
          onError(errorMessage, failedTask);
          final c = _completers.remove(completerId);
          c?.complete({
            'error': true,
            'message': errorMessage,
            'failedTask': failedTask,
          });
        };
      } else {
        wrappedOnError = (errorMessage, failedTask) {
          final c = _completers.remove(completerId);
          c?.complete({
            'error': true,
            'message': errorMessage,
            'failedTask': failedTask,
          });
        };
      }

      Navigator.pushReplacementNamed(
        context,
        keyName,
        arguments: {
          'tasks': tasks,
          'successRoute': successRoute,
          'successRouteArguments': successRouteArguments,
          'loadingMessage': loadingMessage,
          'sequential': sequential,
          'onSuccess': wrappedOnSuccess,
          'onError': wrappedOnError,
          '_completerId': completerId, // Store ID for cleanup if needed
        },
      );

      return completer.future;
    } else {
      return Navigator.pushNamed(
        context,
        keyName,
        arguments: {
          'tasks': tasks,
          'successRoute': successRoute,
          'successRouteArguments': successRouteArguments,
          'loadingMessage': loadingMessage,
          'sequential': sequential,
          'onSuccess': onSuccess,
          'onError': onError,
        },
      ).then((result) {
        if (result is Map<String, dynamic>) {
          return result;
        }
        return null;
      });
    }
  }

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _currentTaskIndex = 0;
  bool _isLoading = true;
  LoadingResult? _result;

  List<LoadingTask> get _tasks {
    // Get tasks from widget or route arguments
    if (widget.tasks != null) {
      return widget.tasks!;
    }

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      final tasks = args['tasks'];
      if (tasks != null && tasks is List) {
        return tasks.cast<LoadingTask>();
      }
    }

    return [];
  }

  String? get _successRoute {
    return widget.successRoute ??
        (ModalRoute.of(context)?.settings.arguments as Map?)?['successRoute']
            as String?;
  }

  dynamic get _successRouteArguments {
    return widget.successRouteArguments ??
        (ModalRoute.of(context)?.settings.arguments
            as Map?)?['successRouteArguments'];
  }

  String? get _loadingMessage {
    return widget.loadingMessage ??
        (ModalRoute.of(context)?.settings.arguments as Map?)?['loadingMessage']
            as String?;
  }

  bool get _sequential {
    return widget.sequential &&
        ((ModalRoute.of(context)?.settings.arguments as Map?)?['sequential'] ??
                true)
            as bool;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final tasks = _tasks;

    if (tasks.isEmpty) {
      _handleSuccess({});
      return;
    }

    try {
      final Map<String, dynamic> results = {};

      if (_sequential) {
        // Execute tasks sequentially
        for (int i = 0; i < tasks.length; i++) {
          if (!mounted) return;

          setState(() {
            _currentTaskIndex = i;
          });

          try {
            final result = await tasks[i].loader();
            results[tasks[i].name] = result;
          } on PlatformException catch (e) {
            CrashLogger.tryToRecordError(
              'Lỗi khi tải ${tasks[i].name}: ${e.toString()}',
              error: e,
              stackTrace: e.stacktrace as StackTrace? ?? StackTrace.current,
            );
            _handleError(
              tasks[i].errorMessage ??
                  'Lỗi khi tải ${tasks[i].name}: ${e.toString()}',
              tasks[i],
            );
            return;
          } catch (e) {
            CrashLogger.tryToRecordError(
              'Lỗi khi tải ${tasks[i].name}: ${e.toString()}',
              error: e,
              stackTrace: .current,
            );
            _handleError(
              tasks[i].errorMessage ??
                  'Lỗi khi tải ${tasks[i].name}: ${e.toString()}',
              tasks[i],
            );
          }
        }
      } else {
        // Execute tasks in parallel
        final futures = tasks.asMap().entries.map((entry) async {
          final index = entry.key;
          final task = entry.value;

          try {
            final result = await task.loader();
            if (mounted) {
              setState(() {
                _currentTaskIndex = index + 1;
              });
            }
            return MapEntry(task.name, result);
          } catch (e) {
            throw LoadingError(
              message:
                  task.errorMessage ??
                  'Lỗi khi tải ${task.name}: ${e.toString()}',
              task: task,
            );
          }
        });

        final resultsList = await Future.wait(futures);
        for (var entry in resultsList) {
          results[entry.key] = entry.value;
        }
      }

      _handleSuccess(results);
    } catch (e) {
      if (e is LoadingError) {
        _handleError(e.message, e.task);
      } else {
        _handleError('Đã xảy ra lỗi không mong muốn: ${e.toString()}', null);
      }
    }
  }

  void _handleSuccess(Map<String, dynamic> data) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _result = LoadingResult.success(data);
    });

    // Call success callback
    widget.onSuccess?.call(data);

    // Navigate to success route if provided
    final successRoute = _successRoute;
    if (successRoute != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          context.navigator.pushReplacementNamed(
            successRoute,
            arguments: _successRouteArguments,
          );
        }
      });
    } else {
      // If no route, pop back with success result
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pop(context, data);
        }
      });
    }
  }

  void _handleError(String errorMessage, LoadingTask? failedTask) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _result = LoadingResult.failure(
        errorMessage: errorMessage,
        failedTask: failedTask,
      );
    });

    if (widget.onError != null) {
      // if (mounted) context.navigator.pop();
      widget.onError?.call(errorMessage, failedTask);
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.showNotificationDialog(
          title: 'Lỗi',
          message: errorMessage,
          action: 'Đóng',
          ontap: () {
            Navigator.pop(context);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(child: Center(child: _buildLoadingView())),
    );
  }

  Widget _buildLoadingView() {
    final tasks = _tasks;
    final progress = tasks.isEmpty
        ? 0.0
        : (_currentTaskIndex + 1) / tasks.length;
    final currentTaskName = _currentTaskIndex < tasks.length
        ? tasks[_currentTaskIndex].name
        : '';
    final loadingMessage = _loadingMessage;

    return ColumnWidget(
      mainAxisAlignment: MainAxisAlignment.center,
      // gap: 24.h,
      children: [
        // SvgPicture.asset(
        //   AssetLogos.logoLauncherPng,
        //   height: 48.w,
        //   fit: BoxFit.fitHeight,
        // ),
        SizedBox(height: 80),
        Image.asset(
          AssetLogos.baseLogoPng,
          height: 0.28.sw,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(
          width: 80.w,
          height: 80.w,
          child: LoadingAnimationWidget.flickr(
            leftDotColor: AppColors.loadingIndicatorLeftDot,
            rightDotColor: AppColors.loadingIndicatorRightDot,
            size: 36.w,
          ),
        ),
        // ColumnWidget(
        //   gap: 8.h,
        //   children: [
        //     if (tasks.length > 1 && currentTaskName.isNotEmpty)
        //       Text(
        //         'Đang tải: $currentTaskName',
        //         style: AppStyles.text.medium(
        //           fSize: 14.sp,
        //           color: AppColors.grey84,
        //         ),
        //       ),
        //     if (tasks.length > 1)
        //       Text(
        //         '${_currentTaskIndex + 1}/${tasks.length}',
        //         style: AppStyles.text.medium(
        //           fSize: 12.sp,
        //           color: AppColors.grey97,
        //         ),
        //       ),
        //   ],
        // ),
      ],
    );
  }
}

class LoadingError implements Exception {
  final String message;
  final LoadingTask? task;

  LoadingError({required this.message, this.task});

  @override
  String toString() => message;
}
