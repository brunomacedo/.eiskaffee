# My bash_profile commands

Some functions in `bash_profile` for developers.


## Where to put it on?

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


## Different ways to get the package.json version

```shell
node -p -e "require('./package.json').version"
```

```shell
sed -nE 's/^\s*"version": "(.*?)",$/\1/p' package.json
```

```shell
grep -m1 version package.json | awk -F: '{ print $2 }' | sed 's/[", ]//g'
```

```shell
awk '/version/{gsub(/("|",)/,"",$2);print $2};' package.json
```


## Reset array list

```shell
OLDIFS=$IFS
IFS=$'\n'
your_array=()
IFS=$OLDIFS
```
