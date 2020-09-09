import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import * as firebase from "firebase";

var firebaseConfig = {
  apiKey: "AIzaSyCB1O4T5llQ0u06pntaUyS7WLradNMNJOs",
  authDomain: "asless-2.firebaseapp.com",
  databaseURL: "https://asless-2.firebaseio.com",
  projectId: "asless-2",
  storageBucket: "asless-2.appspot.com",
  messagingSenderId: "691794235890",
  appId: "1:691794235890:web:41d339d20e554cf01adb6b",
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root")
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
