# Logger App
Logger is a simple iOS app built using UIKit and Swift to allow users to register and log in. The app uses Firebase Authentication, Firebase Realtime Database to store user information, and Firebase Storage to store user profile pictures. The app requires iOS 15.5 or later to run.

# Features
Firebase Authentication: The app uses Firebase Authentication to handle user registration and login.
Firebase Realtime Database: The app uses Firebase Realtime Database to store user information such as the first name, last name, and email.
Firebase Storage: The app uses Firebase Storage to store user profile pictures.
SDWebImage: The app uses SDWebImage to cache profile pictures for faster loading.

# Installation
1. Clone or download the repository.

2. Open the .xcworkspace file in your project folder. This file should be used instead of the .xcodeproj file.

3. Create a new project in your Firebase console if you haven't already done so. Then create an iOS project in your Firebase console.

4. For Firebase Authentication, register your app in Firebase with your bundle identifier.

5. Download the GoogleService-Info.plist file and add it to your Xcode project.

6. In your Firebase console, click on Authentication and then Get Started. Select enable email/password as a provider.

7. For Firebase Realtime Database, select Realtime Database in the Firebase console and create a database. Select the desired location and security rules.

8. For Firebase Storage, select "Storage" and click on "Get Started". Review the security rules here as well.

9. Build and run the project.

# Example
https://user-images.githubusercontent.com/70426525/235327868-f8ec1f74-52f0-4177-a153-c8aac808e8ed.mp4

# Requirements
iOS 15.5+
