# Anime World
#### Video Demo:  https://youtu.be/hKLwGBjC_Og
#### Description:
  Anime World, a well-crafted Mobile App, emerges as the ultimate haven for anime loves around the world, bringing their favorite content to their fingertips.
  
#### Why there is a need for this:
  Anime (Japanese style of 2D animations) is a very popular entertainment worldwide. There are currently more than 100 million animes fans around the world that are mostly teenagers and youths. These fans constantly look for new and entertaining animes to watch and thus there are tons of websites out there who has made their job to introduce these animes to the fans. But most of these websites and apps seems to be not particularly well-designed. I have personally tested many anime websites and apps and sadly there is none you can enjoy using due to design problems they have. One of these famous websites is myanimelist that is also my favorite website that contains all kinds of information about animes and mangas. But I sometimes find it hard to use due to design problems and lack of interactivity and complexness. So, I decided to download is mobile app but noticed that it wasn't an actual mobile app but rather a wrapper around the existing website causing me not to have a user-friendly experience. So, this was my motivation to create an app that is not only wholesome and has all kinds of info that you look for in a good app but also is well-designed and easy to use. So, I created "Anime World" that uses the public api by "MyAnimeList" website so it loads the exact same data of "MyAnimeList" website but does is in a lot better way for fans to have a more premium experience.

#### Key Features
  ##### User Friendly Interface
  This app provides a very simple and straight-forward user interface that makes it easier for users to find their favorite anime in no time. I have used a bottom nav bar to make it super easy for user  to navigate between different parts of the app i.e. animes scree, categories screen and settings. All the buttons are also very interactive giving you a seamless experience.

  ##### Dark/Light Mode
  This app allows you to change theme of your app to dark and vice versa. Dark mode makes it easier to read contents of the app in dark environments and adding such a feature is almost a no-brainer for every modern app out there. Also, the app by default uses your smartphone theme unless you change it that would then keep your selected theme in memory so everytime you open the app, it displays the right theme.

  ##### Cross platform capability
  This app is built in Flutter that is a cross platform technology meaning that it supports all the platforms (i.e. Android, iOS, Web and Desktop) out fo the box while also giving you a native experience using it unlike web based apps that are just a wrapper around a website in form of Mobile App.

  ##### Search Feature
  Using this app, you can search for your favorite anime in real time. No need to press any button, just as you start typing name of the anime you're looking for the results start to appear on the screen in real-time. You can also click on those search results to open up a comprehensive detail page.

  ##### Anime Recommendations
  Anime recommendations is a system that works on AI. This system creates a psychological relations between animes by their characteristics i.e. genres, story, number of episodes and more. So, if you like anime "A", there is a great chance you also want to watch anime "B" because they are in some ways similar to each other. For every anime that you visit in this app, there are a number of animes recommended to you based on similarity.

  ##### Similar Animes
  This features introduces you to animes that are similar to currently selected anime. The similar animes could be other seasons of the current anime or special episodes and even other series based on the current anime.

  ##### Checking Internet Connectivity
  This app has the ability to see whether you're online or not. As the entire app is based on the internet, if you turn off the internet it will give you a warning telling you to turn you wifi or mobile data back on.

#### Development Process
  ##### Tech Stack
  I built this app entirely using Flutter. Flutter is Google's UI toolkit used to build cross-platform native apps for Android, iOS, Web and also Desktop. Flutter provides you with all the necessary tools to effectively design application using provided widgets. Flutter doesn't offer any drag and drop tools and instead you have to write code for building the UI. Flutter's UI components can be best described by the word "widget". In Flutter everything is a widget, and these widgets are very similar to HTML tags. The programming language Flutter uses is called "Dart". Dart is a server-side programming language built by Google to replace JavaScript and is currently used to build Flutter applications.

  ##### Challenges and Solutions
  When I started to develop this app I faced several challenges. The first challenge that I had to overcome was getting enough data for the animes. The best way to get these data was using an API (Application Programming Interface). There were several API's out there but most of them were either not comprehensive or not easy to use. I did a lot of research and lastly decided to use the MyAnimeList public API. This API provides access to a very large database of contents and is up to date.

  The second challenge was learning how to use the API. Every API works in a specific way and contains specific headers and tokens you need to use for verification. To access the API, I had to register my application in the website to be able to access a client id. This id should be included in every request in order to be able to get data from the API. But my biggest challenge with API was not how to get data initially but how to get create models for data that you get. These data were provided in the form of JSON and so I had to create DART models for theme for my app to recognize those data. This api contained many endpoits and based on the end point the data would be differ. So, this was the trickiest part of the challenge where I had to create different models for different data while some of them had a very little different like getting data from ranking endpoint that gave me a list of anime nodes with ranking and getting seasonal animes that didn't include ranking. I overcame this challenge by taking my time and optimizing my models creating models for similar data that more than one endpoint included like: anime_node and reusing that model inside other models as well.

  The last challenge was designing a pretty user-interface. User interface has always been a hard part of building a mobile and web app. It contains many concepts like responsiveness and coloring. I got inspiration for the UI design from a dribbble design of a Movie App.

#### How to use this app
  Using this app is pretty straight-forward. All you need to do is to install the version according to your device. This app comes for Android, iOS, Web and Even Desktop. All you need to do to get started is to install the app and enjoy the experience. No login required.

#### Conclusion
Anime World isn't just an app; it's a commitment to elevating the anime-watching experience. With a focus on design, functionality, and user satisfaction, Anime World stands as a testament to the fusion of technology and entertainment, revolutionizing how anime enthusiasts engage with their favorite content.
