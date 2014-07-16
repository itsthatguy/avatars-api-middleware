# How to contribute

Want to contribute something to Adorable Avatars? Wonderful! __Here's how you can help.__

Please take a moment to review this document in order to make the contribution
process easy and effective for everyone involved.

## Getting Started

1. [Fork](http://help.github.com/fork-a-repo/) the project, clone your fork,
   and configure the remotes:

   ```bash
   # Clone your fork of the repo into the current directory
   git clone https://github.com/<your-username>/adorable-avatars.git
   # Navigate to the newly cloned directory
   cd adorable-avatars
   # Assign the original repo to a remote called "upstream"
   git remote add upstream https://github.com/adorable/adorable-avatars.git
   ```

2. If you cloned a while ago, get the latest changes from upstream:

   ```bash
   git checkout master
   git pull upstream master
   ```

3. Install the project dependencies:

   ```bash
   npm install
   ```

4. Create a new topic branch (off the main project development branch) to
   contain your feature, change, or fix:

   ```bash
   git checkout -b <topic-branch-name>
   ```

## Making Changes

1. Commit your changes in logical chunks. Please adhere to these [git commit
   message guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
   Use Git's [interactive rebase](https://help.github.com/articles/interactive-rebase)
   feature to tidy up your commits before making them public.

   __NOTE__: Before you commit, ensure that the tests are still passing:
   ```bash
   npm test
   ```

   If you're adding new functionality, please write specs around it.

2. Locally merge (or rebase) the upstream development branch into your topic branch:

   ```bash
   git pull [--rebase] upstream master
   ```

3. Push your topic branch up to your fork:

   ```bash
   git push origin <topic-branch-name>
   ```

4. [Open a Pull Request](https://help.github.com/articles/using-pull-requests/)
    with a clear title and description against the `master` branch.

__IMPORTANT__: By submitting a patch, you agree to allow the project owners to
license your work under the terms of the [MIT License](LICENSE).
