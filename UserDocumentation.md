# StaticFDP Usage

`fdpcloud.org` is a StaticFDP server.
A StaticFDP server enables mantainance of FDP metadata as static files in a filesystem.
The `fdpcloud.org` filesystem is populated with clones of GitHub repositories.

## Quick start

You are here because you wish to create and manage an FDP server with files in a filesystem.
The [`fdpcloud.org` management interface](https://fdpcloud.org/MANAGE/ui/Manager.html) provides a list of served repositories and their corresponding domain name.
<img width="1663" alt="image" src="https://github.com/user-attachments/assets/268c6713-9ab4-4b78-92e2-92e3152dcc59">

======
At the bottom, you can enter a respository type (you can choose between `github` and `github`), an owner (all the ones in the screenshot are served by the github [`StaticFDP` owner](https://github.com/StaticFDP/)), a repository name, and an optional subdomain.
Suppose we want to add a pre-existing repo called [`FHIR-smoker`](https://github.com/StaticFDP/FHIR-smoker).
We can enter the repository name in the input boxes in the bottom of the manager, as shown above.

<img width="900" alt="image" src="https://github.com/user-attachments/assets/8bac64b6-bf91-4cd5-9cdd-9d946b17ace9">
======
Hitting `create` will create a new line in the list of repositories and show some processing information under Messages.

<img width="885" alt="image" src="https://github.com/user-attachments/assets/464762c7-f6c4-43dd-89cb-2bb8f5301711">
======
Now you can add a subdomain if you want a simpler way to address the site.

<img width="1553" alt="image" src="https://github.com/user-attachments/assets/613eb812-771b-41ff-841e-4671d293374f">

======
You can browse the site wtih the `explore link on the left and get a page like this:

<img width="1661" alt="image" src="https://github.com/user-attachments/assets/58b22d6b-851b-4251-8b85-08465e73ba44">


