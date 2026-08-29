import React, { useEffect, useState } from "react";
import API_URL from "./api";

function App() {
  const [data, setData] = useState({});

  useEffect(() => {
    fetch(API_URL)
      .then(res => res.json())
      .then(result => setData(result))
      .catch(error => console.error("API Error:", error));
  }, []);

  return (
    <div>
      <h1>AWS Three Tier Application This is kamalesh website</h1>
      <h1>AWS Three Tier Application</h1>
      <h2>{data.message}</h2>
      <p>{data.status}</p>
    </div>
  );
}

export default App;
