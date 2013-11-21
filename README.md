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

## Getting Started

* Include bashor in your main script file.
    
    ```
    BASE_DIR=\`printf '%s' "$BASH_SOURCE" | sed 's#/\?[^/]*$##' | sed 's#^./##'\`;
    if [[ ! "$BASE_DIR" =~ ^/ ]]; then
        BASE_DIR=\`printf '%s' "$PWD/$BASE_DIR" | sed 's#/\.\?$##'\`;
    fi
    . "$BASE_DIR/loader.sh";
    ```

### Configuration

Set the environment variable **BASHOR\_PATH\_CONFIG** to load this as config
script.

Add your class paths to **BASHOR\_PATH** seperate with ';'.

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

## More

More will follow in the next days...
