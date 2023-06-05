Routify

Our application revolutionizes institute-based carpooling by connecting drivers and passengers within the same institution based on compatible schedules and routes. It incorporates a request and acceptance system for efficient pairing and sends daily reminders to participants. The solution enhances trust, convenience, and sustainability in carpooling arrangements, fostering a sense of community within educational institutions.


Backend Setup:

Install Dependencies:
for backend - npm i

Env variables:
Essential variables JWT_KEY = url = API_KEY

To start - npm start


Frontend Setup:

- Install Flutter:

Download and install the Flutter SDK from the official Flutter website (https://flutter.dev).
Extract the downloaded package to a suitable location on your machine.
Add the Flutter binary path to your system's PATH variable.

- Set up an Editor:

Choose an editor of your preference, such as Visual Studio Code or Android Studio.
Install the necessary plugins or extensions for Flutter development in your chosen editor.

- Clone the GitHub Repository:

Open your terminal or command prompt.
Navigate to the directory where you want to clone the project.
Run the following command to clone the repository:
git clone https://github.com/username/git_repo.git

- Obtain a Google Maps API Key:

Go to the Google Cloud Platform Console (https://console.cloud.google.com).
Create a new project or select an existing project.
Enable the "Maps SDK for Android" and "Maps SDK for iOS" APIs for your project.
Generate an API key by going to the Credentials section.
Copy the generated API key.

-  Configure the Project:

Open the cloned "Routify" project in your chosen editor.
Open the android/app/src/main/AndroidManifest.xml file.
Add the following metadata inside the <application> element, replacing YOUR_API_KEY with your actual API key:
<application> <meta-data android:name="com.google.android.geo.API_KEY" 
android:value="YOUR_API_KEY"/> <!-- ... --> </application> 

- Build the APK:

Connect an Android device to your machine or start an Android emulator.
In the terminal or command prompt, navigate to the project's root directory:
cd routify 
Run the following command to install the project dependencies:
flutter pub get 
Build the APK using the following command:
flutter build apk 
This command will create an APK file in the build/app/outputs/apk directory within the project.

-  Locate the APK:

Once the build process is complete, you can find the APK file in the project's directory:
routify/build/app/outputs/apk/release/app-release.apk 




