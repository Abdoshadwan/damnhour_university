import 'dart:io';
import 'package:damnhour_university/admin/modules/AdminControl/Admincontrol.dart';
import 'package:damnhour_university/admin/modules/AdminHome/AdminHome.dart';
import 'package:damnhour_university/admin/modules/AdminProfile/AdminProfile.dart';
import 'package:damnhour_university/models/getuserlikesModel.dart';
import 'package:damnhour_university/models/home_model.dart';
import 'package:damnhour_university/models/getprofile_info.dart';
import 'package:damnhour_university/models/submit_S_C.dart';
import 'package:damnhour_university/shared/cubit/states.dart';
import 'package:damnhour_university/shared/network/dio.dart';
import 'package:damnhour_university/shared/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../modules/complaints/complaints.dart';
import '../../modules/home/home.dart';
import '../../modules/profile/profile.dart';
import '../../modules/records/records.dart';
import '../components/components.dart';
import '../constants/constants.dart';
import '../styles/colors.dart';

class UniversityCubit extends Cubit<UniversityStates> {
  UniversityCubit() : super(UniversityInitState());

  static UniversityCubit get(context) => BlocProvider.of(context);

  int currentIndex = 3;
  List<Widget> screens = [
    ProfileScreen(),
    RecordsScreen(),
    ComplaintsScreen(),
    HomeScreen(),
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    if (currentIndex == 0) {
      getprofileinfo();
    } else if (currentIndex == 3) {
      getComplaintsAndSuggestions();
    } else if (currentIndex == 2) {
      getUserComplaintsAndSuggestions();
    }

    emit(UniversityChangeBottomNavState());
  }

  bool isEnabled = false;
  void changeSwitch(bool value) {
    ////////////=>>>>>>>>>>>>>>>>>>
    isEnabled = value;
    emit(ChangeSwitchEnabledState());
  }

  /////////////////////// Complaints Form Methods////////////////////////////
  ///
  ///
  Color sectorcolor = Color.fromRGBO(160, 169, 183, 1);
  bool isSectorValid = false;
  void validatesectoronform(String? value) {
    isSectorValid = selectedSector != null;
    if (!isSectorValid) {
      sectorcolor = Color.fromRGBO(255, 1, 43, 1);
    }
    emit(validatesectoronformState());
  }

  void resetbordercolor() {
    sectorcolor = Color.fromRGBO(160, 169, 183, 1);
    emit(validatesectoronformState());
  }

  String? selectedSector;
  void changeSelectedSector(String? value) {
    selectedSector = value;
    emit(SectorChangedState());
  }

  void resetSelectedSector() {
    selectedSector = null;
    emit(SectorChangedState());
  }

  File? pickedfile;
  void attachFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      pickedfile = File(result.files.single.path!);
      emit(ComplaintsFileAttachedState());
    }
  }

  void resetpickedfile() {
    pickedfile = null;
    emit(ComplaintsFileAttachedState());
  }

  File? pickedimage;
  void attachImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      pickedimage = File(image.path);
      print(image.path);

      if (await pickedimage!.exists()) {
        print("Picked image path: ${pickedimage!.path}");
        emit(ComplaintsImageAttachedState());
      } else {
        print("Picked image doesn't exist.");
      }
    }
  }

  String? updateSelectedFaculty;
  void updateFaculty(String? value) {
    updateSelectedFaculty = value;
    //  profilemodel?.faculty = value;
    emit(UniversityChangeFacultyState());
  }

  //Update profile image
  //File? profileImage;

  Submit_S_C_Model? submitmodel;
  void submitComplaint({
    required String title,
    required String description,
    required String sector,
    required String sc_type,
  }) async {
    final filetoupload = pickedfile ?? pickedimage ?? null;
    emit(ComplaintsSubmitLoadingState());
    FormData formData = FormData.fromMap({
      "title": title,
      "sector": sector,
      "description": description,
      "status": 'معلق',
      'sc_type': sc_type,
      if (filetoupload != null)
        "attachments": await MultipartFile.fromFile(
          filetoupload.path,
          filename: filetoupload.path.split('/').last,
        ),
    });
    await Dio_Helper.PostinDB(
          contenttype: 'multipart/form-data',
          data: formData,
          url: submit_s_c,
          token: 'Bearer ${token}',
        )
        .then((value) {
          if (value.data != null && value.data is Map<String, dynamic>) {
            submitmodel = Submit_S_C_Model.fromJson(value.data);
          } else {
            print("Invalid or null response data: ${value.data}");
            return;
          }
          print(filetoupload?.path);
          emit(ComplaintsSubmitSuccessState(submitmodel?.message));
          resetSelectedSector();
        })
        .catchError((error) {
          if (error is DioException &&
              error.response?.data != null &&
              error.response?.data is Map<String, dynamic>) {
            submitmodel = Submit_S_C_Model.fromJson(error.response?.data);
            print(submitmodel?.codeerror.toString());
          }
          print(error.toString());
          emit(ComplaintsSubmitErrorState(submitmodel?.codeerror.toString()));
        });
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //questions
  final List<Map<String, String>> questions = [
    {
      'question': 'كيف أقدّم شكوى؟',
      'answer':
          'من الصفحة الرئيسية، اضغط على "تقديم شكوى"، ثم اختر نوع الشكوى واملأ البيانات المطلوبة، واضغط "إرسال".',
    },
    {
      'question': 'هل يمكن تعديل الشكوى بعد إرسالها؟',
      'answer':
          'من الصفحة الرئيسية، اضغط على "تقديم شكوى"، ثم اختر نوع الشكوى واملأ البيانات المطلوبة، واضغط "إرسال".',
    },
    {
      'question': 'متى يتم الرد على الشكوى؟',
      'answer':
          'من الصفحة الرئيسية، اضغط على "تقديم شكوى"، ثم اختر نوع الشكوى واملأ البيانات المطلوبة، واضغط "إرسال".',
    },
    {
      'question': 'كيف أعرف حالة الشكوى؟',
      'answer':
          'من الصفحة الرئيسية، اضغط على "تقديم شكوى"، ثم اختر نوع الشكوى واملأ البيانات المطلوبة، واضغط "إرسال".',
    },
    {
      'question': 'هل يمكنني تقديم شكوى دون الكشف عن هويتي؟',
      'answer':
          'من الصفحة الرئيسية، اضغط على "تقديم شكوى"، ثم اختر نوع الشكوى واملأ البيانات المطلوبة، واضغط "إرسال".',
    },
    {
      'question': 'ماذا أفعل إذا لم يتم حل الشكوى؟',
      'answer':
          'من الصفحة الرئيسية، اضغط على "تقديم شكوى"، ثم اختر نوع الشكوى واملأ البيانات المطلوبة، واضغط "إرسال".',
    },
  ];
  Map<int, bool> expandedTiles = {};

  void toggleTileExpanded(int index) {
    expandedTiles[index] = !(expandedTiles[index] ?? false);
    emit(ChangeArrowTileExpandedState());
  }

  //helpCenter

  final List<Map<String, Widget>> helpCenter = [
    {
      'question': Row(
        textDirection: TextDirection.rtl,
        children: [
          SvgPicture.asset(
            'assets/images/Phone.svg',
            width: ScreenSize.width * 0.06,
            height: ScreenSize.width * 0.06,
          ),
          SizedBox(width: ScreenSize.width * 0.026),
          TextCairo(
            text: 'كيف أستخدم التطبيق؟',
            color: primary_blue,
            textalign: TextAlign.start,
          ),
        ],
      ),
      'answer': Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [richTextCairoSteps()],
        ),
      ),
    },
    {
      'question': Row(
        textDirection: TextDirection.rtl,
        children: [
          SvgPicture.asset(
            'assets/images/Tips.svg',
            width: ScreenSize.width * 0.06,
            height: ScreenSize.width * 0.06,
          ),
          SizedBox(width: ScreenSize.width * 0.026),
          TextCairo(
            text: 'نصائح لتقديم شكوى فعالة',
            color: primary_blue,
            textalign: TextAlign.start,
          ),
        ],
      ),
      'answer': Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [richTextCairoSteps()],
        ),
      ),
    },
    {
      'question': Row(
        textDirection: TextDirection.rtl,
        children: [
          SvgPicture.asset(
            'assets/images/Tool.svg',
            width: ScreenSize.width * 0.06,
            height: ScreenSize.width * 0.06,
          ),
          SizedBox(width: ScreenSize.width * 0.026),
          TextCairo(
            text: 'الدعم الفني',
            color: primary_blue,
            textalign: TextAlign.start,
          ),
        ],
      ),
      'answer': Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [supportRichTextCairo()],
        ),
      ),
    },
  ];

  Map<int, bool> expandedTilesHelpCenter = {};

  void toggleTileExpandedHelpCenter(int index) {
    expandedTilesHelpCenter[index] = !(expandedTilesHelpCenter[index] ?? false);
    emit(ChangeArrowTileExpandedState());
  }

  //////////////////////////////////////////GET PROFILE INFO/////////////////////////////////////////
  GetProfileModel? profilemodel;
  void getprofileinfo() {
    emit(getprofileinfoLoadingState());
    Dio_Helper.getfromDB(url: getprofile, token: 'Bearer ${token}')
        .then((value) {
          profilemodel = GetProfileModel.fromjson(value.data);
          if (profilemodel?.profile_image != null &&
              profilemodel!.profile_image!.isNotEmpty) {
            String imageUrl = profilemodel!.profile_image!;
            if (!imageUrl.startsWith('http')) {
              imageUrl =
                  'https://damanhourappproject-production.up.railway.app$imageUrl';
            }
            profileImageProvider = NetworkImage(imageUrl);
          } else {
            profileImageProvider = const AssetImage(
              'assets/images/user image1.png',
            );
          }
          initProfileControllers(profilemodel); //=>
          emit(getprofileinfoSuccessState(profilemodel?.message));
          print(profilemodel?.message);
          forprofileadmin();
        })
        .catchError((error) {
          emit(getprofileinfoErrorState(error));
          print(error.toString());
        });
  }

  //////////////////////////////////////////UPDATE PROFILE INFO/////////////////////////////////////////
  void updateProfileImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    File? selectedImage;
    if (image != null) selectedImage = File(image.path);

    updateProfileInfo(
      username: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      faculty: updateSelectedFaculty,
      adjective: statusController.text,
      profileImage: selectedImage,
    );
  }

  // ImageProvider getProfileImage(String? imagePath)
  // {
  //   if (imagePath != null && imagePath.isNotEmpty) {
  //     if (imagePath.startsWith('http')) {
  //       return NetworkImage(imagePath);
  //     } else {
  //       return NetworkImage('https://damanhourappproject-production.up.railway.app$imagePath');
  //     }
  //   } else {
  //     return const AssetImage('assets/images/user image1.png');
  //   }
  // }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  //final universityController = TextEditingController();
  final statusController = TextEditingController();

  void initProfileControllers(GetProfileModel? model) {
    nameController.text = model?.username ?? '';
    emailController.text = model?.email ?? '';
    phoneController.text = model?.phone ?? '';
    //universityController.text = model?.faculty ?? '';
    statusController.text = model?.adjective ?? '';
  }

  void disposeProfileControllers() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    // universityController.dispose();
    statusController.dispose();
  }

  ImageProvider profileImageProvider = const AssetImage(
    'assets/images/user image1.png',
  );
  void updateProfileInfo({
    String? username,
    String? email,
    String? phone,
    String? faculty,
    String? adjective,
    File? profileImage,
  }) async {
    emit(UpdateProfileInfoLoadingState());

    final Map<String, dynamic> formMap = {
      'username':
          (username != null && username.isNotEmpty)
              ? username
              : profilemodel?.username ?? '',
      'email':
          (email != null && email.isNotEmpty)
              ? email
              : profilemodel?.email ?? '',
      'phone':
          (phone != null && phone.isNotEmpty)
              ? phone
              : profilemodel?.phone ?? '',
      'faculty':
          (faculty != null && faculty.isNotEmpty)
              ? faculty
              : profilemodel?.faculty ?? '',
      'adjective':
          (adjective != null && adjective.isNotEmpty)
              ? adjective
              : profilemodel?.adjective ?? '',
    };

    if (profileImage != null) {
      formMap['profile_image'] = await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      );
    }

    FormData formData = FormData.fromMap(formMap);

    Dio_Helper.updateDB(url: getprofile, token: 'Bearer $token', data: formData)
        .then((value) {
          profilemodel = GetProfileModel.fromjson(value.data);
          if (profilemodel?.profile_image != null &&
              profilemodel!.profile_image!.isNotEmpty) {
            String imageUrl = profilemodel!.profile_image!;
            print('value.data');
            print(value.data);

            if (!imageUrl.startsWith('http')) {
              imageUrl =
                  'https://damanhourappproject-production.up.railway.app$imageUrl';
            }
            profileImageProvider = NetworkImage(imageUrl);
          } else {
            profileImageProvider = const AssetImage(
              'assets/images/user image1.png',
            );
          }
          print('profileImageProvider : ${profileImageProvider}');

          emit(UpdateProfileInfoSuccessState(profilemodel?.message));
          print(profilemodel?.message);
        })
        .catchError((error) {
          emit(UpdateProfileInfoErrorState(error.toString()));
          print(error.toString());
        });
  }

  /////////////////////////////////////////ADMIN SECTION/////////////////////////////////////////////

  int admincurrentIndex = 2;
  List<Widget> adminscreens = [AdminProfile(), AdminControl(), AdminHome()];

  void adminchangeBottomNav(int index) {
    admincurrentIndex = index;
    if (admincurrentIndex == 0) {
      getprofileinfo();
    } else if (admincurrentIndex == 2) {
      getComplaintsAndSuggestions();
    }
    emit(AdminUniversityChangeBottomNavState());
  }

  updateComplaintModel? updates_c_model;
  void updateS_C({
    required String id,
    String? response,
    String? status,
    required String? type_S_C,
  }) async {
    emit(updateS_CLoadingState());
    await Dio_Helper.updateDB(
          data: {'status': status, 'response': response},
          url: type_S_C == 'شكوى' ? 'complaint/${id}/' : 'suggestion/${id}/',
          token: 'Bearer ${token}',
        )
        .then((value) {
          if (value.data != null && value.data is Map<String, dynamic>) {
            updates_c_model = updateComplaintModel.fromJson(value.data);
          } else {
            print("Invalid or null response data: ${value.data}");
            return;
          }
          emit(updateS_CSuccessState(updates_c_model?.message));
        })
        .catchError((error) {
          updates_c_model = updateComplaintModel.fromJson(error.response?.data);
          // print(updates_c_model?.codeerror.toString());
          print('${status}   ${response}    ${id}');
          print(error.toString());
          emit(updateS_CErrorState(updates_c_model?.codeerror.toString()));
        });
  }

  String? selectedstatus;
  void changeselectedstatus(String? value) {
    selectedstatus = value;
    emit(statusChangedState());
  }

  void resetselectedstatus() {
    selectedstatus = null;
    statusBorderColor = Color.fromRGBO(160, 169, 183, 1);
    emit(statusChangedState());
  }

  bool isStatusValid = false;
  Color statusBorderColor = Color.fromRGBO(160, 169, 183, 1);
  bool validateStatus() {
    isStatusValid = selectedstatus != null;
    if (isStatusValid) {
      statusBorderColor = Color.fromARGB(255, 1, 187, 63);
      ;
      emit(validateStatusState());
      return true;
    } else {
      statusBorderColor = Color.fromRGBO(255, 1, 43, 1);
      ;
      emit(validateStatusState());
      return false;
    }
  }

  deleteS_CModel? deleteModel;
  void deleteS_C({required String id, required String? type_S_C}) {
    emit(deleteS_CLoadingState());
    Dio_Helper.delete(
          url: type_S_C == 'شكوى' ? 'complaint/${id}/' : 'suggestion/${id}/',
          token: 'Bearer ${token}',
        )
        .then((value) {
          emit(deleteS_CSuccessState());
        })
        .catchError((error) {
          if (error is DioException)
            deleteModel = deleteS_CModel.fromJson(error.response?.data);
          print(error.toString());
          emit(
            deleteS_CErrorState(deleteModel?.codeerror ?? deleteModel?.message),
          );
        });
  }

  // Color getcolorstatuscomplaint({String? statusonmodel}) {
  //   if (statusonmodel == 'قيد التنفيذ') {
  //     return brandColor200;
  //   }
  //   return brandColor200;
  // }
  //////////////////////////////////////////////Detect attachments type//////////////////////////////////////
  String getFileExtension(String? file) {
    if (file == null || file.isEmpty) return '';
    return file.split('.').last.toLowerCase(); // e.g. "pdf", "docx"
  }

  String getFileType(String? file) {
    String ext = getFileExtension(file);

    switch (ext) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'Word';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'Image';
      case 'mp4':
      case 'avi':
        return 'Video';
      default:
        return 'Unknown';
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////get all Complaints ////////////////////////
  List<ItemModel> allComplaints = [];
  List<ItemModel> filteredComplaints = [];

  Future<void> getUserComplaintsAndSuggestions() async {
    List<ItemModel> complaintsList = await getUserComplaints();
    List<ItemModel> suggestionsList = await getUserSuggestions();
    getUserComplaints();
    getUserSuggestions();
    allComplaints = [...complaintsList, ...suggestionsList]
      ..sort((a, b) => b.createdAtDate!.compareTo(a.createdAtDate!));
    emit(GetComplaintsAndSuggestionsLoadingState());

    filterComplaintsBySector('الكل');
  }

  Future<List<ItemModel>> getUserComplaints() async {
    emit(GetComplaintsLoadingState());

    try {
      final complaintsResponse = await Dio_Helper.getfromDB(
        url: COMPLAINTS,
        token: 'Bearer $token',
      );
      final complaintsList =
          (complaintsResponse.data as List)
              .map((e) => ItemModel.fromJson(e))
              .toList();

      emit(GetComplaintsSuccessState());
      return complaintsList;
    } catch (error) {
      emit(GetComplaintsErrorState(error.toString()));
      print('Error loading complaints: $error');
      return [];
    }
  }

  Future<List<ItemModel>> getUserSuggestions() async {
    emit(GetSuggestionsLoadingState());

    try {
      final suggestionsResponse = await Dio_Helper.getfromDB(
        url: SUGGESTIONS,
        token: 'Bearer $token',
      );
      final suggestionsList =
          (suggestionsResponse.data as List)
              .map((e) => ItemModel.fromJson(e))
              .toList();

      emit(GetSuggestionsSuccessState());
      return suggestionsList;
    } catch (error) {
      emit(GetSuggestionsErrorState(error.toString()));
      print('Error loading suggestions: $error');
      return [];
    }
  }

  void filterComplaintsBySector(String sectorName) {
    print('Filtering complaints for $sectorName');

    if (sectorName == 'الكل') {
      filteredComplaints = allComplaints;
    } else {
      filteredComplaints =
          allComplaints
              .where((complaint) => complaint.sector == sectorName)
              .toList();
    }
    filteredComplaintsByStatus();
    emit(FilterComplaintsBySectorChangedState());
  }

  List<ItemModel> activeComplaintsAndSuggestions = []; //شكاوي
  List<ItemModel> archiveComplaintsAndSuggestions = []; // سجل

  // filter for complaints by status
  void filteredComplaintsByStatus() {
    activeComplaintsAndSuggestions = [];
    archiveComplaintsAndSuggestions = [];

    for (var complaint in filteredComplaints) {
      if (complaint.status == 'معلق' || complaint.status == 'قيد التنفيذ') {
        activeComplaintsAndSuggestions.add(complaint);
      } else if (complaint.status == 'مرفوض' || complaint.status == 'تم الحل') {
        archiveComplaintsAndSuggestions.add(complaint);
      }
    }
    emit(FilterComplaintsByStatusSuccessState());
  }

  /////////////////////////////get all posts///////////////////////////////
  List<ItemModel> allPosts = []; //كل ال posts
  List<ItemModel> filteredPosts = []; // حسب كل sector
  FeedBackModel? feedBackModel;
  Future<void> getComplaintsAndSuggestions() async {
    emit(GetAllComplaintsAndSuggestionsLoadingState());

    Dio_Helper.getfromDB(url: FEEDBACK, token: 'Bearer $token')
        .then((value) {
          feedBackModel = FeedBackModel.fromJson(value.data);
          allPosts =
              (feedBackModel?.data ?? [])
                ..sort((a, b) => b.createdAtDate!.compareTo(a.createdAtDate!));
          filteredPosts = allPosts;
          filteredPostsByStatus();
          emit(GetAllComplaintsAndSuggestionsSuccessState());
        })
        .catchError((error) {
          emit(GetAllComplaintsAndSuggestionsErrorState(error.toString()));
          print('error is : ');
          print(filteredPostsbystatus);
          print(error.toString());
        });
  }

  List<ItemModel> repliedPosts = [];
  void filteredPostsByStatus() {
    repliedPosts = [];

    for (var complaint in filteredPosts) {
      if (complaint.status == 'تم الحل') repliedPosts.add(complaint);
    }
    filteredPostsbystatus = filteredPosts;
    // filteredPostsbystatus =
    //     repliedPosts; //=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    emit(FilterPostsByStatusSuccessState());
  }

  void filterPostsBySector(String sectorName) {
    if (sectorName == 'الكل') {
      filteredPosts = allPosts;
    } else {
      filteredPosts =
          allPosts.where((post) => post.sector == sectorName).toList();
    }

    filteredPosts.sort((a, b) => b.createdAtDate!.compareTo(a.createdAtDate!));

    filteredPostsByStatus();

    emit(FilterBySectorChangedState());
  }

  List<ItemModel> searchedPosts = []; // بوستات ناتج البحث

  void filterPostsBySearch(String text) {
    if (text.isEmpty) {
      searchedPosts = [];
    } else {
      final lowerText = text.toLowerCase();

      searchedPosts =
          allPosts.where((post) {
            final matchesText =
                post.title?.toLowerCase().contains(lowerText) == true ||
                post.description?.toLowerCase().contains(lowerText) == true;
            final isResolved = post.status == 'تم الحل';

            return matchesText && isResolved;
          }).toList();
    }

    emit(FilterPostsBySearchState());
  }

  //ليست متفلتره قطاعات و الحاله
  List<ItemModel> filteredPostsbystatus = [];
  String? searchId;
  void updateSearchId(String? value) {
    searchId = value;
    filterPostsBySectorandstatus();
  }

  void filterPostsBySectorandstatus({String? status = ''}) {
    if (status != null && status.isNotEmpty) {
      filteredPostsbystatus =
          filteredPosts.where((post) => post.status == status).toList();
    } else if (status == null || searchId != null) {
      filteredPostsbystatus =
          allPosts
              .where((post) => post.id.toString().contains(searchId!))
              .toList();
    }
    emit(FilterBySectorChangedState());
  }

  ///////////////////for profile admin///////////////
  List<ItemModel> repliedS_C = [];
  List<ItemModel> pendingS_C = [];
  void forprofileadmin() {
    pendingS_C = allPosts.where((post) => post.status == 'معلق').toList();
    repliedS_C = allPosts.where((post) => post.status == 'تم الحل').toList();
    emit(ForprofileadminChangedState());
  }

  /////////////////////////change sector index//////////////////////////////
  int sectorIndex = 0;
  void changeSectorIndex(int index) {
    sectorIndex = index;
    emit(ChangeSectorIndexState());
  }

  /////////////////////like and dislike////////////////////////////

  Future<void> changelike(ItemModel model) async {
    emit(changelikedislikeState());
    getUserReactions();
    final reactionId = getReactionIdByPostanduser(model.id, userId);

    if (reactionId != null) {
      final existingReaction = userlikes!.firstWhere(
        (r) => r.id == reactionId && r.S_cId == model.id && r.user == userId,
      );

      if (existingReaction.type == 'لا يعجبني') {
        updateReaction(postId: model.id, userId: userId, isLike: true);
        model.islike = true;
        model.isdislike = false;

        model.like_count = (model.like_count ?? 0) + 1;
        model.dislike_count =
            ((model.dislike_count ?? 0) - 1).clamp(0, double.infinity).toInt();
      } else if (existingReaction.type == 'اعجبني') {
        // اضغط مرة تانية لإلغاء اللايك
        removeReaction(model.id, userId);
        model.islike = false;

        model.like_count =
            ((model.like_count ?? 0) - 1).clamp(0, double.infinity).toInt();
      }
    } else {
      // أول مرة يدوس لايك
      addLikeDislike(idofpost: model.id, isLike: true);
      model.islike = true;
      model.dislike_count = model.dislike_count; // no change
      model.like_count = (model.like_count ?? 0) + 1;
    }
    getUserReactions();
    emit(changelikedislikeState());
  }

  Future<void> changedisdislike(ItemModel model) async {
    emit(changelikedislikeState());
    getUserReactions();
    final reactionId = getReactionIdByPostanduser(model.id, userId);

    if (reactionId != null) {
      final existingReaction = userlikes!.firstWhere(
        (r) => r.id == reactionId && r.S_cId == model.id && r.user == userId,
      );

      if (existingReaction.type == 'اعجبني') {
        updateReaction(postId: model.id, userId: userId, isLike: false);
        model.isdislike = true;
        model.islike = false;

        model.dislike_count = (model.dislike_count ?? 0) + 1;
        model.like_count =
            ((model.like_count ?? 0) - 1).clamp(0, double.infinity).toInt();
      } else if (existingReaction.type == 'لا يعجبني') {
        // اضغط مرة تانية لإلغاء الديسلايك
        removeReaction(model.id, userId);
        model.isdislike = false;

        model.dislike_count =
            ((model.dislike_count ?? 0) - 1).clamp(0, double.infinity).toInt();
      }
    } else {
      addLikeDislike(idofpost: model.id, isLike: false);
      model.isdislike = true;
      model.like_count = model.like_count; // no change
      model.dislike_count = (model.dislike_count ?? 0) + 1;
    }
    getUserReactions();
    emit(changelikedislikeState());
  }

  List<UserLikes>? userlikes;
  void addLikeDislike({required int? idofpost, required bool isLike}) async {
    emit(addlikeanddislikeloadingState());

    final type = isLike ? 'اعجبني' : 'لا يعجبني';

    await Dio_Helper.PostinDB(
          data: {'sc_type': '$idofpost', 'type': '$type'},
          url: Reactions,
          token: 'Bearer ${token}',
        )
        .then((value) {
          List<dynamic> jsonList = value.data;
          if (jsonList.isNotEmpty) {
            final newReaction = UserLikes.fromJson(jsonList[0]);
            userlikes ??= [];
            userlikes!.add(newReaction);
          }

          emit(addlikeanddislikesuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(addlikeanddislikeerrorState());
        });
  }

  void updateReaction({
    required int? postId,
    required int? userId,
    required bool isLike, // true = اعجبني, false = لا يعجبني
  }) async {
    emit(updatereactionloadingState());

    final reactionId = getReactionIdByPostanduser(postId, userId);
    if (reactionId == null) {
      print("Reaction not found for post ID $postId and user ID $userId");
      emit(updatereactionerrorState());
      return;
    }

    final type = isLike ? 'اعجبني' : 'لا يعجبني';

    await Dio_Helper.updateDB(
          url: '$Reactions/$reactionId/',
          data: {'type': type},
          token: 'Bearer $token',
        )
        .then((value) {
          print('Reaction updated to $type');
          emit(updatereactionsuccessState());
        })
        .catchError((error) {
          print('Error while updating reaction: $error');
          emit(updatereactionerrorState());
        });
  }

  void getUserReactions() async {
    emit(getuserreactionsloadingState());

    await Dio_Helper.getfromDB(url: Reactions, token: 'Bearer $token')
        .then((value) {
          List<dynamic> jsonList = value.data;
          userlikes = jsonList.map((item) => UserLikes.fromJson(item)).toList();
          emit(getuserreactionssuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(getuserreactionserrorState());
        });
  }

  int? getReactionIdByPostanduser(int? postId, int? userId) {
    try {
      final reaction = userlikes?.firstWhere(
        (reaction) => reaction.S_cId == postId && reaction.user == userId,
      );
      print("Found reaction: ${reaction?.id}");
      return reaction?.id;
    } catch (e) {
      print("Reaction not found. Error: $e");
      return null; // if not found
    }
  }

  void removeReaction(int? postId, int? userId) async {
    emit(removereactionloadingState());
    final reactionId = getReactionIdByPostanduser(postId, userId);
    if (reactionId == null) {
      print("Reaction not found for post ID$postId and user id$userId");
      return;
    }
    await Dio_Helper.delete(
          url: '${Reactions}/$reactionId/',
          token: 'Bearer $token',
        )
        .then((value) {
          print('Reaction deleted');
          emit(removereactionsuccessState());
        })
        .catchError((error) {
          print(error.toString());
          emit(removereactionerrorState());
        });
  }

  //////////////////////////////////////////////////Finish Like and Dislike/////////////////////////////////////////////////////////
}
