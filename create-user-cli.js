const CryptoJS = require("crypto-js");
const readline = require("readline");
const connectToMongo = require("./utils/db");
const User = require("./models/User");

const hashPassword = (password) => {
  return CryptoJS.SHA256(password).toString();
};

const createUser = async (name, email, password, rl) => {
  const hashedPassword = hashPassword(password);
  const user = new User({
    name: name,
    email: email,
    password: hashedPassword,
  });

  try {
    await user.save();
    console.log("User created successfully!");
  } catch (err) {
    console.error("Error creating user:", err.message);
  } finally {
    rl.close();
    process.exit(0);
  }
};

const run = async () => {
  // 1. Force the connection and wait for its log to finish
  await connectToMongo();

  // 2. Initialize Readline ONLY after connection is successful
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  // 3. Start the prompts
  rl.question("Enter name: ", function (name) {
    rl.question("Enter email: ", function (email) {
      rl.question("Enter password: ", function (password) {
        createUser(name, email, password, rl);
      });
    });
  });
};

run();