import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
    static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
    static String sharedPreferenceUsernameKey = 'USERNAME';
    static String sharedPreferenceEmailKey= 'EMAIL';

    static Future<void> savedUserLoggedInSharedPreference(bool isUserLoggedIn) async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        return await sharedPreferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
    }

    static Future<void> savedUsernameSharedPreference(String username) async {
        SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
        return await sharedPreferences.setString(sharedPreferenceUsernameKey, username);
    }

    static Future<void> savedEmailSharedPreference(String email) async {
        SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
        return await sharedPreferences.setString(sharedPreferenceEmailKey, email);
    }

    static Future<bool> getUserLoggedInSharedPreference() async {
        SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
        return sharedPreferences.getBool(sharedPreferenceUserLoggedInKey);
    }

    static Future<String> getUsernameSharedPreference() async {
        SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
        return sharedPreferences.getString(sharedPreferenceUsernameKey);
    }

    static Future<String> getEmailSharedPreference() async {
        SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
        return sharedPreferences.getString(sharedPreferenceEmailKey);
    }
}