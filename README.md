# issue-assign-all-collaborators
[![](https://img.shields.io/docker/image-size/ambersun1234/issue-assign-all-collaborators/1.0)](https://hub.docker.com/r/ambersun1234/issue-assign-all-collaborators)

# Introduction
This action implements auto assign all collaborator to specific issue

# How to use
Create a workflow file under `.github/workflows` with following content
```yaml
on:
  issues:
    types: [opened]

jobs:
  issue-assign-all-collaborators:
    runs-on: ubuntu-latest
    name: Auto assign collaborators
    steps:
      - name: Run issue assign all collaborators
        uses: ambersun1234/issue-assign-all-collaborators@v1.0
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

# Result
If things goes right, you will see the following text on GitHub Action
```
Successfully get 'ambersun1234/issue-assign-all-collaborators' repository collaborators
Successfully assign "ambersun1234" to issue #7 assignee
```
Note that if there's more than one collaborators, this action will assign **all of the collaborator** to the issue

# Docker hub
The implementation had already build into an image, and it's also available on [docker hub](https://hub.docker.com/r/ambersun1234/issue-assign-all-collaborators)
> The image sha256 is: 6f575d47ddc3811f279f860c58ab5614e2739a4586d2901937d550a6211af330

# Author
+ [ambersun1234](https://github.com/ambersun1234)

# License
This project is licensed under MIT license - see the [LICENSE](./LICENSE) file for more detail