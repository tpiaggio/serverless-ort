import React, { useState } from "react";
import * as firebase from "firebase";

const TimeForm = () => {
  const [title, setTitle] = useState();
  const [time, setTime] = useState();

  const handleSubmit = (e) => {
    e.preventDefault();

    firebase
      .database()
      .ref("times")
      .push({
        title,
        time_seconds: parseInt(time),
        user_id: firebase.auth().currentUser.uid,
      })
      .then(() => {
        setTitle("");
        setTime("");
      });
  };

  return (
    <form onSubmit={handleSubmit}>
      <h4>Add Time Entry</h4>
      <div>
        <label>Title</label>
        <input type="text" value={title} onChange={(e) => setTitle(e.currentTarget.value)} />
      </div>
      <div>
        <label>Time</label>
        <input type="number" value={time} onChange={(e) => setTime(e.currentTarget.value)} />
      </div>
      <button>Add Time Entry</button>
    </form>
  );
};

export default TimeForm;
