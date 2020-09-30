import React, { useState } from "react";
import * as firebase from "firebase";

const TimeForm = () => {
  const [title, setTitle] = useState();
  const [time, setTime] = useState();
  const [location, setLocation] = useState();
  const [file, setFile] = useState();

  const LOADING_IMAGE_URL = "https://www.google.com/images/spin-32.gif?a";

  const handleSubmit = (e) => {
    e.preventDefault();

    firebase
      .firestore()
      .collection("times")
      .add({
        title,
        time_seconds: parseInt(time),
        location,
        imageUrl: LOADING_IMAGE_URL,
        user_id: firebase.auth().currentUser.uid,
        weather: {},
      })
      .then((timesRef) => {
        setTitle("");
        setTime("");
        setLocation("");
        const filePath = firebase.auth().currentUser.uid + "/" + timesRef.id + "/" + file.name;
        return firebase
          .storage()
          .ref(filePath)
          .put(file)
          .then(function (fileSnapshot) {
            return fileSnapshot.ref.getDownloadURL().then((url) => {
              return timesRef.update({
                imageUrl: url,
                storageUri: fileSnapshot.metadata.fullPath,
              });
            });
          });
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
      <div>
        <label>Location</label>
        <input type="text" value={location} onChange={(e) => setLocation(e.currentTarget.value)} />
      </div>
      <div>
        <label>Image</label>
        <input type="file" accept="image/*" onChange={(e) => setFile(e.target.files[0])} />
      </div>
      <button>Add Time Entry</button>
    </form>
  );
};

export default TimeForm;
