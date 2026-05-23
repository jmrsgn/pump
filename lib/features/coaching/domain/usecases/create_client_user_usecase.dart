import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/dto/request/create_client_user_request_dto.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/domain/repository/client_user_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../enums/activity_level.dart';
import '../../enums/fitness_goal.dart';
import '../../enums/gender.dart';

class CreateClientUserUseCase {
  final ClientUserRepository _clientUserRepository;

  CreateClientUserUseCase(this._clientUserRepository);

  Future<Result<ClientUser, AppError>> execute(
    String firstName,
    String lastName,
    String? profileImageUrl,
    Gender? gender,
    DateTime? birthDate,
    double? heightCm,
    double? currentWeight,
    double? goalWeight,
    ActivityLevel? activityLevel,
    FitnessGoal? fitnessGoal,
  ) async {
    final request = CreateClientUserRequest(
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
      gender: gender,
      birthDate: birthDate,
      heightCm: heightCm,
      currentWeight: currentWeight,
      goalWeight: goalWeight,
      activityLevel: activityLevel,
      fitnessGoal: fitnessGoal,
    );
    return await _clientUserRepository.createClientUser(request);
  }
}
