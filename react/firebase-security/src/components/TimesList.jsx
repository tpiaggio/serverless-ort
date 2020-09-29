import React, { useState, useEffect } from "react";
import * as firebase from "firebase";

const TimesList = () => {
  const [times, setTimes] = useState([]);

  useEffect(() => {
    const timesRef = firebase.firestore().collection("times").where("user_id", "==", firebase.auth().currentUser.uid);
    const unsubscribe = timesRef.onSnapshot((querySnapshot) => {
      const newTimes = [];
      querySnapshot.forEach(function (doc) {
        newTimes.push({
          id: doc.id,
          ...doc.data(),
        });
      });
      setTimes(newTimes);
    });

    return () => unsubscribe();
  }, []);

  const handleDelete = (id) => {
    firebase.firestore().collection("times").doc(id).delete();
  };

  return (
    <div>
      <h2>Times List</h2>
      <ol>
        {times.map((time) => (
          <li key={time.id}>
            <div className="time-entry">
              {time.title}
              <code className="time">{time.time_seconds} seconds</code>
              <button onClick={() => handleDelete(time.id)}>Delete</button>
            </div>
          </li>
        ))}
      </ol>
    </div>
  );
};

export default TimesList;
