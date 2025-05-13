
import 'package:smart_gawali/networking_model/api_base_model/base_url.dart';

/// Builds the URL
class URIBuilder {
  /// Get Curated Matches list
  getHeaderWithToken({required String token}) {
    return {
      'Authorization': token,
      'Content-Type': 'application/json',
    };
  }

  getApiEndPointHeaderContentType() {
    return {
      'Content-Type': 'application/json',
    };
  }

  /// Login URI
  /// he method url crete karun deyel
  /// https://hrms.kenerp.com/api/employeeLogin
  Uri getUpdateFCMUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.updateFCMDomain,
    );
  }

  /// Login URI

  /// https://hrms.kenerp.com/api/employeeLogin
  Uri getLoginUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.loginDomain,
    );
  }


  /// https://hrms.kenerp.com/api/updatefamily
  Uri getFamilyUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getFamilyByDomain);
  }


  /// ProfileUpdate URI

  /// https://hrms.kenerp.com/api/employeeLogin
  Uri getProfileUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.updateBasicInfoDomain,
    );
  }

  /// get prefix URI

  /// https://hrms.kenerp.com/api/get_prefix
  Uri getPrefixUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getPrefixDomain);
  }

  /// get blood group URI

  /// https://hrms.kenerp.com/api/get_blood_group
  Uri getBloodGroupUrl() {
    return Uri(
        path: BaseUrl.getBloodGroupDomain,
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl);
  }

  /// get Countries  URI

  /// https://hrms.kenerp.com/api/get_countries
  Uri getCountriesUrl() {
    return Uri(
        host: BaseUrl.baseUrl,
        path: BaseUrl.getCountriesDomain,
        scheme: BaseUrl.getProtocol);
  }

  /// get Gender  URI

  /// https://hrms.kenerp.com/api/get_countries
  Uri getGenderUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        path: BaseUrl.getGenderDomain,
        host: BaseUrl.baseUrl);
  }

  /// get Gender  URI

  /// https://hrms.kenerp.com/api/get_countries
  Uri getIsdUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getIsdDomain);
  }

  /// get personal info update  URI

  /// https://hrms.kenerp.com/api/update_personal_information
  Uri getPersonalInfoUpdateUrl() {
    return Uri(
        path: BaseUrl.getPersonalInfoUpdateDomain,
        host: BaseUrl.baseUrl,
        scheme: BaseUrl.getProtocol);
  }

  /// states  URI

  /// https://hrms.kenerp.com/api/get_states
  Uri getStatesUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getStatesDomain);
  }

  /// get tickets by date  URI

  /// https://hrms.kenerp.com/api/get_ticket_raise_list
  Uri getTicketsByDateUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getTicketsByDateDomain);
  }

  /// get raise ticket issue list

  /// https://hrms.kenerp.com/api/issueList
  Uri getRaiseTicketIssueListUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getRaiseTicketIssueListDomain);
  }

  /// get raise ticket url

  /// https://hrms.kenerp.com/api/ticketRaise
  Uri getRaiseTicketUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getRaiseTicketDomain);
  }

  /// get raise ticket url

  /// https://hrms.kenerp.com/api/ticketRaise
  Uri getTicketListByManagerUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getTicketRaiseListDomain);
  }

  /// get delete ticket url

  /// https://hrms.kenerp.com/api/deleteTicketRaise
  Uri getDeleteRaisedTicketUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getDeleteRaisedTicketDomain);
  }

  /// get dashboard URI

  /// https://hrms.kenerp.com/api/attendaceCount
  Uri getDashboardUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getDashboardDomain);
  }

  /// get Dashboardlistmonth  URI

  /// https://hrms.kenerp.com/api/attendaceListByMonth
  Uri getDashboardListMonthUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getDashboardListMonthDomain);
  }

  /// getSliders  URI

  /// https://hrms.kenerp.com/api/getSliders
  Uri getSlidersUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getSlidersDomain);
  }

  /// workTypeList  URI

  /// https://hrms.kenerp.com/api/workTypeList
  Uri getWorkTypeListDropdownUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getWorkTypeListDropdownDomain);
  }

  /// get raise ticket  dropdown of attendance status url

  ///https://hrms.kenerp.com/api/forgotPassword
  Uri getForgotPasswordUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getForgotPasswordDomain);
  }

  /// get profile  URI

  /// https://hrms.kenerp.com/api/getProfile
  Uri getProfile1Url() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getProfile1Domain);
  }

  /// get update ticket url

  /// https://hrms.kenerp.com/api/updateTicketRaise
  Uri getUpdateTicketUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getUpdateTicketDomain);
  }

  /// get update ticket url

  /// https://hrms.kenerp.com/api/updateTicketRaise
  Uri getTicketByIDUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getTicketByIDDomain);
  }

  /// get update ticket url

  Uri getApproveTicketUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getApproveTicketDomain);
  }

  /// get raise ticket  dropdown of attendance status url

  ///https://hrms.kenerp.com/api/attendance_status_list
  Uri getAttendanceStatusUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getAttendanceStatusDomain);
  }

  /// Notificationlist URI

  /// https://hrms.kenerp.com/api/getNotificationList
  Uri getNotificationlistUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.notificationlistDomain,
    );
  }

  /// Notificationlist URI

  /// https://hrms.kenerp.com/api/getNotificationList
  Uri getNotificationdetailUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.notificationdetailDomain,
    );
  }

  /// get location list url

  ///https://hrms.kenerp.com/api/locationList
  Uri getLocationUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getLocationDomain);
  }

  /// get travel list url

  ///https://hrms.kenerp.com/api/modeOfTravelling
  Uri getTravelUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getTravelDomain);
  }

  /// get workTypeList url

  ///https://hrms.kenerp.com/api/workTypeList
  Uri getWorkUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getWorkDomain);
  }

  /// get letter status url

  ///https://hrms.kenerp.com/api/get_letters
  Uri getLetterUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getLetterDomain);
  }

  /// get letter status url

  ///https://hrms.kenerp.com/api/changePassword
  Uri getChangePasswordUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getChangePasswordDomain);
  }

  /// get OtpSuccess status url

  ///https://hrms.kenerp.com/api/otpSuccess
  Uri getOtpSuccessUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getOtpSuccessDomain);
  }

  /// Login URI

  /// https://hrms.kenerp.com/api/getHolidays
  Uri getHolidayUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.holidayDomain,
    );
  }

  /// yesterdayattendance details URI

  /// https://hrms.kenerp.com/api/getWorkDuration
  Uri getYesterdayattendanceUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.yesterdayattendanceDomain,
    );
  }

  /// leavebalance details URI

  /// https://hrms.kenerp.com/api/getleaveBalance
  Uri getLeavebalanceUrl() {
    return Uri(
      scheme: BaseUrl.getProtocol,
      host: BaseUrl.baseUrl,
      path: BaseUrl.leavebalanceDomain,
    );
  }

  /// get selfie attendnace  url

  ///https://hrms.kenerp.com/api/addSelfieAttendance
  Uri getSelfieAttendanceUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getSelfieAttendanceDomain);
  }

  /// get OcrAttendaceList  url

  ///http://hrms.kenerp.com/api/OcrAttendaceList
  Uri getOcrAttendaceListUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getOcrAttendaceListDomain);
  }

  /// get SelfiattendaceList  url

  ///https://hrms.kenerp.com/api/attendaceList
  Uri getattendaceListUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getattendaceListDomain);
  }

  /// get ocr by id url

  ///https://hrms.kenerp.com/api/getOcrAttendaceById
  Uri getOcrByIDUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getOcrByID);
  }

  /// get ocr by id url

  ///https://hrms.kenerp.com/api/AddOcrAttendance
  Uri getAddOcrAttendanceUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getAddOcrAttendance);
  }

  /// get ocr by id url

  ///https://hrms.kenerp.com/api/dayClose
  Uri getDayCloseUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getDayClose);
  }

  /// get get work by date url

  ///https://hrms.kenerp.com/api/getWorkDurationByDate
  Uri getWorkDurationByDateUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getWorkDurationByDateDomain);
  }

  /// get get short leave duration url

  /// https://hrms.kenerp.com/api/get_short_leave_duration
  Uri getShortLeaveDurationUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getShortLeaveDurationByDomain);
  }

  /// get get updateocrattendance url

  /// https://hrms.kenerp.com/api/OcrAttendaceListNew
  Uri getUpdateOcrAttendanceUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getUpdateOcrAttendanceByDomain);
  }

  /// get get updatedocument url

  /// https://hrms.kenerp.com/api/updateOcrAttendance
  Uri getUpdateDocumentUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getUpdateDocumentByDomain);
  }

  /// get get getoutdoortravelling url

  /// https://hrms.kenerp.com/api/get_out_door_travelling
  Uri getOutdoortravellingUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getOutdoortravelling);
  }

  /// get get salaryslip url
  /// he method URL create karun denar
  /// https://hrms.kenerp.com/rpt_salary_slip_new
  Uri getSalarySlipUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getSalarySlipByDomain);
  }

  ///  getOutdoortravellingdetail url

  /// https://hrms.kenerp.com/api/get_out_door_travelling
  Uri getOutdoortravellingdetailUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getOutdoortravellingdetail);
  }

  ///  getStoreoutdoorbills url

  /// https://hrms.kenerp.com/api/store_out_door_bills
  Uri getStoreoutdoorbillsUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getStoreoutdoorbills);
  }

  /// https://hrms.kenerp.com/api/getleaveBalanceNew
  Uri getPlBalanceUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getPlBalanceByDomain);
  }
  Uri getLeaveReportUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getLeaveReportPath);
  }




  /// https://hrms.kenerp.com/api/getCoffBalance
  Uri getCoffBalanceUrl() {
    return Uri(
        scheme: BaseUrl.getProtocol,
        host: BaseUrl.baseUrl,
        path: BaseUrl.getCoffBalanceByDomain);
  }
}
