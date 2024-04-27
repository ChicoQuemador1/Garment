/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
exports.updateBagOnProductChange = functions.firestore
    .document('products/{productId}')
    .onUpdate((change, context) => {
        const newData = change.after.data();
        const previousData = change.before.data();

        // Exit if the data is the same
        if (JSON.stringify(newData) === JSON.stringify(previousData)) {
            console.log('No change in data, exit function');
            return null;
        }

        const productId = context.params.productId;
        console.log(`Product ID ${productId} has been updated`);

        // Fetch all bags containing this product
        const db = admin.firestore();
        return db.collection('bags').where('productId', 'array-contains', productId).get()
            .then(snapshot => {
                let promises = [];
                snapshot.forEach(doc => {
                    // Update each bag with the new product information
                    let bagData = doc.data();
                    let productIndex = bagData.products.findIndex(p => p.id === productId);
                    if (productIndex !== -1) {
                        bagData.products[productIndex] = { ...bagData.products[productIndex], ...newData };
                        promises.push(doc.ref.update({ products: bagData.products }));
                    }
                });
                return Promise.all(promises);
            })
            .catch(error => {
                console.error("Error updating bags: ", error);
            });
    });
