Artificial Wisdom™ cloud platform's contribution guide.

# Configuration operations

These operations are done one time.

## Configure Github

This is, typically, only ever done once. With your web browser [Fork](https://github.com/artificialwisdomai/origin/fork) the repository. This will create a copy of the Artificial Wisdom™ cloud repository `origin`.

This is our origin.

## Configure environment

Each environment must be individually configured. An environment may be a Linux shell, MacOS shell, Windows shell, or the like.

Clone the forked `origin` repository:

```bash
git clone git@github.com:${USER}/origin.git
```

Add a remote identified as `upstream`:

```bash
git remote add upstream https://github.com/artificialwisdomai/origin.git
```

# The lifecycle of a change

The lifecycle of a change involves:

- Developer creates a branch.
- Developer creates a pull request.
- Developer issues pull request.
- Developer and reviewer work to improve pull request.
- Developer deletes branch.
- A reviewer will generally approve the pull request after one or more iterations of this cycle.

**This is not a policy**. There are situations under which a reviewer may decline a pull request. Based upon ten years of open source code review, I have seen pull requests declined for a variety of reasonable causes:

- Any review that takes more than twenty minutes per review iteration.
- Any review that touches ten or more files in unique ways.
- Modification to the license or code of conduct.
- Modifications to the CI system.
- Anything that isn't really an improvement.
- Unwillingness of the submitter to make required changes.
- Unwillingness of the submitter to file technical debt bugs.

**Reviewer is responsible for all merge decisions and must always adhere to the [code of conduct](./CODE-OF-CONDUCT.md)**

## Create a branch

Each branch is used to store each contained change you introduce to the software. A common workflow:

Checkout main:

```bash
git checkout main
```

Create a branch from `main` called `github_actions/lint_spellling`:

```bash
git checkout -b github_actions/lint_spelling
```

## Create pull request

Save all modifications that you have made to package them into a commit. To do this, commit all changes:

```bash
git commit .
```

You may have multiple commits per pull-request. After each commit, or the end of a
series of commits, push your commits to your fork:

```bash
git push origin
```

## Keep your branch updated

Keeping your branch updated ensures an effecient review cycle for you.

In some cases, a rebase on main is not necessary. In others, it is. We recommend
you always rebase prior to any pull request submission, although the choice is yours.

You may be asked to rebase as part of a review request:

```bash
git fetch upstream
git rebase upstream/main
```

## Pushing to artificialwisdomai/origin

Our configuration enforces the fork model by ensuring a push to `artificailwisdomai/origin.git` generates an error. This prevents common errors such as pushing to origin, which can wipe out other peoples changes, wipe out the entire repository, or cause other pain.
You will receive an error if you push to this repository directly without forking first. This enforces the saftey and correctness of the repository.


We have [break-glass](https://en.wikipedia.org/wiki/Computer_access_control#Break-Glass_Access_Control_Models) capability in the event of a critical error with the repository. Please contact [leadership](https://github.com/orgs/artificialwisdomai/teams/leadership) if you have a condition where you think the [repository is wedged](https://en.wikipedia.org/wiki/Hang_(computing)).

In the general case, please submit a pull request by forking the repository, and using this manual.

## Issue pull request

Once you've committed and pushed all of your changes to GitHub, go to the page for your fork on GitHub, select your development branch, and click the pull request button.

## Participate in the review

Communication is essential to completing the review of the change. We expect the
highest ethical and technical standards from our reviewers. There is significant
reviewer variance. As reviewers are humans, they have individual behavior, make
mistakes, commit technical fouls, and drive the architecture and quality forward
in ways that may be hard to comprehend but are nearly always technically sound.

The reviewer's responsibilites:

- The only technical rule is to never rubber stamp a review.
- Identify problems wth the change that need resolution now.
- Identify problems wth the change that need resolution later.
- Consider the change as it relates to the broader architecture.
- Provide a review summary for each PR revision they review.
- Ensure the change is an improvement.

Communicate with the reviewers using the github UI or by responding to the github
issue email. A reviewer could make mulitple statements and ask multiple questions
during a review. Answering all questions speeds up the review process. Resolving
review comments helps the submitter understand the line of questioning asked in
the comment is resolved. As a reviewer, you can ask for reasonable results from
a submitter, such as filing a tech-debt bug, changing an implementation, ensuring
linting is functional, rebasing on main, and other reasonable activites.
