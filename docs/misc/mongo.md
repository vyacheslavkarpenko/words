MongoDB is an open-source and cross-platform document-oriented NoSQL database that is popular in building fast and scalable applications that handle massive amounts of data. Unlike traditional relational databases where data is stored in tables, MongoDB uses JSON format to store data in documents. In JSON format, data is formatted in key-value pairs where field names and values are separated by a colon and encapsulated in curly braces.

Due to its flexible schema, MongoDB is a natural choice for developers who need to build fast, and highly scalable applications which can process high volumes of data.

MongoDB’s most recent release is v5.0. It was released on July 13th, 2021, and ships with new features and enhancements which include:

Multi-Cloud client-side encryption.
Live Resharding of databases.
Native Time Series Platform with windows functions and clustered indexing.
A stable API that makes it easy to upgrade to the latest version without impacting your codebase.
Atlas Search full-text search solution.
And so much more. You can find a comprehensive list of additional features and fixes in the latest release of MongoDB, by checking out the MongoDB 5.0 release notes.

In this guide, we will focus on installing the MongoDB Community Edition on Ubuntu 20.04.

Step 1: Install MongoDB
The first step is to install the prerequisite packages needed during the installation. To do so, run the following command.

sudo apt install -y software-properties-common gnupg apt-transport-https ca-certificates
The official Ubuntu repositories provide the MongoDB package which can be installed in one command using the APT package manager as follows:

sudo apt install -y mongodb
However, the version of MongoDB provided by the repositories is not the latest one. At the time of publishing this guide, the version provided by the Ubuntu repositories is v3.6.8. Meanwhile, the latest stable version provided by MongoDB is 5.0.

To install the most recent MongoDB package, you need to add the MongoDB package repository to your sources list file on Ubuntu.

But first, you need to import the public key for MongoDB on your system using the wget command as follows:

wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
This command generates the following output indicating that the public key has been added

Ouput:

OK
Next, add MongoDB’s APT repository to the /etc/apt/sources.list.d directory.

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
The command adds the mongodb-org-5.0.list file to the /etc/apt/sources.list.d/ directory. This file contains the following line:

deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse
Once the repository is added, reload the local package index.

sudo apt update
The command refreshes the local repositories and makes Ubuntu aware of the newly added MongoDB repository.

Once that is out of the way, install the mongodb-org meta-package that provides MongoDB.

sudo apt install -y mongodb-org
When the installation is complete, you can verify the version of MongoDB installed as shown:

mongod --version
The command displays some output about MongoDB including the version, and Git version among other details.

Step 2: Start and enable the MongoDB service
By default, the MongoDB service is disabled upon installation. You can verify this by running the command:

sudo systemctl status mongod
To start the MongoDB service execute the command:

sudo systemctl start mongod
Once again, confirm if the service is running:

sudo systemctl status mongod
From the above output, you can see that MongoDB is up and running. Additionally, you can confirm that the database is up and running by initiating a connection to the database server and running a diagnostic command.

The command shown connects to the database and displays the current version of MongoDB, server URL, and port it is listening on.

mongo --eval 'db.runCommand({ connectionStatus: 1 })'
Additionally, it returns the value of MongoDB’s internal connectionStatus command:

The value 1 for the “ok” parameter indicates that the database server is running as expected. In the second line, you can see the server’s URL which is the localhost address ( 127.0.0.1) and the default port ( 27017) that MongoDB is listening on.

You can also check the default port as follows

sudo ss -pnltu | grep 27017
After verifying that the service is running as expected, you can now enable MongoDB to start on boot as shown.

sudo systemctl enable mongod
So far, MongoDB has successfully been installed and configured to start on boot.

Step 3: Create a database and a user in MongoDB
Up to this point, your MongoDB instance should be running and configured for remote access. Let’s now shift gears and explore how to create a database and a user in MongoDB.

To access MongoDB, run the following command:

mongosh
Before you drop to the MongoDB shell, you will see some information about MongoDB such as the version of MongoDB and MongoDB shell as well as the URL for the Mongosh documentation.

Just above the Mongo shell prompt, you will also see a warning indicating that access control has not been enabled for the database and that read and write access to data and configuration is restricted. This warning is displayed because authentication has not yet been enabled. So don’t worry, this warning will disappear once authentication to the database is enabled.

By default, there are three databases that are created upon installation. These are admin, config, and local. `To list the existing databases, run the command:

> show dbs
To create a database invoke the use command followed by the database name. For example, to create a database called employees run the command:

> use employees
To confirm the database you can currently in, run the db command. In this case, you will get employees as the output

> db
MongoDB provides a number of shell methods for managing your database. The db.createUser method allows you to create a new user in a database.

The method requires you to define the username and password of the user and any roles that you wish to grant the user. This information is presented in JSON format.

Here is the syntax of how you can create a user called cherry with read and write roles on the employees database.

db.createUser(
  {
    user: "cherry",
    pwd: "some_password",
    roles: [ { role: "readWrite", db: "employees" } ]
  }
)
You can list the users created using the db.getUsers() method as shown.

db.getUsers();
Alternatively, you can run the command:

> show users
Ouput:

[
  {
    _id: 'employees.cherry',
    userId: UUID("lcde5d41-fbba-4c94-806e-6a3c25709f02"),
    user: 'cherry',
    db: 'employees',
    roles: [ { role: 'readWrite', db: 'employees' } ],
    mechanisms: [ 'SCRAM-SHA-1', 'SCRAM-SHA-256' ]
  }
]
To delete the user, use the db.dropUser method as shown.

db.dropUser("cherry", {w: "majority", wtimeout: 4000})
Ouput:

{ ok: 1 }
Step 4: Secure MongoDB
In MongoDB, Authentication is not enabled by default, implying that any user with access to the database server can view, add and delete data without any permissions. This is a serious vulnerability that can cause a serious breach of your data. In light of this, we will go a step further and demonstrate how you can secure MongoDB.

The first step is to create an administrative user and to do so, first, access the Mongo Shell.

mongosh
Next, connect or switch to the admin database.

> use admin
Next, create the database user by pasting these lines and hitting ENTER on the keyboard.

db.createUser(
  {
    user: "AdminCherry",
    pwd: passwordPrompt(),
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
 }
)
Let us break down this code.

The user: "AdminCherry" line creates an Administrative user called AdminCherry.

The pwd: passwordPrompt() method prompts you for the administrative user’s password. This is a safer alternative to the pwd: field which requires you to type the password in cleartext.

The roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ] line specifies the roles granted to the administrative user. Here, the Administrative user is granted read and write permissions to the admin database. And since this role is defined in the admin database, the administrative user, in effect, can read and modify all the databases in the cluster.

Here is the output after running the command.

To exit from the Mongo Shell, run the exit command or press CTRL + C.

With the Admin user in place, the next step is to enable authentication. To do this, open the mongod.conf file.

sudo nano /etc/mongod.conf
Scroll down and locate the security section. Uncomment it and add the authorization directive and set it to enabled.

security:
  authorization: enabled
Note that the authorization parameter is indented while security has no space at the beginning.

Save the changes and exit from the configuration file. To apply the changes, restart the Mongo service as shown.

sudo systemctl restart mongod
Also, be sure to check if the service is running as expected.

sudo systemctl status mongod
Now login to Mongo Shell.

mongosh
This time around you will observe that the warnings have disappeared.

However, if you try to perform any database-related task such as viewing databases, you will get some output indicating that authentication is required.

> show dbs
To log in with authentication, first, log out of the Mongo Shell by running the exit command. Then log in using the administrative user using the following syntax.

mongosh  "mongodb://adminuser@mongo-ip-address:27017"
Provide the administrative user’s password, and this time around, all the authentication warnings that you encountered before will have disappeared.

From this point going forward, only the administrative user will have the privileges to view, create and modify data in the databases.

Step 5: Configure MongoDB for remote access
By default, MongoDB is set to be accessed locally on the same server it is installed. To enable remote access, you need to edit the /etc/mongod.conf file which is the main configuration file for MongoDB.

It contains settings for the database storage location, logging, networking, and process management to mention a few.

So, access the configuration file using your text editor.

sudo nano /etc/mongod.conf
Locate the network interfaces section and pay attention to the bindIPvalue.

# network interfaces
net:
  port: 27017
  bindIp: 127.0.0.1
By default, MongoDB s bound to 127.0.0.1 which is the loopback address interface. This implies that MongoDB is only able to accept connections from the same server where it is installed.

To allow remote access, add a comma, then followed by the Mongo server’s IP address.

   bindIp: 127.0.0.1, mongo-server-ip
Save the changes and exit the configuration file. To apply the changes made, restart the MongoDB service.

sudo systemctl restart mongod
If you have UFW enabled, run the following command to allow incoming connections from a remote machine.

sudo ufw allow from remote_machine_ip to any port 27017
To effect the changes, reload the firewall.

sudo ufw reload
Step 6: Access MongoDB remotely
There are a couple of ways of accessing the MongoDB shell remotely. You can use the netcat utility to initiate a TCP connection to port 27017 which is the default port that MongoDB listens to.

If the netcat is not installed on the client machine, install it as follows.

sudo apt install netcat
To establish a connection to the MongoDB server via port 27017, run the command:

nc -zv mongodb_server_ip 27017
The following output indicates that the connection was successful.

Output:

Connection to mongodb_server_ip 27017 port [tcp/*] succeeded!
Alternatively, you can log in using Mongo Shell as follows.

mongosh "mongodb://username@mongo_server_ip:27017"
The shell automatically prompts you for the admin user’s password.

💡 Pro Tip: When using Mongo Shell login option ensure that the version of Mongo shell on both the client and remote MongoDB server is the same.

Step 7: Work with MongoDB database
There are quite a few database operations that you can carry out in MongoDB. For example, you can create, retrieve, update and delete records from a database.

Insert data
To create a document in a collection, use the .insertOne() method. The method supports several data types such as strings, integers, boolean values, and arrays.

In the previous step, we created a test database called employees. We will now create a collection and add a few documents. A collection comprises one or more documents

The command below creates a collection called staff and adds a document with some user data as shown.

db.staff.insertOne({ name: "Alice", age: 25, city: "London", married: true, hobbies: ["Travelling", "Swimming", "Cooking"] })
Once the command successfully executes you will get the following output.

Output:

{
  acknowledged: true,
  insertedId: ObjectId("62647ff866c1f054568a11b5")
}
Retrieve data
With a document already created in the staff collection, you can retrieve it and filter the results using the .find() method.

For example, to retrieve all the documents in the staff collection, run the command:

db.staff.find()
Output:

[
  {
    _id: ObjectId("62647ff866c1f054568a11b5"),
    name: 'Alice',
    age: 25,
    city: 'London',
    married: true,
    hobbies: [ 'Travelling', 'Swimming', 'Cooking' ]
  }
]
Let us now try something ambitious. We will add a few more documents and run a few queries on the collection.

db.staff.insertOne({ name: "Bob", age: 29, city: "Liverpool", married: false, hobbies: ["Hiking", "Watching movies", "Driving"] })
db.staff.insertOne({ name: "Winnie", age: 25, city: "Bristol", married: true, hobbies: ["Playing chess", "Surfing", "Painting"] })
To query records of employees who are married, run the following command:

db.staff.find({ married: true })
The output provides records of married employees only.

Output:

[
  {
    _id: ObjectId("62647ff866c1f054568a11b5"),
    name: 'Alice',
    age: 25,
    city: 'London',
    married: true,
    hobbies: [ 'Travelling', 'Swimming', 'Cooking' ]
  },
  {
    _id: ObjectId("626483d6b490694bc675b767"),
    name: 'Winnie',
    age: 25,
    city: 'Bristol',
    married: true,
    hobbies: [ 'Playing chess', 'Surfing', 'Painting' ]
  }
]
Update data
To update or modify records, use the .update() method. In this example, we demonstrate how you can change the name value of the second record from Bob to Robert.

db.staff.update({ name: "Bob" }, {$set: { name: "Robert" }})
The output shown confirms that the update of the record was successful.

Output:

{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
You can now query to see if you can find a record that matches the name Robert as follows.

db.staff.find({ name: "Robert" })
Output:

[
  {
    _id: ObjectId("626483c8b490694bc675b766"),
    name: 'Robert',
    age: 29,
    city: 'Liverpool',
    married: false,
    hobbies: [ 'Hiking', 'Watching movies', 'Driving' ]
  }
]
Delete data
MongoDB shell provides two methods for deleting records:

.deleteOne()
.deleteMany() 
The .deleteOne() method is used to delete a single record or document from a collection.

The .deleteMany() method deletes multiple documents from a collection.

The best way to remove a single record is by using the record’s _id value. This is a unique value given to each record and is preferred over defining individual entries as shown below which would result in the deletion of every record bearing the name Robert.

db.staff.deleteOne({ name: "Robert"})
Therefore, to safely delete Robert record without affecting other records which would have the same name value, specify the _id value instead.

db.staff.deleteOne({ _id: ObjectId("626483c8b490694bc675b766")})
Output:

{ acknowledged: true, deletedCount: 1 }
Additionally, you can delete documents based on a certain criterion. In this case, use the .deleteMany() method for deleting multiple records.

For example, to delete all documents in the staff collection where employees are married, run the command:

db.staff.deleteMany({married: true})
Output:

{ acknowledged: true, deletedCount: 1 }
To delete all the documents in the collection, use the .deleteMany() method without any arguments:

db.staff.deleteMany({})
If you try querying the collection, you will notice that the output will be blank, a clear indication that all the documents have been deleted and that the collection is now empty.

Conclusion
MongoDB is a powerful and flexible NoSQL database whose popularity is on a steady rise. It’s a popular database of choice for building mission-critical applications that handle vast amounts of unstructured data.

In this guide, you learned how to install and start using MongoDB on Ubuntu 20.04. For more information, head over to the official MongoDB documentation.