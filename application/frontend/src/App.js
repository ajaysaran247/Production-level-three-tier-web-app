import React, { useEffect, useState } from "react";
import API_URL from "./api";
import Login from "./Login";
import "./Login.css";

function App() {
  const [data, setData] = useState({});
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    if (isLoggedIn) {
      fetch(API_URL)
        .then((res) => res.json())
        .then((result) => setData(result))
        .catch((error) => console.error("API Error:", error));
    }
  }, [isLoggedIn]);

  if (!isLoggedIn) {
    return (
      <div className="login-page-wrapper">
        <Login onLoginSuccess={() => setIsLoggedIn(true)} />
      </div>
    );
  }

  return (
    <div>
      <h1>AWS Three Tier Application - This is Kamalesh's website</h1>
      <h2>{data.message}</h2>
      <p>{data.status}</p>
      <button onClick={() => setIsLoggedIn(false)}>Logout</button>
    </div>
  );
}

export default App;
