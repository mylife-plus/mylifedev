# SpaceTimeMemory
my diary app
https://www.figma.com/design/csV3LzJedgEliUzx4pTfYa/mvp?node-id=0-1&t=G5hhC2fHWMAjKF37-1

## How we work 

1.  admin creates a new issue/bounty by selecting the bounty issue template
2.  admin assigns bounty to bounty hunter and creates a new branch with the bounty name and mark bounty/issue as "in progress"
3.  bounty hunter makes a pull request with a comment, which is a copy of the bounty/issue description and updates it, if s/he realizes that the bounty took more/less time or new tasks where needed, to solve the bounty
4.  admin checks pull request, negotiates bounty time & difficulty with hunter and merges.
5.  admin updates google sheet https://docs.google.com/spreadsheets/d/14B20q_MdBr2Zh9PwnW66LE2IL2WQrtKOybPNZcriRY0/edit?usp=drivesdk and sends bounty reward to bounty hunter 

## How we will work 

1. anyone with staked project mana can create improvement proposals (IPs)(new features or fixing bugs) via comPower
2. project stakers upvote IPs. the more stake the more voting power
3. the top IPs get converted into Bounties by the elected dev contributors with the role "Bounty Creator"
4. users can dispute bounties if it violates bounty rules
5. users vote on disputed bounties 
6. bounties which don't get disputed for a week get automatically accepted 
7. Anyone can grab a bounty by locking 25% of the bounty mana behind it
8. once locked the bounty gets automatically assigned to the hunter. 
9. S/he has to finish the bounty in time. for every 3h bounty time the hunter gets 24h 
10. if the hunter fails to deliver in time s/he can extend by locking an additional 1/4 of the bounty price. the max extension time is 3x
11. if the hunter fails to deliver in time the mana gets burned and the bounty gets reopened 
12. once a bounty is finished the elected dev with role "Bounty Merger" checks and merges the bounty into main
13. once merged the bounty mana including the locked mana gets automatically send to the hunter 

#### Using Git Hooks to Trigger Blockchain Actions
Git hooks are scripts that run automatically on specific Git events, such as committing (`post-commit`) or pushing (`post-push`). You can use these hooks to trigger interactions with Chromia’s blockchain.
