import 'package:flutter/material.dart';

const String routeLandingPage = '/';
const String routeLoginPage = '/LoginKenPage';
const String routeLogoutDialog = '/LogoutDialog';
const String routeBookmarkShareUnfollowReport = '/BookmarkShareUnfollowReport';
const String routeChangePassword = '/ChangePassword';
const String routeMyNetworkMain = '/MyNetworkMain';
const String routeProfileBookmarkScreen = '/ProfileBookmarkScreen';
const String routeSettingPage = '/SettingPage';
const String routeReferAndEarn = '/ReferAndEarn';
const String routeMyPostScreen = '/MyPostScreen';
const String routeHistoyScreen = '/HistoyScreen';
const String routeVideoList = '/VideoList';
const String routeExploreScreen = '/ExploreScreen';
const String routeActivityScreen = '/ActivityScreen';
const String routeAddAlternateNumber = '/AddAlternateNumber';
const String routeAddSkillDialogDemo = '/AddSkillDialogDemo';
const String routeAddSkillsBottomSheet = '/AddSkillsBottomSheet';
const String routeUsersProfileView = '/UsersProfileView';
const String routeInsightTabBar = '/InsightTabBar';
const String routeLoginWithOtp = '/LoginWithOTP';
const String routeLoginWithOTPPage = '/LoginWithOTPPage';
const String routeLoginWithOtpResend = '/LoginWithOTPResendPage';
const String routeSignUpPage = '/SignUpPage';
const String routeRegBasic = '/RegBasic';
const String routeMyInterest = '/MyInterest';
const String routeMainScreen = '/MainScreenNavBar';
const String routeTermsAndConditions = '/routeTermsAndConditions';
const String routeDashboard = '/Dashboard';
const String routeLikeListScreen = '/LikeListScreen';
const String routeCommentListItem = '/CommentListItem';
const String routeForgotPasswordPage = '/KenForgotPassword';
const String routeForgotPasswordSecondPage = '/ForgotPasswordSecondScreen';
const String routeHelpAndSupport = '/HelpAndSupport';
const String routeAboutUs = '/AboutUs';
const String routePrivacyPolicy = '/PrivacyPolicy';
const String routeRequestWithdrawal = '/RequestWithdrawal';
const String routeAccessibilityPolicyForKnackbe =
    '/AccessibilityPolicyForKnackbe';

// Route<MaterialPageRoute> generatePageRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case routeLandingPage:
//       return MaterialPageRoute(builder: (context) => const SplashScreen());
//
//     case routeLoginPage:
//       return MaterialPageRoute(builder: (context) => const LoginKenPage());
//
//     case routeForgotPasswordPage:
//       return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
//
//     default:
//       return MaterialPageRoute(builder: (context) => const SplashScreen());
//   }
// }

/// Navigator that main app route context
class NavigationServices {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> wishListNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shoppingNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> profileNavigatorKey =
      GlobalKey<NavigatorState>();
}

/// Navigation to material using material route
/// this is normal page navigation , push page will come top of current page
void navigateViaMaterialRoute(
    BuildContext context, String pageRouteName) async {
  NavigationServices.navigatorKey.currentState!.pushNamed(pageRouteName);
}

void replaceViaMaterialRoute(BuildContext context, String pageRouteName) async {
  NavigationServices.navigatorKey.currentState!
      .pushNamedAndRemoveUntil(pageRouteName, (route) => false);
}
