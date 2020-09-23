import React from "react";
import firebase from "firebase";

import TimeList from "../components/TimesList";
import TimeForm from "../components/TimeForm";

function Home() {
  return (
    <>
      <div className="header">
        <h1>Welcome to Time Tracker, {firebase.auth().currentUser.displayName}!</h1>
        <button onClick={() => firebase.auth().signOut()}>Sign-out</button>
      </div>
      <TimeList />
      <TimeForm />
    </>
  );
}

export default Home;
