#!/bin/bash
# Ruby CLI Template Setup, version 1

#  Warning:
#  -------
#  This script deletes itself at the end of running, pass "--keep" to
#  skip this step

# All flags we can pass in via the CLI
keep_flag=''

print_help() {
  echo "Ruby CLI Template Setup V1"
  echo ""
  echo "Usage: setup.sh [--keep] [-h --help]"
  echo ""
  echo "keep / k : Keep this setup file after running"
  echo "help / h : Print this help"
  exit 1
}

# Handle flags
while :; do
  case $1 in
    -h|-\?|--help)
        print_help    # Display a usage synopsis.
        exit
        ;;
    -k|--keep)       # Takes an option argument; ensure it has been specified.
        keep_flag="true"
        ;;
    --)              # End of all options.
        shift
        break
        ;;
    -?*)
        printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
        ;;
    *)               # Default case: No more options, so break out of the loop.
        break
  esac

  shift
done

# Root ID  for checking later
ROOT_UID=0     # Only users with $UID 0 have root privileges.

# Make sure we're not root, or allow us to bail out.
if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "You should not be root to run this script,"
  read -p "Do you want to continue anyways? y/N: " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
    exit 1
  fi
fi

# 1. Check for Ruby exists and if it's the version in .rbenv
if ! command -v "ruby" &> /dev/null
then
    echo "Ruby could not be found on your system. That's a problem if you're trying"
    echo "to create a CLI in Ruby. 🤕"
    echo
    echo "I recommend you use rbenv to manage your Ruby version, you can find setup"
    echo "instructions for it at https://github.com/rbenv/rbenv"
    exit 1
fi

input="./.ruby-version"
while IFS= read -r line
do
  ruby_version=$line
done < "$input"

installed_ruby_version=$(ruby -v)
echo "Current Ruby version installed:"
echo $installed_ruby_version

echo "Version indicated in .ruby-version file"
echo $ruby_version

if [[ "$installed_ruby_version" != *"$ruby_version"* ]]; then
  echo '---'
  echo "Your ruby version doesn't match the current version installed. 🥴"
  echo
  echo "I recommend you use rbenv to manage your Ruby version, you can find setup"
  echo "instructions for it at https://github.com/rbenv/rbenv"
  exit 1
else
  echo
  echo "Everything looks good for your Ruby versions."
  echo
fi

echo "Installing gems automatically..."
if ! command -v "bundle" &> /dev/null
then
  gem install bundler
fi

rm Gemfile.lock
bundle install

read -p "What is the name for your new project?: "
name=${REPLY}

mv 'template.rb' "$name.rb"

touch '.env'

echo
echo "Do you want to reset this Git repository to a pristine state?"
echo 'Answer "Yes" if you cloned this from a template repository,'
echo 'Answer "No" if you forked the repository instead.'
echo

read -p "Do you want to reset your Git repository? Y/n: " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  rm -rf '.git'
  git init
  git add .
  git commit -a -m "Initial commit"
fi

mv "../RubyCLITemplate" "../$name"

if [[ $keep_flag != "true" ]]; then
  rm "../$name/setup.sh"
fi

cd "../$name"

echo "All done!"
echo "You may need to switch to the correct directory by typing the following:"
echo "cd ../$name"

exit 0
#  A zero return value from the script upon exit indicates success
#+ to the shell.
