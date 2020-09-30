import admin = require('firebase-admin');
import * as functions from 'firebase-functions';

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

//initialize firebase inorder to access its services
admin.initializeApp(functions.config().firebase);

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hola desde firebase, sisi");
});

 const token:string = "fR6bHKwZTfa9cz1rEC8BWK:APA91bGVBxn7MG7XyhgoqnCYW-dtkGYHbrYy76zjTxU1DNEKXwMDlAVUCdKDwr3EJ8AswbFDtjBq-to7jP0volqiHfS5Y033gN8A8MVpRKa5YeUlNvEUXM0I2QkEVINV-eGQdf5xQCDm";

exports.pushNotification = functions.https.onRequest((request, response) =>{
  const payload = {
      notification: {
          title: 'You have been invited to a trip.',
          body: 'Tap here to check it out!'
      }
  };
  admin.messaging().sendToDevice(token, payload).then((_)=>{functions.logger.info("Hello logs!", {structuredData: true})}).catch((error)=>{functions.logger.info(error, {structuredData: true})});
  response.send("listo");
})
