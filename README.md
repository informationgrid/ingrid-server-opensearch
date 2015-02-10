OpenSearch Server
=================

This software is part of the InGrid software package. The OpenSearch Server 

- provides an OpenSearch interface to the data of a relational JDBC database
- maps a relational database into a index


Features
--------

- OpenSearch interface to JDBC database
- user friendly, GUI based mapping from relational database into flat index model
- scheduled indexing of DB data into the index


Requirements
-------------

- a running InGrid Software System

Installation
------------

Download from https://dev.informationgrid.eu/ingrid-distributions/ingrid-server-opensearch/
 
or

build from source with `mvn package assembly:single`.

Execute

```
java -jar ingrid-server-opensearch-x.x.x-installer.jar
```

and follow the install instructions.

Obtain further information at https://dev.informationgrid.eu/


Contribute
----------

- Issue Tracker: https://github.com/informationgrid/ingrid-server-opensearch/issues
- Source Code: https://github.com/informationgrid/ingrid-server-opensearch
 
### Set up eclipse project

```
mvn eclipse:eclipse
```

and import project into eclipse.

### Debug under eclipse

TBD

Support
-------

If you are having issues, please let us know: info@informationgrid.eu

License
-------

The project is licensed under the EUPL license.
