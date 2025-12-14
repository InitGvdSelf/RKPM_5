import 'package:rkpm_5/data/datasources/auth/auth_local_data_source.dart';
import 'package:rkpm_5/data/datasources/meds/meds_local_data_source.dart';
import 'package:rkpm_5/data/datasources/diary/diary_local_data_source.dart';
import 'package:rkpm_5/data/datasources/visits/visits_local_data_source.dart';
import 'package:rkpm_5/data/datasources/courses/courses_local_data_source.dart';
import 'package:rkpm_5/data/datasources/pharmacies/pharmacies_local_data_source.dart';
import 'package:rkpm_5/data/datasources/profile/profile_local_data_source.dart';

import 'package:rkpm_5/data/repositories/auth_repository_impl.dart';
import 'package:rkpm_5/data/repositories/meds_repository_impl.dart';
import 'package:rkpm_5/data/repositories/schedule_repository_impl.dart';
import 'package:rkpm_5/data/repositories/diary_repository_impl.dart';
import 'package:rkpm_5/data/repositories/visits_repository_impl.dart';
import 'package:rkpm_5/data/repositories/courses_repository_impl.dart';
import 'package:rkpm_5/data/repositories/pharmacies_repository_impl.dart';
import 'package:rkpm_5/data/repositories/profile_repository_impl.dart';

import 'package:rkpm_5/domain/repositories/auth_repository.dart';
import 'package:rkpm_5/domain/repositories/meds_repository.dart';
import 'package:rkpm_5/domain/repositories/schedule_repository.dart';
import 'package:rkpm_5/domain/repositories/diary_repository.dart';
import 'package:rkpm_5/domain/repositories/visits_repository.dart';
import 'package:rkpm_5/domain/repositories/courses_repository.dart';
import 'package:rkpm_5/domain/repositories/pharmacies_repository.dart';
import 'package:rkpm_5/domain/repositories/profile_repository.dart';

import 'package:rkpm_5/domain/usecases/auth/login_usecase.dart';
import 'package:rkpm_5/domain/usecases/auth/register_usecase.dart';
import 'package:rkpm_5/domain/usecases/auth/logout_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/get_meds_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/upsert_med_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/delete_med_usecase.dart';
import 'package:rkpm_5/domain/usecases/meds/restore_med_usecase.dart';
import 'package:rkpm_5/domain/usecases/schedule/get_day_schedule_usecase.dart';
import 'package:rkpm_5/domain/usecases/schedule/mark_dose_usecase.dart';
import 'package:rkpm_5/domain/usecases/schedule/set_dose_note_usecase.dart';
import 'package:rkpm_5/domain/usecases/diary/get_diary_usecase.dart';
import 'package:rkpm_5/domain/usecases/diary/add_diary_entry_usecase.dart';
import 'package:rkpm_5/domain/usecases/diary/delete_diary_entry_usecase.dart';
import 'package:rkpm_5/domain/usecases/visits/get_visits_usecase.dart';
import 'package:rkpm_5/domain/usecases/visits/add_visit_usecase.dart';
import 'package:rkpm_5/domain/usecases/visits/delete_visit_usecase.dart';
import 'package:rkpm_5/domain/usecases/courses/get_courses_usecase.dart';
import 'package:rkpm_5/domain/usecases/courses/add_course_usecase.dart';
import 'package:rkpm_5/domain/usecases/courses/delete_course_usecase.dart';
import 'package:rkpm_5/domain/usecases/pharmacies/get_pharmacies_usecase.dart';
import 'package:rkpm_5/domain/usecases/pharmacies/search_pharmacies_usecase.dart';
import 'package:rkpm_5/domain/usecases/profile/get_profile_usecase.dart';
import 'package:rkpm_5/domain/usecases/profile/update_profile_usecase.dart';

import 'package:rkpm_5/core/utils/dose_scheduler.dart';

/// Dependency Injection Container
class DI {
  // Data Sources
  static late final AuthLocalDataSource authLocalDataSource;
  static late final MedsLocalDataSource medsLocalDataSource;
  static late final DiaryLocalDataSource diaryLocalDataSource;
  static late final VisitsLocalDataSource visitsLocalDataSource;
  static late final CoursesLocalDataSource coursesLocalDataSource;
  static late final PharmaciesLocalDataSource pharmaciesLocalDataSource;
  static late final ProfileLocalDataSource profileLocalDataSource;

  // Repositories
  static late final AuthRepository authRepository;
  static late final MedsRepository medsRepository;
  static late final ScheduleRepository scheduleRepository;
  static late final DiaryRepository diaryRepository;
  static late final VisitsRepository visitsRepository;
  static late final CoursesRepository coursesRepository;
  static late final PharmaciesRepository pharmaciesRepository;
  static late final ProfileRepository profileRepository;

  // Use Cases
  static late final LoginUseCase loginUseCase;
  static late final RegisterUseCase registerUseCase;
  static late final LogoutUseCase logoutUseCase;
  static late final GetMedsUseCase getMedsUseCase;
  static late final UpsertMedUseCase upsertMedUseCase;
  static late final DeleteMedUseCase deleteMedUseCase;
  static late final RestoreMedUseCase restoreMedUseCase;
  static late final GetDayScheduleUseCase getDayScheduleUseCase;
  static late final MarkDoseUseCase markDoseUseCase;
  static late final SetDoseNoteUseCase setDoseNoteUseCase;
  static late final GetDiaryUseCase getDiaryUseCase;
  static late final AddDiaryEntryUseCase addDiaryEntryUseCase;
  static late final DeleteDiaryEntryUseCase deleteDiaryEntryUseCase;
  static late final GetVisitsUseCase getVisitsUseCase;
  static late final AddVisitUseCase addVisitUseCase;
  static late final DeleteVisitUseCase deleteVisitUseCase;
  static late final GetCoursesUseCase getCoursesUseCase;
  static late final AddCourseUseCase addCourseUseCase;
  static late final DeleteCourseUseCase deleteCourseUseCase;
  static late final GetPharmaciesUseCase getPharmaciesUseCase;
  static late final SearchPharmaciesUseCase searchPharmaciesUseCase;
  static late final GetProfileUseCase getProfileUseCase;
  static late final UpdateProfileUseCase updateProfileUseCase;

  // Utils
  static late final DoseScheduler doseScheduler;

  static Future<void> init() async {
    // Initialize Data Sources
    authLocalDataSource = AuthLocalDataSource();
    medsLocalDataSource = MedsLocalDataSource();
    diaryLocalDataSource = DiaryLocalDataSource();
    visitsLocalDataSource = VisitsLocalDataSource();
    coursesLocalDataSource = CoursesLocalDataSource();
    pharmaciesLocalDataSource = PharmaciesLocalDataSource();
    profileLocalDataSource = ProfileLocalDataSource();

    // Initialize Repositories
    authRepository = AuthRepositoryImpl(authLocalDataSource);
    medsRepository = MedsRepositoryImpl(medsLocalDataSource);
    scheduleRepository = ScheduleRepositoryImpl(medsLocalDataSource);
    diaryRepository = DiaryRepositoryImpl(diaryLocalDataSource);
    visitsRepository = VisitsRepositoryImpl(visitsLocalDataSource);
    coursesRepository = CoursesRepositoryImpl(coursesLocalDataSource);
    pharmaciesRepository = PharmaciesRepositoryImpl(pharmaciesLocalDataSource);
    profileRepository = ProfileRepositoryImpl(profileLocalDataSource);

    // Initialize Use Cases
    loginUseCase = LoginUseCase(authRepository);
    registerUseCase = RegisterUseCase(authRepository);
    logoutUseCase = LogoutUseCase(authRepository);
    getMedsUseCase = GetMedsUseCase(medsRepository);
    upsertMedUseCase = UpsertMedUseCase(medsRepository);
    deleteMedUseCase = DeleteMedUseCase(medsRepository);
    restoreMedUseCase = RestoreMedUseCase(medsRepository);
    getDayScheduleUseCase = GetDayScheduleUseCase(scheduleRepository);
    markDoseUseCase = MarkDoseUseCase(scheduleRepository);
    setDoseNoteUseCase = SetDoseNoteUseCase(scheduleRepository);
    getDiaryUseCase = GetDiaryUseCase(diaryRepository);
    addDiaryEntryUseCase = AddDiaryEntryUseCase(diaryRepository);
    deleteDiaryEntryUseCase = DeleteDiaryEntryUseCase(diaryRepository);
    getVisitsUseCase = GetVisitsUseCase(visitsRepository);
    addVisitUseCase = AddVisitUseCase(visitsRepository);
    deleteVisitUseCase = DeleteVisitUseCase(visitsRepository);
    getCoursesUseCase = GetCoursesUseCase(coursesRepository);
    addCourseUseCase = AddCourseUseCase(coursesRepository);
    deleteCourseUseCase = DeleteCourseUseCase(coursesRepository);
    getPharmaciesUseCase = GetPharmaciesUseCase(pharmaciesRepository);
    searchPharmaciesUseCase = SearchPharmaciesUseCase(pharmaciesRepository);
    getProfileUseCase = GetProfileUseCase(profileRepository);
    updateProfileUseCase = UpdateProfileUseCase(profileRepository);

    // Initialize Utils
    doseScheduler = DoseScheduler();
  }
}

