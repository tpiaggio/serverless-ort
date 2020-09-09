import React, { useEffect } from "react";
import "./App.css";

import TimeList from "./components/TimesList";
import TimeForm from "./components/TimeForm";

function App() {
  useEffect(() => {
    // const speedRef = firebase.database().ref("speed");
    // speedRef.on("value", function (snapshot) {
    //   setState({
    //     speed: snapshot.val(),
    //   });
    // });
    // return () => speedRef.off();
  }, []);

  return (
    <div className="App">
      <h1>Time Tracker</h1>
      <TimeList />
      <TimeForm />
    </div>
  );
}

export default App;
