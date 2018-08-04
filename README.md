# My bash profile commands

Some functions in my `bash_profile` for developers `bash --version > 4.0`


# Instructions

## Where to put it?

**1.** Clone this **repository** in your root user folder.

**2.** Create a file called `.bash_profile` in your root user folder.
After that you should insert this line `source ~/.eiskrc` on it.

**3.** Now copy `.eiskrc` file on this repository in your root user folder.

**4.** Restart your terminal. =D


# Anotations

## Loop `for`: difference between versions

- `> bash 4.0`

```bash
for dirName in ${!folders[@]}; do
echo "${folders[$dirName]}"
done
```

- `< bash 3.0`

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
