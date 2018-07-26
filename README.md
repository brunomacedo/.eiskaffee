# My bash_profile commands

Some function in `bash_profile` for developers.


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

```bash
node -p -e "require('./package.json').version"
```

```bash
sed -nE 's/^\s*"version": "(.*?)",$/\1/p' package.json
```

```bash
grep -m1 version package.json | awk -F: '{ print $2 }' | sed 's/[", ]//g'
```

```bash
awk '/version/{gsub(/("|",)/,"",$2);print $2};' package.json
```
