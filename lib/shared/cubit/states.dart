class UniversityStates {}

class UniversityInitState extends UniversityStates {}

class UniversityChangeBottomNavState extends UniversityStates {}

class AdminUniversityChangeBottomNavState extends UniversityStates {}

class ChangeSwitchEnabledState extends UniversityStates {}

// Complaints Form States
class SectorChangedState extends UniversityStates {}

class ComplaintsFileAttachedState extends UniversityStates {}

class ComplaintsImageAttachedState extends UniversityStates {}

class ComplaintsDrawingAttachedState extends UniversityStates {}

class ComplaintsSubmitLoadingState extends UniversityStates {}

class UpdateProfileImageSuccessState extends UniversityStates {}

class ComplaintsSubmitSuccessState extends UniversityStates {
  var message;
  ComplaintsSubmitSuccessState(this.message);
}

class ComplaintsSubmitErrorState extends UniversityStates {
  var error;
  ComplaintsSubmitErrorState(this.error);
}

//questions
class ChangeArrowTileExpandedState extends UniversityStates {}

class validatesectoronformState extends UniversityStates {}

//get all complaints and suggestions (feedBack)
class GetAllComplaintsAndSuggestionsLoadingState extends UniversityStates {}

class GetAllComplaintsAndSuggestionsSuccessState extends UniversityStates {}

class GetAllComplaintsAndSuggestionsErrorState extends UniversityStates {
  var error;
  GetAllComplaintsAndSuggestionsErrorState(this.error);
}

class GetComplaintsAndSuggestionsLoadingState extends UniversityStates {}

class GetComplaintsAndSuggestionsSuccessState extends UniversityStates {}

class GetComplaintsAndSuggestionsErrorState extends UniversityStates {
  var error;
  GetComplaintsAndSuggestionsErrorState(this.error);
}

class GetComplaintsLoadingState extends UniversityStates {}

class GetComplaintsSuccessState extends UniversityStates {}

class GetComplaintsErrorState extends UniversityStates {
  var error;
  GetComplaintsErrorState(this.error);
}

class GetSuggestionsLoadingState extends UniversityStates {}

class GetSuggestionsSuccessState extends UniversityStates {}

class GetSuggestionsErrorState extends UniversityStates {
  var error;
  GetSuggestionsErrorState(this.error);
}

class FilterComplaintsBySectorChangedState extends UniversityStates {}

class FilterBySectorChangedState extends UniversityStates {}

class ChangeSectorIndexState extends UniversityStates {}

class getprofileinfoLoadingState extends UniversityStates {}

class getprofileinfoSuccessState extends UniversityStates {
  var message;
  getprofileinfoSuccessState(this.message);
}

class getprofileinfoErrorState extends UniversityStates {
  var error;
  getprofileinfoErrorState(this.error);
}

class UpdateProfileInfoLoadingState extends UniversityStates {}

class UpdateProfileInfoSuccessState extends UniversityStates {
  var message;
  UpdateProfileInfoSuccessState(this.message);
}

class UpdateProfileInfoErrorState extends UniversityStates {
  var error;
  UpdateProfileInfoErrorState(this.error);
}

class updateS_CLoadingState extends UniversityStates {}

class updateS_CSuccessState extends UniversityStates {
  var message;
  updateS_CSuccessState(this.message);
}

class updateS_CErrorState extends UniversityStates {
  var error;
  updateS_CErrorState(this.error);
}

class statusChangedState extends UniversityStates {}

class validateStatusState extends UniversityStates {}

class deleteS_CLoadingState extends UniversityStates {}

class deleteS_CSuccessState extends UniversityStates {}

class deleteS_CErrorState extends UniversityStates {
  var error;
  deleteS_CErrorState(this.error);
}

class ForprofileadminChangedState extends UniversityStates {}

class UniversityChangeFacultyState extends UniversityStates {}

class FilterComplaintsByStatusSuccessState extends UniversityStates {}

class FilterPostsByStatusSuccessState extends UniversityStates {}

class FilterPostsBySearchState extends UniversityStates {}

class changelikedislikeState extends UniversityStates {}

class GetNotificationsLoadingState extends UniversityStates {}
class GetNotificationsSuccessState extends UniversityStates {}
class GetNotificationsErrorState extends UniversityStates {
  var error;
  GetNotificationsErrorState(this.error);
}

class DeleteNotificationsLoadingState extends UniversityStates {}
class DeleteNotificationsSuccessState extends UniversityStates {}
class DeleteNotificationsErrorState extends UniversityStates {
  var error;
  DeleteNotificationsErrorState(this.error);
}

class UpdateNotificationsLoadingState extends UniversityStates {}
class UpdateNotificationsSuccessState extends UniversityStates {}
class UpdateNotificationsErrorState extends UniversityStates {
  var error;
  UpdateNotificationsErrorState(this.error);
}