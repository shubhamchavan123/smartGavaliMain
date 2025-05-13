import 'package:flutter/foundation.dart';

const _protocol = 'https';

/// QA Api
const _productionBaseUrl = 'devapi.kbpro.in';

///for dev
const _debugBaseUrl = 'hrms.kenerp.com';


const _loginPathNew = '/api/employeeLoginNew';

const _updateBasicInfoPath = '/api/update_basic_information';

///profile basic info prefix dropdown API //pratik
const _getPrefixpath = '/api/get_prefix';

///profile basic info blood group dropdown API //pratik
const _getBloodGroupPath = '/api/get_blood_group';

///profile basic info countries dropdown API //pratik
const _getCountriesPath = '/api/get_countries';

///Profile basic info gender Dropdown API
const _getGenderPath = '/api/get_gender';

///Profile basic info isd dropdown API
const _getIsdPath = '/api/get_isd';

///profile personal info update API
const _getPersonalInfoUpdatePath = '/api/update_personal_information';

///profile personal info states dropdown API
const _getStatesPath = '/api/get_states';

///Query ticket -> self ticket -> get ticket by date API
const _getTicketByDate = '/api/get_ticket_raise_list';

///Query ticket -> self ticket -> get ticket by dat
const _getIssueListPath = '/api/issueList';

///Query ticket -> self ticket -> raise ticket
const _getRaiseTicketPath = '/api/ticketRaise';

///Query ticket -> self ticket -> raise ticket
const _getUpdateTicketPath = '/api/updateTicketRaise';

///Approve ticket -> 3 tabs approve ,rejected ,accepted
const _getTicketRaiseListByManagerPath = '/api/ticket_raise_list_by_manager';

///Query ticket -> self ticket -> delete ticket
const _getDeleteRaisedTicketPath = '/api/deleteTicketRaise';

const _getRaisedTicketByIDPath = '/api/get_ticket_raise_by_id';

const _getApproveTicketPath = '/api/approve_ticket';

///dropdown of attendance status in raised ticket
const _getAttendanceStatusByManagerPath = 'api/attendance_status_list';

///forgot password path
const _getForgotPasswordPath = '/api/forgotPassword';

///dashboard notification list
const _notificationlistPath = '/api/getNotificationList';

/// dashboard attendace Count API
const _getDashboardPath = '/api/attendaceCount';

///attendaceListByMonth api
const _getDashboardListMonthPath = '/api/attendaceListByMonth';

///getSliders api
const _getSlidersPath = '/api/getSliders';

///getworkTypeList api
const _getWorkTypeListDropdownPath = '/api/workTypeList';

///dashboard notification list details
const _notificationdetailPath = '/api/getNotificationDetail';

///get profile1
const _getProfile1Path = '/api/getProfile';

///dropdown of location list in km reading.
const _getLocationPath = 'api/locationList';

///dropdown of travel list in km reading.
const _getTravelPath = '/api/modeOfTravelling';

///dropdown of travel list in km reading.
const _getWorkPath = '/api/workTypeList';

/// get Api of letter.
const _getLetterPath = '/api/get_letters';

/// get Api of changePassword.
const _getChangePasswordPath = '/api/changePassword';

/// get Api of otpSuccess.
const _getOtpSuccessPath = '/api/otpSuccess';

///dashboard holiday calender
const _holidayPath = '/api/getHolidays';

///dashboard _yesterdayattendance
const _yesterdayattendancePath = '/api/getWorkDuration';

///dashboard _leavebalance
const _leavebalancePath = '/api/getleaveBalance';

/// get api of selfie attendance
const _getSelfieattendancePath = '/api/addSelfieAttendance';

/// get api of OcrAttendaceList
const _getOcrAttendaceListPath = '/api/OcrAttendaceListNew';

/// get api of attendaceList
const _getattendaceListPath = '/api/attendaceList';

/// get api of OCR by Id
const _getOcrByID = '/api/getOcrAttendaceByIdNew';

/// get api of OCR attendence by Id
const _getAddOcrAttendance = '/api/AddOcrAttendance';

/// get api of dayClose
const _getDayClose = '/api/dayClose';

///get api of WorkDurationBydate
const _getWorkDurationByDatePath = '/api/getWorkDurationByDate';

///get api of WorkshortleaveDuration
const _getShortLeaveDurationPath = '/api/get_short_leave_duration';

///get api of updateocrattendance
const _getUpdateOcrAttendancePath = '/api/updateOcrAttendanceNew';


///get api of updatedocument
const _getUpdateDocumentPath = '/api/update_document';

/// get api of update fcm token
const _getUpdateFCMTokenPath = '/api/updateFcmToken';

/// get api of out_door_travelling
const _getOutdoortravellingPath = '/api/get_out_door_travelling';

/// get api of out_door_travelling_detail
const _getOutdoortravellingdetailPath = '/api/get_out_door_travelling_detail';

/// get api of out_door_travelling_detail
const _getStoreoutdoorbillsPath = '/api/store_out_door_bills';

///get api of salaryslip
const _getSalarySlipPath = '/rpt_salary_slip_new';

const _getLeaveReportPath = '/api/get_leave_coff_by_date';

///get api of pl balance
const _getPlBalancePath = '/api/getleaveBalanceNew';

///get api of coff balance
const _getCoffBalancePath = '/api/getCoffBalance';
///get api of family screen
const _getFamilyPath = '/api/update_family_information';





class BaseUrl {
  /// Base URL
  static String get baseUrl {
    if (kReleaseMode) {
      return _debugBaseUrl;
    } else {
      return _debugBaseUrl;
    }
  }


  ///getfamilyinfo
  static String get getFamilyByDomain {
    return _getFamilyPath;
  }

  /// Protocol
  static String get getProtocol {
    return _protocol;
  }

  /// update fcm Url Path
  static String get updateFCMDomain {
    return _getUpdateFCMTokenPath;
  }

  /// Login Url Path
  static String get loginDomain {
    return _loginPathNew;
  }

  /// updateBasicInfoPath Url Path
  static String get updateBasicInfoDomain {
    return _updateBasicInfoPath;
  }

  ///profile basic info prefix dropdown API //pratik
  static String get getPrefixDomain {
    return _getPrefixpath;
  }

  ///profile basic info blood group dropdown API //pratik
  static String get getBloodGroupDomain {
    return _getBloodGroupPath;
  }

  ///profile basic info countries dropdown API //pratik
  static String get getCountriesDomain {
    return _getCountriesPath;
  }

  ///profile basic info countries dropdown API //pratik
  static String get getGenderDomain {
    return _getGenderPath;
  }

  ///profile basic info isd dropdown API
  static String get getIsdDomain {
    return _getIsdPath;
  }

  ///profile personal info update API
  static String get getPersonalInfoUpdateDomain {
    return _getPersonalInfoUpdatePath;
  }

  ///states dropdown API
  static String get getStatesDomain {
    return _getStatesPath;
  }

  ///get self ticket raise list API
  static String get getTicketsByDateDomain {
    return _getTicketByDate;
  }

  ///get ticket issue list API
  static String get getRaiseTicketIssueListDomain {
    return _getIssueListPath;
  }

  ///get raise ticket API
  static String get getRaiseTicketDomain {
    return _getRaiseTicketPath;
  }

  ///get ticket raise list by manager
  static String get getTicketRaiseListDomain {
    return _getTicketRaiseListByManagerPath;
  }

  ///get delete raised ticket domain
  static String get getDeleteRaisedTicketDomain {
    return _getDeleteRaisedTicketPath;
  }

  ///get update ticket API
  static String get getUpdateTicketDomain {
    return _getUpdateTicketPath;
  }

  static String get getTicketByIDDomain {
    return _getRaisedTicketByIDPath;
  }

  static String get getApproveTicketDomain {
    return _getApproveTicketPath;
  }

  ///get ticket raise list dropdown of attendance_status_list
  static String get getAttendanceStatusDomain {
    return _getAttendanceStatusByManagerPath;
  }

  ///get ticket raise list dropdown of attendance_status_list
  static String get getForgotPasswordDomain {
    return _getForgotPasswordPath;
  }

  /// dashboard attendaceCount API
  static String get getDashboardDomain {
    return _getDashboardPath;
  }

  ///get attendaceListByMonth API
  static String get getDashboardListMonthDomain {
    return _getDashboardListMonthPath;
  }

  ///get getSliders API
  static String get getSlidersDomain {
    return _getSlidersPath;
  }

  ///get getworkTypeList API
  static String get getWorkTypeListDropdownDomain {
    return _getWorkTypeListDropdownPath;
  }

  /// Notification List Details Url Path
  static String get notificationdetailDomain {
    return _notificationdetailPath;
  }

  ///get ticket raise list dropdown of attendance_status_list
  static String get getProfile1Domain {
    return _getProfile1Path;
  }

  /// Notification List Url Path
  static String get notificationlistDomain {
    return _notificationlistPath;
  }

  ///get location list dropdownin km reading
  static String get getLocationDomain {
    return _getLocationPath;
  }

  ///get travellist dropdownin km reading
  static String get getTravelDomain {
    return _getTravelPath;
  }

  ///get workTypeList dropdown in km reading
  static String get getWorkDomain {
    return _getWorkPath;
  }

  ///get letter tab
  static String get getLetterDomain {
    return _getLetterPath;
  }

  ///get changePassword tab
  static String get getChangePasswordDomain {
    return _getChangePasswordPath;
  }

  ///get otpSuccess tab
  static String get getOtpSuccessDomain {
    return _getOtpSuccessPath;
  }

  /// Holiday Url Path
  static String get holidayDomain {
    return _holidayPath;
  }

  /// yesterdayattendance Url Path
  static String get yesterdayattendanceDomain {
    return _yesterdayattendancePath;
  }

  /// getleavebalance Url Path
  static String get leavebalanceDomain {
    return _leavebalancePath;
  }

  ///get selfie attendance
  static String get getSelfieAttendanceDomain {
    return _getSelfieattendancePath;
  }

  ///get OcrAttendaceList
  static String get getOcrAttendaceListDomain {
    return _getOcrAttendaceListPath;
  }

  ///get attendaceList
  static String get getattendaceListDomain {
    return _getattendaceListPath;
  }

  ///get ocr by id
  static String get getOcrByID {
    return _getOcrByID;
  }

  ///get AddOcrAttendance
  static String get getAddOcrAttendance {
    return _getAddOcrAttendance;
  }

  ///get dayClose
  static String get getDayClose {
    return _getDayClose;
  }

  ///getWorkDurationBydate
  static String get getWorkDurationByDateDomain {
    return _getWorkDurationByDatePath;
  }

  ///getleaveDuration
  static String get getShortLeaveDurationByDomain {
    return _getShortLeaveDurationPath;
  }

  ///getupdateocrattendance
  static String get getUpdateOcrAttendanceByDomain {
    return _getUpdateOcrAttendancePath;
  }

  ///getupdatedocument
  static String get getUpdateDocumentByDomain {
    return _getUpdateDocumentPath;
  }

  ///_getoutdoortravelling
  static String get getOutdoortravelling {
    return _getOutdoortravellingPath;
  }

  ///getOutdoortravellingdetail
  static String get getOutdoortravellingdetail {
    return _getOutdoortravellingdetailPath;
  }

  ///getStoreoutdoorbills
  static String get getStoreoutdoorbills {
    return _getStoreoutdoorbillsPath;
  }

  ///getsalaryslip
  static String get getSalarySlipByDomain {
    return _getSalarySlipPath;
  }

  ///getplbalance
  static String get getPlBalanceByDomain {
    return _getPlBalancePath;
  }
  static String get getLeaveReportPath {
    return _getLeaveReportPath;
  }




  ///getCoffBalance
  static String get getCoffBalanceByDomain {
    return _getCoffBalancePath;
  }
}
