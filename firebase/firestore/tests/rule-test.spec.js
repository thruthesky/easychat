const assert = require("assert");
const { db, a, b, c, d, tempChatRoomData, admin } = require("./setup");

// load firebase-functions-test SDK
const firebase = require("@firebase/testing");

describe("Rule tests", () => {
    it("onlyUpdating", async () => {

        const ref = await admin()
            .collection("test")
            .add({ a: 1, b: 2, c: 3 });
        
        snapshot = await ref.get();

        await firebase.assertSucceeds(
            db(a).collection("test").doc(ref.id).update({
                a: 10,
            })
        );
        await firebase.assertSucceeds(
            db(a).collection("test").doc(ref.id).update({
                b: 20,
            })
        );
        await firebase.assertSucceeds(
            db(a).collection("test").doc(ref.id).update({
                a: 11, b: 22,
            })
        );
        await firebase.assertFails(
            db(a).collection("test").doc(ref.id).update({
                a: 10, b: 20, c: 30
            })
        );
        await firebase.assertFails(
            db(a).collection("test").doc(ref.id).update({
                c: 33
            })
        );

    });
});

