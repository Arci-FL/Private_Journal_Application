PRIVATE JOURNAL APPLICATION

This is a flutter application for a private journal. It is a school assignment, and although the frontend doesn't fully connect to the backend, it is somewhat okay. SOMEWHAT

Technologies used:
Flutter Framework (front-end)
ASP.NET Web API Framework (api)
SQL Server Database (database)
ChatGPT (debugging)

Challenges Faced:
-Setting up the controllers: I hadn't touched ASP.NET for about a year before this project.
Not to mention, I was using vs code rather than visual studio (since I didn't think I could build a flutter application with it),
and I couldn't scaffold the controllers (I think I could've if I searched, but I was in a rush when I started and was just following
any directive I found). As a result, I had a few issues.

-Connecting the api to the database: I did not know the API would automatically generate the database for me; I just assumed I would create the
database myself and it would connect. As a result, I kept getting "this is already in the database" type of errors. Fortunately, I quickly realized
the issue and deleted my database, so that dotnet could do it's thing.

-Connecting the api to the front-end: Where do I even begin? There were so many issues with my apiservice.dart. It was here I really put into practice
all those "await" and "future" keywords (which tbh I'm still processing). After making a mess of my apiservice and eventually solving it, I had to do
the actual displaying on the front-end. In short, my issue graduated from connecting my api to the front-end to connecting my apiservice to the screens.
This is my current challenge. Fortunately, the assignment is over. I may continue this application one day, but before then I need to hit the books.

How to Run The Project in VS Code (Read through before doing anything):
Now, I'm not sure why you'd want to kill yourself, but you can simply clone this project to your vs code and type "flutter run" and "dotnet run" for the
front-end and back-end respectively. Don't forget to install flutter sdk and .net sdk, as well as the dart, flutter, c# extensions in vs code. Also, you'll
need an emulator, be it a virtual box, android studio emulator, or just your browser (if you want to keep things simple just use your browser. Once it loads,
click the square icon near the 'X' (restore down) and resize.)
I would advise you get postman and test out the api and backend first.
