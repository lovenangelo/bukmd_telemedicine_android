import 'package:bukmd_telemedicine/src/features/appointment_scheduling/presentation/appointment_screen.dart';
import 'package:bukmd_telemedicine/src/features/appointment_scheduling/presentation/appointment_setup.dart';
import 'package:bukmd_telemedicine/src/features/authentication/screens/forgot_password_screen.dart';
import 'package:bukmd_telemedicine/src/features/authentication/screens/signin_screen.dart';
import 'package:bukmd_telemedicine/src/features/authentication/screens/signup_screen.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/appointment_record_screen.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/appointment_requests_screen.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/buksu_announcement.dart';
import 'package:bukmd_telemedicine/src/features/doctor_dashboard/screens/doh_news_health.dart';
import 'package:bukmd_telemedicine/src/features/news_health_updates/screens/news_health_screen.dart';
import 'package:bukmd_telemedicine/src/features/prescription/presentation/create_prescription.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/profile_screen.dart';
import 'package:bukmd_telemedicine/src/features/profiling/screens/user_information_screen.dart';
import 'package:bukmd_telemedicine/src/features/video_call/call.dart';
import 'package:bukmd_telemedicine/src/wrappers/auth_wrapper.dart';
import 'package:bukmd_telemedicine/src/wrappers/registration_form_wrapper.dart';

var appRoutes = {
  '/authwrapper': (context) => const AuthWrapper(),
  '/profile': (context) => const ProfileScreen(),
  '/signin': (context) => SignInScreen(),
  '/signup': (context) => const SignUpScreen(),
  '/forgotpassword': (context) => ForgotPasswordScreen(),
  'newshealth': (context) => const NewsHealthScreen(),
  'appointmentscheduling': (context) => const AppointmentScreen(),
  '/updateuserinformation': (context) =>
      const UserInformationScreen(title: 'UPDATE INFORMATION'),
  '/basicinfowrapper': (context) => const RegistrationFormWrapper(),
  '/setappointment': (context) => const AppointmentSetup(),
  '/viewappointmentrequests': (context) => const AppointmentRequestScreen(),
  '/videocall': (context) => const CallScreen(),
  '/viewappointmentrecord': (context) => const AppointmentRecordScreen(),
  '/announcement': (context) => const UpdateAnnouncementPage(),
  '/create-prescription': (context) => const CreatePrescriptionPage(),
  '/doh-news-health': (context) => const DohNewsHealth()
};
