import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/data/dto/response/training_block_response_dto.dart';
import 'package:pump/features/coaching/data/service/training_block_service.dart';

const successfulResponseBody = '''
{
  "data": {
    "id": "1e038e6a-d039-4ef3-86e5-1bb2d85d4b9e",
    "clientId": "f2194be3-fe27-4911-9ae4-f7e5e6f3fdd1",
    "trainingBlockName": "Sample Training Block",
    "numberOfWeeks": 12,
    "trainingDays": 5,
    "trainingSplit": "Push, Pull, Legs, Upper, Lower",
    "estimatedMacros": 2000,
    "targetProteinInGrams": 150,
    "targetCarbsInGrams": 220,
    "targetFatInGrams": 60,
    "requiredDailySteps": 10000,
    "otherNotes": "Initial training block for API testing.",
    "status": "Active",
    "createdAt": null
  },
  "error": null
}
''';

void main() {
  test('create request contains only confirmed body fields', () {
    const request = CreateTrainingBlockRequest(
      trainingBlockName: 'Strength',
      numberOfWeeks: 12,
      trainingDays: 4,
      trainingSplit: 'Upper/Lower',
      estimatedMacros: 2400,
      targetProteinInGrams: 180,
      targetCarbsInGrams: 250,
      targetFatInGrams: 70,
      requiredDailySteps: 8000,
    );

    expect(request.toJson(), {
      'trainingBlockName': 'Strength',
      'numberOfWeeks': 12,
      'trainingDays': 4,
      'trainingSplit': 'Upper/Lower',
      'estimatedMacros': 2400,
      'targetProteinInGrams': 180,
      'targetCarbsInGrams': 250,
      'targetFatInGrams': 70,
      'requiredDailySteps': 8000,
      'otherNotes': null,
    });
  });

  test('response parses the envelope data shape and maps to domain', () {
    final response = TrainingBlockResponse.fromJson({
      'id': 'block-id',
      'clientId': 'client-id',
      'trainingBlockName': 'Strength',
      'numberOfWeeks': 12,
      'trainingDays': 4,
      'trainingSplit': 'Upper/Lower',
      'estimatedMacros': 2400,
      'targetProteinInGrams': 180,
      'targetCarbsInGrams': 250,
      'targetFatInGrams': 70,
      'requiredDailySteps': 8000,
      'otherNotes': 'Rest Sunday',
      'status': 'ACTIVE',
      'createdAt': '2026-09-24T12:00:00Z',
    });

    final block = response.toTrainingBlock();
    expect(block.id, 'block-id');
    expect(block.clientId, 'client-id');
    expect(block.status, 'ACTIVE');
    expect(block.createdAt, DateTime.utc(2026, 9, 24, 12));
    expect(block.otherNotes, 'Rest Sunday');
    expect(block.targetProteinInGrams, 180);
  });

  test('confirmed 201 response maps null createdAt and Active status', () {
    final envelope = jsonDecode(successfulResponseBody) as Map<String, dynamic>;

    expect(envelope['error'], isNull);
    final response = TrainingBlockResponse.fromJson(
      envelope['data'] as Map<String, dynamic>,
    );
    final block = response.toTrainingBlock();

    expect(block.id, '1e038e6a-d039-4ef3-86e5-1bb2d85d4b9e');
    expect(block.clientId, 'f2194be3-fe27-4911-9ae4-f7e5e6f3fdd1');
    expect(block.status, 'Active');
    expect(block.createdAt, isNull);
    expect(block.otherNotes, 'Initial training block for API testing.');
  });

  test('service sends confirmed POST and accepts the 201 response', () async {
    const clientId = 'f2194be3-fe27-4911-9ae4-f7e5e6f3fdd1';
    const request = CreateTrainingBlockRequest(
      trainingBlockName: 'Sample Training Block',
      numberOfWeeks: 12,
      trainingDays: 5,
      trainingSplit: 'Push, Pull, Legs, Upper, Lower',
      estimatedMacros: 2000,
      targetProteinInGrams: 150,
      targetCarbsInGrams: 220,
      targetFatInGrams: 60,
      requiredDailySteps: 10000,
      otherNotes: 'Initial training block for API testing.',
    );

    final result = await http.runWithClient(
      () => TrainingBlockService().createTrainingBlock(
        'test-token',
        clientId,
        request,
      ),
      () => MockClient((outgoing) async {
        expect(outgoing.method, 'POST');
        expect(
          outgoing.url.toString(),
          '${ApiConstants.coachingServiceBaseUrl}/clients/$clientId/training-blocks/create',
        );
        expect(outgoing.headers['authorization'], 'Bearer test-token');
        expect(outgoing.headers['content-type'], 'application/json');
        expect(jsonDecode(outgoing.body), {
          'trainingBlockName': 'Sample Training Block',
          'numberOfWeeks': 12,
          'trainingDays': 5,
          'trainingSplit': 'Push, Pull, Legs, Upper, Lower',
          'estimatedMacros': 2000,
          'targetProteinInGrams': 150,
          'targetCarbsInGrams': 220,
          'targetFatInGrams': 60,
          'requiredDailySteps': 10000,
          'otherNotes': 'Initial training block for API testing.',
        });
        return http.Response(successfulResponseBody, 201);
      }),
    );

    expect(result.isSuccess, isTrue);
    expect(result.data?.status, 'Active');
    expect(result.data?.createdAt, isNull);
  });
}
