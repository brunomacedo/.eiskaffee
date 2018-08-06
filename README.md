# My bash profile commands

Some functions in my `bash_profile` for developers `bash --version > 4.0`


# Instructions

## Where to put it (manually)?

**1.** Clone this **repository** in your root user folder.

**2.** Create a file called `.bash_profile` in your root user folder.
After that you should insert this line `source ~/.eiskrc` on it.

**3.** Now copy `.eiskrc` file on this repository into `tools/.eiskrc` in your root user folder.

**4.** Restart your terminal. =D


## Try install semi-automatically


**1.** Clone this **repository** in your root user folder.

**2.** Just run `install.sh` file in your terminal.

```bash
~/.eiskaffee/tools/install.sh
```

**3.** Restart your terminal. =D


## Install automatically

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/brunomacedo/.eiskaffee/master/tools/install.sh)"
```


# Anotations

## Loop `for`: difference

- `Msys`

```bash
for dirName in ${!folders[@]}; do
# for (( i = 0; i < ${#folders[@]}; ++i )); do
  # echo "${folders[$i]}"
  echo "${folders[$dirName]}"
done
```

- `Darwin/Mac`

```bash
for dirName in $folders; do
# for (( i = 1; i <= ${#folders[@]}; ++i )); do
  # echo "${folders[$i]}"
  echo "$dirName"
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
