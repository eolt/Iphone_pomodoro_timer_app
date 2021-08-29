# Focus Tracker 
The Pomodoro timer is a productivity tool which schedules the amount of time between being productive and taking breaks. The timer separates the duration of breaks and work into intervals. The user gets regular "short" breaks after their productive intervals and one "long" break after a certain number of productive intervals. The method is popular with students who wish to balance study and leisure. But it can be beneficial for almost any environment requiring long hours of production or focus.

I use the Pomodoro method regularly for study, projects, research, or other interests. I also enjoy keeping track of how long I have been working on the task. Thus, I had the idea to design an app which implemented the Pomodoro method and could then save the amount of time being productive. 

## Displays
<div>
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131265142-8a3472da-2919-41e3-8c4b-7520ca36b04e.png">
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  <img width="358" alt="dark_screen" src="https://user-images.githubusercontent.com/27907086/131265181-26c15a28-c5f1-4150-af70-4968b6d63f94.png">
  <br>
  <br>
  <br>
  <img width="358" alt="dark_screen" src="https://user-images.githubusercontent.com/27907086/131265439-5a3e47a7-9f9b-4d55-91dc-9687911729a5.png">
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  <img width="358" alt="dark_screen" src="https://user-images.githubusercontent.com/27907086/131265470-a26671dc-89f8-4f4d-975a-5723c5f1166d.png">
</div>


## Implementation (Foreground and Background)
The app works as a count down timer, starting at the lenght of an interval and ending at zero. The user can interact with the center button to press play or pause the time. The button changes display whenever it gets pressed, letting the user know if it has paused or play. 

The app is designed to run at the foreground and background. A user can assume the app is running even when switching apps or locking the phone. Unfortunately Apple makes it difficult to run non-audio/non-location based apps in the background therefore I had to optimize and create the illusion of running in the background. Everytime the user presses play and starts the timer, the program saves the date of when the timer started. If the app leaves the foreground the program automatically terminates. When the app returns, a new date is saved and compared to the last. Our program predicts at what time the new timer should be based on the gap between dates. Another advantage of using this approach is that the app uses less memory and energy by not having to run in the background.

<div>
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131265281-d90f2040-2375-4467-bc82-e372f42a8296.gif">
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131265339-8d504a68-e157-40a6-916e-704751f9c9bf.gif">
  <br>
  <br>
  <br>
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131265510-ab888ffe-87c6-4a0d-8800-6bfa1680b291.gif">
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131265526-f766f4c9-9f47-45f3-aefb-f6347a16f60d.gif">
</div>


## Notifications 
<div>
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131266869-1da872cc-56cb-4c90-a2d0-83f742c3ed76.png">
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131266920-0247b098-5d11-4077-8f3b-51275135c90c.png">
  <br>
  <br>
  <br>
  
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131266895-51dbd261-ab24-4680-8a58-554f89115ead.png">
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  &emsp;
  <img width="358" alt="light_screen" src="https://user-images.githubusercontent.com/27907086/131266938-3c2da9a5-bc17-4b3b-a8ad-f18c2144419a.png">
</div>



