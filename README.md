# Moved to Gitlab
Bashor has moved to GitLab: https://gitlab.com/killmag10/bashor

**This repository on GitHub will not be updated any more. Use the GitLab repository.**

# Bashor

Bashor is a pseudo object oriented framwork for the bash.

Bashor is a alternate way to use object orientation in a filesystem close
programming language (Bash), to write structered scripts with many file
operations what have no big attention to performance.
If you have attention to performance use nodejs. :p

## Features

* Create classes.
* Create objects.
* Inherit classes.
* Autoloading classes.
* Serialization of objects.
* Basic classes includet.
* Profiling.
* Code coverage report (Bashor\_Code\_Coverage).

## Getting Started

Include bashor in your main script file.

```bash
BASE_DIR=`printf '%s' "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'`;
if [[ ! "$BASE_DIR" =~ ^/ ]]; then
    BASE_DIR=`printf '%s' "$PWD/$BASE_DIR" | sed 's#/\.\?$##'`;
fi
. "$BASE_DIR/loader.sh";
```

### API Documentation

For the API Documentation run:

    make man

### Configuration

Set the environment variable **BASHOR\_PATH\_CONFIG** to load this as config
script.

Add your class paths to **BASHOR\_PATH** seperate with ':'.

#### Performance

* BASHOR\_CLASS\_AUTOLOAD : Autoloading
    * '' : Autoloading inactive
    * '1' : Autoloading active (default)

#### Compatibility

* BASHOR\_CODEING\_METHOD : Internal coding method.
    * base64 (default)
    * hex
* BASHOR\_BASE64\_USE : Programm used for base64 coding.
    * openssl
    * perl
    * base64 (default)
* BASHOR\_USE\_GETOPT : Use getopt for parameter reading.
    * '' : Use getopts.
    * '1' : Use getopt. (default)
* BASHOR\_COMPATIBILITY\_THIS : Use **this** instat of **static**.
    * '' : Off. (default)
    * '1' : On.

#### Options

* BASHOR\_INTERACTIVE : Use interactive mode.
    * '' : Off. (default)
    * '1' : On.
* BASHOR\_ERROR\_CLASS : Use **Bashor\_ErrorHandler** class for error handling.
    * '' : Off.
    * '1' : On. (default)
    
#### Profiling

The profiling format is valgrind (You can view it with kcachgrind).

* BASHOR\_PROFILE : Use profiling.
    * '' : Off. (default)
    * '1' : On.
* BASHOR\_PROFILE\_FILE : File path to save profiling.

### Code coverage

This is an example how you can use the code coverage:

```bash
    new Bashor_Code_Coverage_Writer_Html CoverageWriter "$BASE_DIR/../codeCoverage"
    class Bashor_Code_Coverage setVerbose '1'
    class Bashor_Code_Coverage start "$BASE_DIR/../"
    ...
    # your code
    ...
    class Bashor_Code_Coverage stop "$CoverageWriter"
```

### Use Classes/Objects

Example:

```bash
new Bashor_List Data
object "$Data" set "test" "blub 123blub"
res=`object "$Data" get "test"`
remove "$Data"
```

### Writing classes

#### Method

* Function Name:
    1. "CLASS_"
    1. Your class name. Folders seperated by "_".
    1. "_" +  Method name.
        * Protected starts with an extra "_" (tow with normal seperator).
        * Magic methods starts with "__" (three with normal seperator).

#### Magic methods

* __load : Called on class loding (For static variables).
* __construct : Called on object creation (new).
* __destruct : Called on object destruction (remove).
* __sleep : Called on object serialization (serialize).
* __wakeup : Called on object unserialization (unserialize).

#### Example

```bash
##
# Loader
#
# Called on class loding
CLASS_Class___load()
{
    requireStatic
    return 0
}

##
# Constructor
#
# Called on object creation (new)
CLASS_Class___construct()
{
    requireObject
    return 0
}

##
# Destructor
#
# Called on object destruction (remove)
CLASS_Class___destruct()
{
    requireObject
    return 0
}

##
# Make object ready for sleep.
#
# Called on object serialization (serialize)
CLASS_Class___sleep()
{
    requireObject
    return 0
}

##
# Make object ready for wakeup.
#
# Called on object unserialization (unserialize)
CLASS_Class___wakeup()
{
    requireObject
    return 0
}

##
# Check if the class has the over given method.
#
# $1    string  method name
# $?    0:OK
# $?    1:ERROR
CLASS_Class_hasMethod()
{
    requireParams R "$@"

    issetFunction CLASS_"$CLASS_TOP_NAME"_"$1"
    return $?
}
```

### Run tests

To run the tests run:

    make test

