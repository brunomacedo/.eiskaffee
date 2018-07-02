# bash-update-git
Update all repositories from a folder using bash.

## Where put it on?
Save the `.bash_profile` file in the root folder on your user.

## Loop `for`: difference between Mac and Windows

- Mac

```shell
for dirName in $folders; do
echo $dirName
```

- Windows

```shell
for dirName in ${!folders[@]}; do
echo ${folders[$dirName]}
```
