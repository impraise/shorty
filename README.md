Shorty Challenge
================

### Prerequisites

Install below before going through the Setup

* [Node.js + NPM](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
* [MongoDB](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/#install-mongodb-community-edition)

### Setup

````
$ cd path/to/shorty
$ npm install
$ mkdir data && mongod --dbpath=./data --fork --logpath mongo-log.log # This will make MongoDB run in the background and keep all the data contained to the data directory in our service.
````

### Run

```
$ npm start
```

This will start the API server (`SERVER_PORT`) and open a connection to the MongoDB instance you ran above. Different databases are used for development (`DB_URL`) and testing (`TEST_DB_URL`). You can override these variables by creating a .env file in root of the directory. Below are the default values for these:

```
SERVER_PORT=3200
DB_URL=mongodb://localhost/shortydb
TEST_DB_URL=mongodb://localhost/test
```

### Tests

```
$ npm test
```

This will run all the tests in all the folders in the test directory. 