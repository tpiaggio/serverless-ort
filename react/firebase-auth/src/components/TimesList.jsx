import React, { useState, useEffect } from "react";
import * as firebase from "firebase";

const TimesList = () => {
  const [times, setTimes] = useState([]);

  useEffect(() => {
    const timesRef = firebase.database().ref("times").orderByChild("user_id").equalTo(firebase.auth().currentUser.uid);
    timesRef.on("value", (snapshot) => {
      const timesObj = snapshot.val();
      if (!timesObj) return;
      const newTimes = Object.keys(timesObj).map((id) => ({
        id,
        ...timesObj[id],
      }));
      setTimes(newTimes);
    });

    return () => timesRef.off();
  }, []);

  const handleDelete = (id) => {
    firebase.database().ref(`times/${id}`).remove();
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
