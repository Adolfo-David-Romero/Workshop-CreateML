Workshop: CreateML Audio Classifier with GIPHY API Integration
==============================================================

Welcome to the **CreateML Audio Classifier Workshop**! 🎵 This hands-on exercise will guide you through creating an iOS app that classifies audio genres using **CreateML** and enhances the user experience by integrating the **GIPHY API** for visual feedback.

* * * * *

🛠️ Workshop Overview
---------------------

In this workshop, participants will:

1.  **Train an Audio Classifier Model**: Use the **CreateML** framework and the **GTZAN dataset** to build a machine learning model that classifies audio genres.

2.  **Integrate the Model into an iOS App**: Process live microphone input to classify audio genres in real time.

3.  **Enhance UX with GIPHY**: Dynamically fetch and display GIPHY stickers related to the identified audio genre.

* * * * *

📂 Repository Structure
-----------------------

This repository contains two branches:

-   `**starter**`: The starting point for the workshop. Participants will complete key areas of the code marked with `//TODO: Complete this`.

-   `**main**`: The complete solution for reference.

Clone the branch of your choice:

```
# Clone the starter branch to follow along
git clone -b starter https://github.com/Adolfo-David-Romero/Workshop-CreateML.git

# Clone the main branch to see the complete solution
git clone -b main https://github.com/Adolfo-David-Romero/Workshop-CreateML.git
```

* * * * *

🧰 Prerequisites
----------------

Before you begin, ensure you have the following:

1.  **Xcode 14+** installed on macOS.

2.  **Basic knowledge of Swift and SwiftUI**.

3.  **CreateML**: Pre-installed as part of Xcode.

4.  **GIPHY API Key**: Sign up at [GIPHY Developers](https://developers.giphy.com/) to get an API key.

5.  **GTZAN Dataset**: Download the dataset from [GTZAN](http://marsyas.info/downloads/datasets.html) for training the model.

* * * * *

🚀 Getting Started
------------------

### 1\. Train the Audio Classifier

-   Open **CreateML** in Xcode.

-   Use the **GTZAN dataset** to create an audio classification model that distinguishes genres like Rock, Jazz, Pop, etc.

-   Export the trained `.mlmodel` file and add it to the `Resources` folder of the Xcode project.

### 2\. Follow the Workshop

-   Open the `starter` branch in Xcode.

-   Complete the `//TODO: Complete this` sections in the code, which cover:

    -   Initializing the CoreML model.

    -   Processing live audio input into the correct format for predictions.

    -   Performing predictions and handling results.

    -   Fetching genre-specific GIPHY stickers via the GIPHY API.

-   Use the provided **PredictionView** and **HomeView** to test the app.

### 3\. Run the App

-   Build and run the app on a simulator or physical device.

-   Speak or play audio near the microphone and watch the app classify the genre in real-time.

-   View related GIPHY stickers displayed dynamically at the bottom of the screen.

* * * * *

🌟 Key Features
---------------

-   **Real-Time Audio Classification**: Uses CoreML and CreateML for live audio analysis.

-   **Dynamic Sticker Display**: Integrates the GIPHY API to fetch and display stickers based on detected genres.

-   **Reusable UI Components**: Modularized SwiftUI views for easy customization.

* * * * *

📦 Dependencies
---------------

The project uses the following:

-   **CreateML**: For training the audio classifier.

-   **CoreML**: For integrating the trained model into the app.

-   **GIPHY API**: For fetching genre-specific stickers.

* * * * *

📚 Learnings
------------

By the end of this workshop, participants will:

1.  Understand how to train a machine learning model with CreateML.

2.  Integrate a CoreML model into an iOS app for live predictions.

3.  Use a third-party API (GIPHY) to enhance user experience.

4.  Follow best practices for modular SwiftUI and MVVM architecture.

* * * * *

🤝 Contributing
---------------

Feel free to open issues or submit pull requests to improve this repository. Contributions are always welcome!

* * * * *

📝 License
----------

This project is licensed under the MIT License.

* * * * *

🔗 Resources
------------

-   [CreateML Documentation](https://developer.apple.com/documentation/createml/)

-   [CoreML Documentation](https://developer.apple.com/documentation/coreml/)

-   [GIPHY API Documentation](https://developers.giphy.com/)

-   [GTZAN Dataset](http://marsyas.info/downloads/datasets.html)
