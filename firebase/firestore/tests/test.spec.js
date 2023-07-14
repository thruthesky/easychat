const assert = require("assert");

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

describe("Firestore security test", () => {
  it("Readonly", async () => {
    // Get doc
    const testDoc = db(a).collection("readonly").doc();

    // Test success on doc
    await firebase.assertSucceeds(testDoc.get());
  });
  it("Writing on readonly collection -> should be failed.", async () => {
    const testDoc = db(b).collection("readonly").doc();

    // Test error on doc
    await firebase.assertFails(testDoc.set({ test: "test" }));
  });

  it("Creating chat room failure test", async () => {
    const testDoc = db().collection("easy-chat-room").doc();
    await firebase.assertFails(testDoc.set({ test: "test" }));
  });

  it("Creating chat room -> success", async () => {
    await firebase.assertSucceeds(
      db(a).collection("easy-chat-rooms").add({ master: a.uid })
    );
  });
});
