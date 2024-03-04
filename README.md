
# JobsityTV

Tech Assigment from Jobsity to iOS role.

All mandatory and bonus features are implemented.
Given the time constraint for the assignemnt, I could not work on many of the improvements.

## What could improve
- Although we are streaming down errors from the network layer, the app is not displaying any feedback for users in case an error happens.
- An empty state screen
- Pull to refresh on lists

# Instructions

Run ```pod install``` before starting the project.

Xcode Version 15.0.1.

# Architecture

This app implements MVVM-C + Rx.

Below is a diagram showcasing how the coordinators were designed.

![Coordinators diagram](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/MVVMC.png?raw=true)

# Features

List all of the series contained in the API used by the paging scheme provided by the
API.

The app requests a new page everytime scroll reaches the bottom.

![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.46.24.png?raw=true)

Allow users to search series by name.

The listing and search views must show at least the name and poster image of the
series.

Create a people search by listing the name and image of the person.

![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.48.45.png?raw=true)
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.50.14.png?raw=true)
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.50.59.png?raw=true)

After clicking on a series, the application should show the details of the series, showing
the following information:
- Name
- Poster
- Days and time during which the series airs
- Genres
- Summary
- List of episodes separated by season

After clicking on an episode, the application should show the episode’s information,
including:
- Name
- Number
- Season
- Summary
- Image, if there is one

![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.48.54.png?raw=true)
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.49.07.png?raw=true)
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.49.20.png?raw=true)

After clicking on a person, the application should show the details of that person, such
as:
- Name
- Image
- Series they have participated in, with a link to the series details. (Redirects to TV Series details screen)

![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.51.07.png?raw=true)

Allow the user to save a series as a favorite.
- Allow the user to delete a series from the favorites list.
- Allow the user to browse their favorite series in alphabetical order, and click on one to
see its details.

![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.49.34.png?raw=true)

Allow the user to set a PIN number to secure the application and prevent unauthorized
users.

For supported phones, the user must be able to choose if they want to enable fingerprint
authentication to avoid typing the PIN number while opening the app.

![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.49.55.png?raw=true)
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2020.51.58.png?raw=true)

Phone supports Touch ID / Face ID
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2021.32.05.jpeg?raw=true)
![](https://github.com/JamysonFreirejf/JobsityTV/blob/main/Screenshots/Screenshot%202024-03-03%20at%2021.32.31.jpeg?raw=true)
