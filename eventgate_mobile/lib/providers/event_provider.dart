import 'package:dio/dio.dart';
import 'package:eventgate/core/api_client.dart';
import 'package:eventgate/core/constants.dart';
import 'package:eventgate/models/event_model.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEvents() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _apiClient.dio.get(AppConstants.eventsEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        _events = data.map((json) => EventModel.fromJson(json)).toList();

        _events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _errorMessage = e.response?.data['error'] ?? 'Events cant loaded';
      } else {
        _errorMessage = 'Connection error.';
      }
    } catch (e) {
      _errorMessage = 'Unexpected error';
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> checkInParticipant(
    int eventId,
    String qrCode,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        AppConstants.checkInEndpoint,
        data: {'event_id': eventId, 'qr_code': qrCode},
      );
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Giriş Onaylandı',
          'participant': response.data['participant'],
        };
      }
    } on DioException catch (e) {
      String errorMsg = 'Bilinmeyen hata';

      if (e.response != null) {
        errorMsg = e.response?.data['error'] ?? 'İşlem başarısız';
      }

      return {'success': false, 'message': errorMsg};
    } catch (e) {
      return {'success': false, 'message': 'Bağlantı hatası'};
    }

    return {'success': false, 'message': 'İşlem tamamlanamadı'};
  }
}
