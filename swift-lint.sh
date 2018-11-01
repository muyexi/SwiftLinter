#!/bin/bash

#Path to swiftlint
SWIFT_LINT=/usr/local/bin/swiftlint
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GIT_ROOT=$(git rev-parse --show-toplevel)
ARGUMENT1=$1

if ! [[ -e "${SWIFT_LINT}" ]]; then
#### If SwiftLint is not installed, do not allow commit
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    echo "If you have Homebrew, you can directly use 'brew install swiftlint' to install SwiftLint"
    exit 1
fi

if [ -e "$HOME/.rvm/scripts/rvm" ]; then
    source "$HOME/.rvm/scripts/rvm"
fi

echo -e "$(ruby -v)\n"

declare -a SOURCE_FILES="($(ruby "$CURRENT_DIR/sourceFiles.rb"))"

lintDirectory() {
    cd $1
    count=0

    echo "🚀 Start linting: $(pwd)"

    if [ -e "$1/.gitignore" ]; then
        echo "✔︎ .gitignore exists."
        FILE_PATHS=($(git ls-files -m --full-name --exclude-from=.gitignore | grep ".swift$"))
        DELETED_FILE_PATHS=($(git ls-files -d --full-name --exclude-from=.gitignore | grep ".swift$"))
    else 
        echo "✘ .gitignore does not exist."
        FILE_PATHS=($(git ls-files -m --full-name | grep ".swift$"))
        DELETED_FILE_PATHS=($(git ls-files -d --full-name | grep ".swift$"))
    fi

    # Remove deleted files
    for i in "${DELETED_FILE_PATHS[@]}"; do
        FILE_PATHS=(${FILE_PATHS[@]//*$i*})
    done

##### Check for modified files in unstaged/Staged area #####
    for file_path in $(git diff --name-only --cached --diff-filter=AM | grep ".swift$"); do
        FILE_PATHS=("${FILE_PATHS[@]}" $file_path)
    done

    # Remove files not in Podspec
    if [[ $(pwd) != $GIT_ROOT ]]; then
        for i in "${FILE_PATHS[@]}"; do
            if [[ ! " ${SOURCE_FILES[@]} " =~ " $1/$i " ]]; then
                echo "Remove: $1/$i"
                FILE_PATHS=(${FILE_PATHS[@]//*$i*})
            fi
        done
    fi

    for file_path in "${FILE_PATHS[@]}"; do
        export SCRIPT_INPUT_FILE_$count="$1/$file_path"
        count=$((count + 1))
        echo "Found lintable file: $1/$file_path"
    done    

##### Make the count avilable as global variable #####
    export SCRIPT_INPUT_FILE_COUNT=$count


##### Lint files or exit if no files found for lintint #####
    if [ "$count" == 0 ]; then
        echo -e "🎉 No files to lint!\n"
        return 0
    else
        echo "Number of lintable files: ${SCRIPT_INPUT_FILE_COUNT}"
    fi

    CONFIG_PATH="$CURRENT_DIR/swiftlint.yml"

    if [ "$ARGUMENT1" == "autocorrect" ]; then
        echo "autocorrect enabled!"
        $SWIFT_LINT autocorrect --use-script-input-files --config $CONFIG_PATH  #autocorrects before commit.
    fi
    
    $SWIFT_LINT lint --use-script-input-files --config $CONFIG_PATH #lint before commit.    

    RESULT=$?

    if [ $RESULT -eq 0 ]; then
        echo "🔥 Violation found of the type WARNING! Must fix before commit!"
    else
        echo "🔥 Violation found of the type ERROR! Must fix before commit!"
    fi

    echo -e "RESULT: $RESULT\n"
}

lintDirectory $GIT_ROOT

declare -a POD_DIRS="($(ruby "$CURRENT_DIR/localPods.rb"))"
echo "Lintable pods: "
printf '%s\n' "${POD_DIRS[@]}"

for i in "${POD_DIRS[@]}"
do
    if [[ $i != *"node_modules"* ]]; then
        lintDirectory $i
    fi
done
