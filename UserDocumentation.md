# StaticFDP Usage

`fdpcloud.org` is a StaticFDP server.
A StaticFDP server enables mantainance of FDP metadata as static files in a filesystem.
The `fdpcloud.org` filesystem is populated with clones of GitHub repositories.

## Quick start

You are here because you wish to create and manage an FDP server with files in a filesystem.
The [`fdpcloud.org` management interface](https://fdpcloud.org/MANAGE/ui/Manager.html) provides a list of served repositories and their corresponding domain name.
<img width="1663" alt="image" src="https://github.com/user-attachments/assets/268c6713-9ab4-4b78-92e2-92e3152dcc59">

At the bottom, you can enter a respository type (you can choose between `github` and `github`), an owner (all the ones in the screenshot are served by the github [`StaticFDP` owner](https://github.com/StaticFDP/)), a repository name, and an optional subdomain.
Suppose we want to add a pre-existing repo called [`FHIR-smoker`](https://github.com/StaticFDP/FHIR-smoker).
We can enter the repository name in the input boxes in the bottom of the manager, as shown above.

<img width="900" alt="image" src="https://github.com/user-attachments/assets/8bac64b6-bf91-4cd5-9cdd-9d946b17ace9">

