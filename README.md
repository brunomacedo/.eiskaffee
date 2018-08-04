# My bash profile commands

Some functions in `bash_profile` for developers `bash --version > 4.0`


## Where to put it on?

Save the `.bash_profile` file in the root folder on your user.


## Loop `for`: difference between versions

- > bash 4.0

```bash
for dirName in ${!folders[@]}; do
echo "${folders[$dirName]}"
done
```

- < bash 3.0

```bash
for fileName in $files; do
  echo "${fileName}"
done
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


## Reset array list

```bash
OLDIFS=""
IFS=$'\n'
your_array=()
IFS=$OLDIFS
```
