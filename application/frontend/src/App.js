import React, { useEffect, useState } from "react";
import API_URL from "./api";
import Login from "./Login";
import "./Login.css";

function App() {
  const [data, setData] = useState({});
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [loading, setLoading] = useState(false);
  const [fetchError, setFetchError] = useState(null);

  useEffect(() => {
    if (isLoggedIn) {
      setLoading(true);
      fetch(`${API_URL}/api/data`)
        .then((res) => {
          if (!res.ok) throw new Error(`Status ${res.status}`);
          return res.json();
        })
        .then((result) => {
          setData(result);
          setFetchError(null);
        })
        .catch((error) => {
          console.error("API Error:", error);
          setFetchError("Could not reach backend. Check ALB/security group config.");
        })
        .finally(() => setLoading(false));
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
    <div style={{ padding: "40px", fontFamily: "'Segoe UI', Arial, sans-serif" }}>
      <h1>AWS Three Tier Application - This is Kamalesh's website</h1>

      {loading && <p>Loading data...</p>}

      {fetchError && (
        <p style={{ color: "#e74c3c" }}>{fetchError}</p>
      )}

      {!loading && !fetchError && (
        <>
          <h2>{data.message}</h2>
          <p>{data.status}</p>
        </>
      )}

      <button onClick={() => setIsLoggedIn(false)}>Logout</button>
    </div>
  );
}

export default App;
