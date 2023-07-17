// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

// Firebase project that the tests connect to.
const TEST_PROJECT_ID = "withcenter-test-2";

const a = { uid: "uid-A", email: "apple@gmail.com" };
const b = { uid: "uid-B", email: "banana@gmail.com" };
const c = { uid: "uid-C", email: "cherry@gmail.com" };
const d = { uid: "uid-D", email: "durian@gmail.com" };

// Connect to Firestore with a user permission.
function db(auth = null) {
  return firebase
    .initializeTestApp({ projectId: TEST_PROJECT_ID, auth: auth })
    .firestore();
}

// Connect to Firestore with admin permssion. This will pass all the rules.
function admin() {
  return firebase
    .initializeAdminApp({ projectId: TEST_PROJECT_ID })
    .firestore();
}

/**
 * Returns fake chat room data
 *
 *
 * By default,
 *  - createdAt: new Date()
 *  - group: false
 *  - open: false
 *  - no uid.
 *
 *
 * @param {*} options
 * @returns returns chat room data
 */
function tempChatRoomData(options = {}) {
  return Object.assign(
    {},
    {
      createdAt: new Date(),
      group: false,
      open: false,
    },
    options
  );
}

exports.db = db;
exports.admin = admin;
exports.tempChatRoomData = tempChatRoomData;
exports.a = a;
exports.b = b;
exports.c = c;
exports.d = d;
exports.TEST_PROJECT_ID = TEST_PROJECT_ID;
